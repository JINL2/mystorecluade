/// User Companies Presentation Layer Providers
///
/// This file contains user companies related providers.
/// Core provider that loads user data, companies, stores, and handles session.
///
/// Extracted from homepage_providers.dart for better organization.
library;

import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/monitoring/sentry_config.dart';
import '../../../../core/services/revenuecat_service.dart';
import '../../../auth/presentation/providers/auth_service.dart';
import '../../domain/entities/user_with_companies.dart';
import '../../domain/mappers/user_entity_mapper.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/usecases/auto_select_company_store.dart';

// ============================================================================
// User Companies Providers
// ============================================================================

/// Global user companies provider (returns Map for backward compatibility)
///
/// This provider is used globally across the app and returns Map<String, dynamic>
/// for backward compatibility with existing code.
///
/// TIMEOUT: If user data doesn't load within 20 seconds, auto-logout occurs.
/// This handles edge cases like orphan auth sessions (auth.users exists but public.users deleted).
final userCompaniesProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final appState = ref.read(appStateProvider);

  // Get user from auth state
  final user = authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );

  if (user == null) {
    return null;
  }

  try {
    // Fetch user companies data from repository with 20 second timeout
    final repository = ref.read(homepageRepositoryProvider);
    final userEntity = await repository.getUserCompanies(user.id)
        .timeout(
          const Duration(seconds: 20),
          onTimeout: () {
            throw TimeoutException('User data load timeout after 20 seconds');
          },
        );

    // Convert entity to Map once (avoid duplication)
    final userData = convertUserEntityToMap(userEntity);

    // Always update AppState.user with fresh data (includes companies with subscription)
    // This ensures CompanyStoreSelector and other widgets get updated subscription data
    appStateNotifier.updateUser(
      user: userData,
      isAuthenticated: true,
    );

    // Login to RevenueCat with Supabase user ID
    // This links the user's subscription data across devices
    try {
      await RevenueCatService().loginUser(user.id);
    } catch (e, stackTrace) {
      // RevenueCat login failure shouldn't block user data loading
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'RevenueCat login failed',
        extra: {'userId': user.id},
      );
    }

    // Auto-select company and store using UseCase
    if (userEntity.companies.isNotEmpty && appState.companyChoosen.isEmpty) {
      // Load last selection from cache
      final lastSelection = await appStateNotifier.loadLastSelection();

      // Execute auto-select use case (business logic encapsulated)
      final autoSelect = AutoSelectCompanyStore();
      final selection = autoSelect(
        AutoSelectParams(
          userEntity: userEntity,
          lastCompanyId: lastSelection['companyId'],
          lastStoreId: lastSelection['storeId'],
        ),
      );

      // Update app state with selected company/store and subscription
      if (selection.hasSelection) {
        appStateNotifier.updateBusinessContext(
          companyId: selection.company!.id,
          storeId: selection.store?.id ?? '',
          companyName: selection.company!.companyName,
          storeName: selection.store?.storeName,
          subscription: selection.company!.subscription?.toMap(),
        );
      }
    } else if (userEntity.companies.isNotEmpty && appState.companyChoosen.isNotEmpty) {
      // Company already selected - still update subscription data on refresh
      // Find the currently selected company and update its subscription
      final selectedCompany = userEntity.companies.firstWhere(
        (c) => c.id == appState.companyChoosen,
        orElse: () => userEntity.companies.first,
      );

      // Find the actual store name from the selected store ID
      // This fixes cached storeName being incorrect (e.g., store_code instead of store_name)
      String? actualStoreName = appState.storeName;
      if (appState.storeChoosen.isNotEmpty && selectedCompany.stores.isNotEmpty) {
        try {
          final selectedStore = selectedCompany.stores.firstWhere(
            (s) => s.id == appState.storeChoosen,
          );
          actualStoreName = selectedStore.storeName;
        } catch (_) {
          // Store not found - use first store as fallback
          if (selectedCompany.stores.isNotEmpty) {
            actualStoreName = selectedCompany.stores.first.storeName;
          }
        }
      }

      // Update subscription data without changing company/store selection
      appStateNotifier.updateBusinessContext(
        companyId: selectedCompany.id,
        storeId: appState.storeChoosen,
        companyName: selectedCompany.companyName,
        storeName: actualStoreName,
        subscription: selectedCompany.subscription?.toMap(),
      );
    }

    // Return Map (already converted once, reuse userData)
    return userData;
  } on TimeoutException catch (e, stackTrace) {
    // Timeout - auto logout and throw error
    SentryConfig.captureException(
      e,
      stackTrace,
      hint: 'UserCompanies timeout - forcing logout',
    );

    // Sign out from RevenueCat
    await RevenueCatService().logoutUser();

    // Sign out the user
    await ref.read(authServiceProvider).signOut();

    // Clear app state
    appStateNotifier.signOut();

    throw Exception('Session expired. Please sign in again.');
  } catch (e, stackTrace) {
    // Other errors (e.g., user profile not found in public.users)
    // If error contains "No user companies data" - orphan auth session
    if (e.toString().contains('No user companies data')) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'UserCompanies orphan auth session - forcing logout',
      );

      // Sign out from RevenueCat
      await RevenueCatService().logoutUser();

      // Sign out the user
      await ref.read(authServiceProvider).signOut();

      // Clear app state
      appStateNotifier.signOut();

      throw Exception('Account data not found. Please sign in again.');
    }

    SentryConfig.captureException(
      e,
      stackTrace,
      hint: 'UserCompanies error loading user data',
    );
    rethrow;
  }
});

/// Entity-based provider for homepage (Clean Architecture)
///
/// This provider returns UserWithCompanies entity for use within the homepage feature.
/// It leverages the global userCompaniesProvider and converts Map to Entity WITHOUT
/// making additional network requests (performance optimization).
final userCompaniesEntityProvider = Provider<AsyncValue<UserWithCompanies?>>((ref) {
  final userDataMapAsync = ref.watch(userCompaniesProvider);

  return userDataMapAsync.when(
    data: (userDataMap) {
      if (userDataMap == null) {
        return const AsyncValue.data(null);
      }

      // Convert Map to Entity (no network request, just data transformation)
      try {
        final entity = convertMapToUserEntity(userDataMap);
        return AsyncValue.data(entity);
      } catch (e, stackTrace) {
        return AsyncValue.error(e, stackTrace);
      }
    },
    loading: () => const AsyncValue.loading(),
    error: (error, stackTrace) => AsyncValue.error(error, stackTrace),
  );
});
