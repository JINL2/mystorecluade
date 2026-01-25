/// User Companies Presentation Layer Providers
///
/// This file contains user companies related providers.
/// Core provider that loads user data, companies, stores, and handles session.
///
/// Uses SWR (Stale-While-Revalidate) pattern:
/// 1. Return cached data immediately (if available)
/// 2. Fetch fresh data in background
/// 3. Update UI when fresh data arrives
///
/// Extracted from homepage_providers.dart for better organization.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state.dart';
import '../../../../app/providers/app_state_notifier.dart';
import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/monitoring/sentry_config.dart';
import '../../../../core/services/revenuecat_service.dart';
import '../../../../core/subscription/index.dart';
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
/// SWR (Stale-While-Revalidate) Pattern:
/// 1. If cache exists and valid → return immediately + refresh in background
/// 2. If no cache → fetch from API (with 20s timeout)
///
/// TIMEOUT: If user data doesn't load within 20 seconds, auto-logout occurs.
/// This handles edge cases like orphan auth sessions (auth.users exists but public.users deleted).
final userCompaniesProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  final authState = ref.watch(authStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final appState = ref.read(appStateProvider);
  final cache = HiveCacheService.instance;

  // Get user from auth state
  final user = authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );

  if (user == null) {
    return null;
  }

  // =========================================================================
  // SWR Step 1: Try to load from Hive cache first
  // =========================================================================
  final cachedData = await cache.getUserCompanies(user.id);

  if (cachedData != null) {
    if (kDebugMode) {
      debugPrint('📦 [SWR] Using cached user companies data');
    }

    // Restore AppState from cache immediately
    await _initializeAppStateFromData(
      ref,
      cachedData,
      appStateNotifier,
      appState,
      isFromCache: true,
    );

    // Trigger background refresh (non-blocking)
    _refreshUserCompaniesInBackground(ref, user.id);

    // Return cached data immediately (UI shows instantly!)
    return cachedData;
  }

  // =========================================================================
  // SWR Step 2: No cache - fetch from API
  // =========================================================================
  if (kDebugMode) {
    debugPrint('🌐 [SWR] No cache, fetching from API...');
  }

  return await _fetchAndCacheUserCompanies(ref, user.id, appStateNotifier, appState);
});

/// Initialize AppState from user data (cache or fresh)
Future<void> _initializeAppStateFromData(
  Ref ref,
  Map<String, dynamic> userData,
  AppStateNotifier appStateNotifier,
  AppState appState, {
  required bool isFromCache,
}) async {
  // Update AppState.user
  appStateNotifier.updateUser(
    user: userData,
    isAuthenticated: true,
  );

  // Convert to entity for auto-select logic
  final userEntity = convertMapToUserEntity(userData);

  // Auto-select company and store
  if (userEntity.companies.isNotEmpty && appState.companyChoosen.isEmpty) {
    final lastSelection = await appStateNotifier.loadLastSelection();

    final autoSelect = AutoSelectCompanyStore();
    final selection = autoSelect(
      AutoSelectParams(
        userEntity: userEntity,
        lastCompanyId: lastSelection['companyId'],
        lastStoreId: lastSelection['storeId'],
      ),
    );

    if (selection.hasSelection) {
      final subscriptionMap = selection.company!.subscription?.toMap();

      appStateNotifier.updateBusinessContext(
        companyId: selection.company!.id,
        storeId: selection.store?.id ?? '',
        companyName: selection.company!.companyName,
        storeName: selection.store?.storeName,
        subscription: subscriptionMap,
        storeCount: selection.company!.storeCount,
        employeeCount: selection.company!.employeeCount ?? 0,
      );
    }

    // Update usage counts from userEntity data
    // Note: userEntity.companyCount uses ownedCompanyCount from RPC (OWNED companies only)
    // for subscription limit checking, with fallback to companies.length
    appStateNotifier.updateUsageCounts(
      companyCount: userEntity.companyCount,
      totalStoreCount: userEntity.totalStoreCount,
      totalEmployeeCount: userEntity.totalEmployeeCount,
      currentStoreCount: selection.company?.storeCount,
      currentEmployeeCount: selection.company?.employeeCount,
    );
  } else if (userEntity.companies.isNotEmpty && appState.companyChoosen.isNotEmpty) {
    // Company already selected - update subscription data
    final selectedCompany = userEntity.companies.firstWhere(
      (c) => c.id == appState.companyChoosen,
      orElse: () => userEntity.companies.first,
    );

    String? actualStoreName = appState.storeName;
    if (appState.storeChoosen.isNotEmpty && selectedCompany.stores.isNotEmpty) {
      try {
        final selectedStore = selectedCompany.stores.firstWhere(
          (s) => s.id == appState.storeChoosen,
        );
        actualStoreName = selectedStore.storeName;
      } catch (_) {
        if (selectedCompany.stores.isNotEmpty) {
          actualStoreName = selectedCompany.stores.first.storeName;
        }
      }
    }

    final subscriptionMap = selectedCompany.subscription?.toMap();

    appStateNotifier.updateBusinessContext(
      companyId: selectedCompany.id,
      storeId: appState.storeChoosen,
      companyName: selectedCompany.companyName,
      storeName: actualStoreName,
      subscription: subscriptionMap,
      storeCount: selectedCompany.storeCount,
      employeeCount: selectedCompany.employeeCount ?? 0,
    );

    // Update usage counts from userEntity
    // Note: userEntity.companyCount uses ownedCompanyCount from RPC (OWNED companies only)
    appStateNotifier.updateUsageCounts(
      companyCount: userEntity.companyCount,
      totalStoreCount: userEntity.totalStoreCount,
      totalEmployeeCount: userEntity.totalEmployeeCount,
      currentStoreCount: selectedCompany.storeCount,
      currentEmployeeCount: selectedCompany.employeeCount,
    );
  }

  // Login to RevenueCat (only on fresh data, not cache)
  if (!isFromCache) {
    try {
      final user = ref.read(authStateProvider).value;
      if (user != null) {
        await RevenueCatService().loginUser(user.id);

        // Initialize SubscriptionStateNotifier for real-time updates
        // This sets up RevenueCat listener + Supabase Realtime subscription
        await ref
            .read(subscriptionStateNotifierProvider.notifier)
            .initialize(user.id);

        if (kDebugMode) {
          debugPrint('✅ [SubscriptionState] Initialized for user: ${user.id}');
        }
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'RevenueCat login failed',
      );
    }
  }
}

