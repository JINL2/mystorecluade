import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../core/monitoring/sentry_config.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/services/app_init_service.dart';
import '../../../../core/services/revenuecat_service.dart';
import '../../../auth/presentation/providers/auth_service.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/company_type.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/homepage_alert.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/entities/user_with_companies.dart';
import '../../domain/mappers/user_entity_mapper.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/providers/use_case_providers.dart';
import '../../domain/revenue_period.dart';
import '../../domain/usecases/auto_select_company_store.dart';

// === App Init Scenario Provider ===

/// Provider that determines the initialization scenario
/// Used to optimize data loading based on how user entered the app
final initScenarioProvider = FutureProvider<InitScenario>((ref) async {
  final authState = ref.watch(authStateProvider);

  final userId = authState.when(
    data: (user) => user?.id,
    loading: () => null,
    error: (_, __) => null,
  );

  return await AppInitService().determineScenario(userId);
});

// === Revenue Provider ===

/// Revenue view tab (Company or Store)
enum RevenueViewTab { company, store }

/// Provider for selected revenue view tab
final selectedRevenueTabProvider = StateProvider<RevenueViewTab>((ref) {
  return RevenueViewTab.store;
});

/// Provider that auto-switches to Store tab when store selection changes
/// Use ref.watch(autoSwitchToStoreTabProvider) in homepage widgets to enable this behavior
final autoSwitchToStoreTabProvider = Provider<void>((ref) {
  ref.listen(appStateProvider.select((state) => state.storeChoosen), (previous, next) {
    // Auto-switch to Store tab when store changes (not on initial load)
    if (previous != null && previous != next && next.isNotEmpty) {
      ref.read(selectedRevenueTabProvider.notifier).state = RevenueViewTab.store;
    }
  });
});

/// Provider for fetching revenue data
///
/// Depends on app state for company/store selection AND selected tab.
/// - Company tab: Returns revenue for the entire company
/// - Store tab: Returns revenue for the selected store only
final revenueProvider = FutureProvider.family<Revenue, RevenuePeriod>(
  (ref, period) async {
    // Check authentication first
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.when(
      data: (user) => user != null,
      loading: () => false,
      error: (_, __) => false,
    );

    if (!isAuthenticated) {
      throw Exception('User not authenticated');
    }

    final appState = ref.watch(appStateProvider);
    final repository = ref.watch(homepageRepositoryProvider);

    // Watch selected tab to determine which revenue to fetch
    final selectedTab = ref.watch(selectedRevenueTabProvider);

    // Get selected company/store from app state
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isEmpty) {
      throw Exception('No company selected');
    }

    // Determine storeId based on selected tab:
    // - Company tab: pass null to get company-wide revenue
    // - Store tab: pass storeId to get store-specific revenue
    final effectiveStoreId = (selectedTab == RevenueViewTab.store && storeId.isNotEmpty)
        ? storeId
        : null;

    final revenue = await repository.getRevenue(
      companyId: companyId,
      storeId: effectiveStoreId,
      period: period,
    );
    return revenue;
  },
);

// === Categories with Features Provider ===

/// Provider for fetching all categories with features
///
/// Caches data in AppState to avoid frequent API calls.
/// Returns cached data immediately if available, fetches fresh data on invalidation.
final categoriesWithFeaturesProvider =
    FutureProvider<List<CategoryWithFeatures>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // ✅ Check if we have cached data in AppState
  if (appState.categoryFeatures.isNotEmpty) {
    // Return cached data immediately (no API call)
    return _convertDynamicToCategories(appState.categoryFeatures);
  }

  // ✅ No cache, fetch fresh data from repository
  final repository = ref.watch(homepageRepositoryProvider);
  final categories = await repository.getCategoriesWithFeatures();

  // ✅ Save to AppState for future caching
  appStateNotifier.updateCategoryFeatures(_convertCategoriesToDynamic(categories));

  return categories;
});

/// Helper: Convert dynamic data back to domain entities
List<CategoryWithFeatures> _convertDynamicToCategories(List<dynamic> dynamicCategories) {
  return dynamicCategories.map((categoryData) {
    final category = categoryData as Map<String, dynamic>;
    final featuresData = category['features'] as List<dynamic>;

    return CategoryWithFeatures(
      categoryId: category['category_id'] as String,
      categoryName: category['category_name'] as String,
      features: featuresData.map((featureData) {
        final feature = featureData as Map<String, dynamic>;
        return Feature(
          featureId: feature['feature_id'] as String,
          featureName: feature['feature_name'] as String,
          featureDescription: feature['feature_description'] as String?,
          featureRoute: feature['feature_route'] as String,
          featureIcon: feature['feature_icon'] as String,
          iconKey: feature['icon_key'] as String?,
          isShowMain: feature['is_show_main'] as bool? ?? true,
        );
      }).toList(),
    );
  }).toList();
}

/// Helper: Convert categories to dynamic for AppState storage
List<dynamic> _convertCategoriesToDynamic(List<CategoryWithFeatures> categories) {
  return categories.map((category) => {
    'category_id': category.categoryId,
    'category_name': category.categoryName,
    'features': category.features.map((feature) => {
      'feature_id': feature.featureId,
      'feature_name': feature.featureName,
      'feature_description': feature.featureDescription,
      'feature_route': feature.featureRoute,
      'feature_icon': feature.featureIcon,
      'icon_key': feature.iconKey,
      'is_show_main': feature.isShowMain,
    },).toList(),
  },).toList();
}

// === Quick Access Features Provider ===

/// Provider for fetching user's frequently used features
///
/// Depends on app state for user and company selection.
final quickAccessFeaturesProvider = FutureProvider<List<TopFeature>>((ref) async {
  // Wait for authentication state first
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );

  if (!isAuthenticated) {
    return [];
  }

  // Wait for user companies to load first to ensure userId and companyId are populated
  final userCompanies = await ref.watch(userCompaniesProvider.future);

  if (userCompanies == null) {
    return [];
  }

  final appState = ref.watch(appStateProvider);
  final repository = ref.watch(homepageRepositoryProvider);

  // Get user ID and selected company from app state
  final userId = appState.userId;
  final companyId = appState.companyChoosen;

  if (userId.isEmpty || companyId.isEmpty) {
    return [];
  }

  final features = await repository.getQuickAccessFeatures(
    userId: userId,
    companyId: companyId,
  );
  return features;
});

// === User Companies Provider ===

/// Provider for fetching user companies and stores
///
/// Caches data in AppState and auto-selects company/store
/// Returns UserWithCompanies domain entity
/// Global user companies provider (returns Map for backward compatibility)
///
/// This provider is used globally across the app and returns Map<String, dynamic>
/// for backward compatibility with existing code.
///
/// ⚠️ TIMEOUT: If user data doesn't load within 20 seconds, auto-logout occurs.
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

    // ✅ Always update AppState.user with fresh data (includes companies with subscription)
    // This ensures CompanyStoreSelector and other widgets get updated subscription data
    appStateNotifier.updateUser(
      user: userData,
      isAuthenticated: true,
    );

    // ✅ Login to RevenueCat with Supabase user ID
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
          lastCompanyId: lastSelection['companyId'] as String?,
          lastStoreId: lastSelection['storeId'] as String?,
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
      // ✅ Company already selected - still update subscription data on refresh
      // Find the currently selected company and update its subscription
      final selectedCompany = userEntity.companies.firstWhere(
        (c) => c.id == appState.companyChoosen,
        orElse: () => userEntity.companies.first,
      );

      // ✅ Find the actual store name from the selected store ID
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
    // ⚠️ Timeout - auto logout and throw error
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
    // ⚠️ Other errors (e.g., user profile not found in public.users)
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

// === UI State Providers ===

/// Selected revenue period for revenue card
final selectedRevenuePeriodProvider = StateProvider<RevenuePeriod>(
  (ref) => RevenuePeriod.today,
);

// === Company & Currency Providers ===

/// Company Types FutureProvider for dropdown
///
/// Used in create company sheet to populate company type options.
/// Auto-disposed when sheet is closed to free memory.
final companyTypesProvider = FutureProvider.autoDispose<List<CompanyType>>((ref) async {
  final getCompanyTypes = ref.watch(getCompanyTypesUseCaseProvider);
  final result = await getCompanyTypes();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (companyTypes) => companyTypes,
  );
});

/// Currencies FutureProvider for dropdown
///
/// Used in create company sheet to populate currency options.
/// Auto-disposed when sheet is closed to free memory.
final currenciesProvider = FutureProvider.autoDispose<List<Currency>>((ref) async {
  final getCurrencies = ref.watch(getCurrenciesUseCaseProvider);
  final result = await getCurrencies();

  return result.fold(
    (failure) => throw Exception(failure.message),
    (currencies) => currencies,
  );
});

// === App Version Check Provider ===

/// Provider for checking app version against server
///
/// Returns true if app is up to date, false if update required.
/// This should be called BEFORE loading other homepage data.
final appVersionCheckProvider = FutureProvider<bool>((ref) async {
  final repository = ref.watch(homepageRepositoryProvider);
  return await repository.checkAppVersion();
});

// === Homepage Alert Provider ===

/// Provider for fetching homepage alert
///
/// Returns alert data with is_show and is_checked flags.
/// Uses 6-hour cache in DataSource to prevent excessive API calls.
final homepageAlertProvider = FutureProvider<HomepageAlert>((ref) async {
  // Wait for authentication
  final authState = ref.watch(authStateProvider);
  final user = authState.when(
    data: (user) => user,
    loading: () => null,
    error: (_, __) => null,
  );

  if (user == null) {
    return const HomepageAlert(isShow: false, isChecked: false, content: null);
  }

  final repository = ref.watch(homepageRepositoryProvider);
  final alert = await repository.getHomepageAlert(userId: user.id);
  return alert;
});