/// Background refresh for SWR pattern
///
/// Note: We capture providers BEFORE async gap to avoid ref state issues
void _refreshUserCompaniesInBackground(
  Ref ref,
  String userId,
) {
  // Capture providers BEFORE async gap to avoid ref state issues
  final repository = ref.read(homepageRepositoryProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);
  final appState = ref.read(appStateProvider);
  final subscriptionNotifier =
      ref.read(subscriptionStateNotifierProvider.notifier);

  // Fire and forget - don't await
  Future(() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 [SWR] Background refresh started...');
      }

      final userEntity = await repository.getUserCompanies(userId).timeout(
        const Duration(seconds: 20),
        onTimeout: () {
          throw TimeoutException('Background refresh timeout');
        },
      );

      final userData = convertUserEntityToMap(userEntity);

      // Save to cache
      await HiveCacheService.instance.saveUserCompanies(userId, userData);

      // ✅ Update AppState with fresh data (usage counts)
      _updateAppStateWithFreshData(
        userEntity,
        appStateNotifier,
        appState,
      );

      // Login to RevenueCat with fresh data
      try {
        await RevenueCatService().loginUser(userId);

        // Initialize/refresh SubscriptionStateNotifier
        await subscriptionNotifier.initialize(userId);
        if (kDebugMode) {
          debugPrint('✅ [SWR] SubscriptionState initialized in background');
        }
      } catch (_) {}

      if (kDebugMode) {
        debugPrint('✅ [SWR] Background refresh completed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SWR] Background refresh failed: $e');
      }
      // Don't throw - background refresh failure is non-critical
    }
  });
}

/// Update AppState with fresh data from background refresh
void _updateAppStateWithFreshData(
  UserWithCompanies userEntity,
  AppStateNotifier appStateNotifier,
  AppState appState,
) {
  // Find current selected company to get its counts
  int? currentStoreCount;
  int? currentEmployeeCount;

  if (appState.companyChoosen.isNotEmpty) {
    try {
      final selectedCompany = userEntity.companies.firstWhere(
        (c) => c.id == appState.companyChoosen,
      );
      currentStoreCount = selectedCompany.storeCount;
      currentEmployeeCount = selectedCompany.employeeCount;

      // Also update subscription data if changed
      if (selectedCompany.subscription != null) {
        appStateNotifier.updateBusinessContext(
          companyId: selectedCompany.id,
          storeId: appState.storeChoosen,
          companyName: selectedCompany.companyName,
          storeName: appState.storeName,
          subscription: selectedCompany.subscription!.toMap(),
          storeCount: selectedCompany.storeCount,
          employeeCount: selectedCompany.employeeCount ?? 0,
        );
      }
    } catch (_) {
      // Company not found - use first company if available
      if (userEntity.companies.isNotEmpty) {
        currentStoreCount = userEntity.companies.first.storeCount;
        currentEmployeeCount = userEntity.companies.first.employeeCount;
      }
    }
  }

  // Update usage counts from userEntity
  // Note: userEntity.companyCount uses ownedCompanyCount from RPC (OWNED companies only)
  appStateNotifier.updateUsageCounts(
    companyCount: userEntity.companyCount,
    totalStoreCount: userEntity.totalStoreCount,
    totalEmployeeCount: userEntity.totalEmployeeCount,
    currentStoreCount: currentStoreCount,
    currentEmployeeCount: currentEmployeeCount,
  );
}

/// Fetch user companies from API and cache
Future<Map<String, dynamic>?> _fetchAndCacheUserCompanies(
  Ref ref,
  String userId,
  AppStateNotifier appStateNotifier,
  AppState appState,
) async {
  final cache = HiveCacheService.instance;

  try {
    final repository = ref.read(homepageRepositoryProvider);
    final userEntity = await repository.getUserCompanies(userId).timeout(
      const Duration(seconds: 20),
      onTimeout: () {
        throw TimeoutException('User data load timeout after 20 seconds');
      },
    );

    final userData = convertUserEntityToMap(userEntity);

    // Save to Hive cache
    await cache.saveUserCompanies(userId, userData);

    if (kDebugMode) {
      debugPrint('💾 [SWR] User companies cached');
    }

    // Initialize AppState
    await _initializeAppStateFromData(
      ref,
      userData,
      appStateNotifier,
      appState,
      isFromCache: false,
    );

    return userData;
  } on TimeoutException catch (e, stackTrace) {
    SentryConfig.captureException(
      e,
      stackTrace,
      hint: 'UserCompanies timeout - forcing logout',
    );

    await RevenueCatService().logoutUser();
    await ref.read(authServiceProvider).signOut();
    appStateNotifier.signOut();

    throw Exception('Session expired. Please sign in again.');
  } catch (e, stackTrace) {
    if (e.toString().contains('No user companies data')) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'UserCompanies orphan auth session - forcing logout',
      );

      await RevenueCatService().logoutUser();
      await ref.read(authServiceProvider).signOut();
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
}

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
