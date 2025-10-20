import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/data/repositories/repository_providers.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/category_with_features.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/revenue.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/top_feature.dart';
import 'package:myfinance_improved/features/homepage/domain/revenue_period.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// === Revenue Provider ===

/// Provider for fetching revenue data
///
/// Depends on app state for company/store selection.
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
      debugPrint('🔵 [revenueProvider] User not authenticated, throwing exception');
      throw Exception('User not authenticated');
    }

    final appState = ref.watch(appStateProvider);
    final repository = ref.watch(homepageRepositoryProvider);

    // Get selected company/store from app state
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;


    if (companyId.isEmpty) {
      debugPrint('🔵 [revenueProvider] ERROR: No company selected');
      throw Exception('No company selected');
    }

    try {
      final revenue = await repository.getRevenue(
        companyId: companyId,
        storeId: storeId.isNotEmpty ? storeId : null,
        period: period,
      );
      return revenue;
    } catch (e, stack) {
      debugPrint('🔵 [revenueProvider] ERROR: $e');
      debugPrint('🔵 [revenueProvider] Stack: $stack');
      rethrow;
    }
  },
);

// === Categories with Features Provider ===

/// Provider for fetching all categories with features
///
/// Caches data in AppState to avoid frequent API calls.
final categoriesWithFeaturesProvider =
    FutureProvider<List<CategoryWithFeatures>>((ref) async {
  debugPrint('🔵 [categoriesWithFeaturesProvider] Provider called');

  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // Check if we have cached data in AppState
  if (appState.categoryFeatures.isNotEmpty) {

    // Convert cached data back to domain entities
    // AppState stores dynamic data, so we need to reconstruct entities
    try {
      final repository = ref.watch(homepageRepositoryProvider);
      final freshCategories = await repository.getCategoriesWithFeatures();

      // Only update if data has changed
      if (freshCategories.length != appState.categoryFeatures.length) {
        debugPrint('🔵 [categoriesWithFeaturesProvider] Cache outdated, updating AppState');
        appStateNotifier.updateCategoryFeatures(_convertCategoriesToDynamic(freshCategories));
      }

      return freshCategories;
    } catch (e) {
      debugPrint('🔵 [categoriesWithFeaturesProvider] Error refreshing, using cache');
      // On error, return empty list if cache is empty
      return [];
    }
  }

  // No cache, fetch fresh data
  try {
    final repository = ref.watch(homepageRepositoryProvider);

    final categories = await repository.getCategoriesWithFeatures();

    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      debugPrint('🔵 [categoriesWithFeaturesProvider]   Category $i: ${category.categoryName} (${category.features.length} features)');
    }

    // Save to AppState for caching
    appStateNotifier.updateCategoryFeatures(_convertCategoriesToDynamic(categories));

    return categories;
  } catch (e, stack) {
    debugPrint('🔵 [categoriesWithFeaturesProvider] ERROR: $e');
    debugPrint('🔵 [categoriesWithFeaturesProvider] Stack: $stack');
    rethrow;
  }
});

/// Helper: Convert categories to dynamic for AppState storage
List<dynamic> _convertCategoriesToDynamic(List<CategoryWithFeatures> categories) {
  return categories.map((category) => {
    'category_id': category.categoryId,
    'category_name': category.categoryName,
    'features': category.features.map((feature) => {
      'feature_id': feature.featureId,
      'feature_name': feature.featureName,
      'feature_route': feature.featureRoute,
      'feature_icon': feature.featureIcon,
      'icon_key': feature.iconKey,
      'is_show_main': feature.isShowMain,
    }).toList(),
  }).toList();
}

// === Quick Access Features Provider ===

/// Provider for fetching user's frequently used features
///
/// Depends on app state for user and company selection.
final quickAccessFeaturesProvider = FutureProvider<List<TopFeature>>((ref) async {
  debugPrint('🔵 [quickAccessFeaturesProvider] Provider called');

  // Wait for authentication state first
  final authState = ref.watch(authStateProvider);
  final isAuthenticated = authState.when(
    data: (user) => user != null,
    loading: () => false,
    error: (_, __) => false,
  );

  if (!isAuthenticated) {
    debugPrint('🔵 [quickAccessFeaturesProvider] User not authenticated, returning empty list');
    return [];
  }

  // Wait for user companies to load first to ensure userId and companyId are populated
  final userCompanies = await ref.watch(userCompaniesProvider.future);

  if (userCompanies == null) {
    debugPrint('🔵 [quickAccessFeaturesProvider] No user companies data, returning empty list');
    return [];
  }

  final appState = ref.watch(appStateProvider);
  final repository = ref.watch(homepageRepositoryProvider);

  // Get user ID and selected company from app state
  final userId = appState.userId;
  final companyId = appState.companyChoosen;


  if (userId.isEmpty) {
    debugPrint('🔵 [quickAccessFeaturesProvider] ERROR: User not logged in, returning empty list');
    return [];
  }

  if (companyId.isEmpty) {
    debugPrint('🔵 [quickAccessFeaturesProvider] No company selected, returning empty list');
    return [];
  }

  try {
    final features = await repository.getQuickAccessFeatures(
      userId: userId,
      companyId: companyId,
    );
    return features;
  } catch (e, stack) {
    debugPrint('🔵 [quickAccessFeaturesProvider] ERROR: $e');
    debugPrint('🔵 [quickAccessFeaturesProvider] Stack: $stack');
    rethrow;
  }
});

// === User Companies Provider ===

/// Provider for fetching user companies and stores
///
/// Caches data in AppState and auto-selects company/store
final userCompaniesProvider = FutureProvider<Map<String, dynamic>?>((ref) async {
  debugPrint('🔵 [userCompaniesProvider] Provider called');

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
    debugPrint('🔵 [userCompaniesProvider] No user authenticated');
    return null;
  }

  debugPrint('🔵 [userCompaniesProvider] User authenticated: ${user.id}');

  // Fetch user companies data (either from cache or repository)
  Map<String, dynamic> userData;
  List<dynamic> companiesData;

  if (appState.user.isNotEmpty && appState.user['user_id'] == user.id) {
    debugPrint('🔵 [userCompaniesProvider] Using cached user data from AppState');
    userData = appState.user;
    companiesData = (userData['companies'] as List<dynamic>?) ?? [];
  } else {
    // Fetch fresh user companies data from repository
    try {
      final repository = ref.watch(homepageRepositoryProvider);
      debugPrint('🔵 [userCompaniesProvider] Fetching user companies from repository...');

      final userCompanies = await repository.getUserCompanies(user.id);

      // Convert to Map for AppState
      userData = {
        'user_id': userCompanies.userId,
        'user_first_name': userCompanies.userFirstName,
        'user_last_name': userCompanies.userLastName,
        'profile_image': userCompanies.profileImage,
        'companies': userCompanies.companies.map((company) => {
          'company_id': company.id,
          'company_name': company.companyName,
          'company_code': company.companyCode,  // ✅ Add company code
          'stores': company.stores.map((store) => {
            'store_id': store.id,
            'store_name': store.storeName,
            'store_code': store.storeCode,  // ✅ Add store code
          }).toList(),
          'role': {
            'role_name': company.role.roleName,
            'permissions': company.role.permissions,
          },
        }).toList(),
      };

      companiesData = userData['companies'] as List<dynamic>;

      // Save to AppState
      appStateNotifier.updateUser(
        user: userData,
        isAuthenticated: true,
      );
      debugPrint('🔵 [userCompaniesProvider] Saved user data to AppState');
    } catch (e, stack) {
      debugPrint('🔵 [userCompaniesProvider] ERROR: $e');
      debugPrint('🔵 [userCompaniesProvider] Stack: $stack');
      rethrow;
    }
  }

  // Auto-select company and store

  if (companiesData.isNotEmpty && appState.companyChoosen.isEmpty) {
    // Try to load last selected company/store from cache
    final lastSelection = await appStateNotifier.loadLastSelection();
    final lastCompanyId = lastSelection['companyId'];
    final lastStoreId = lastSelection['storeId'];
    final lastCompanyName = lastSelection['companyName'];
    final lastStoreName = lastSelection['storeName'];

    debugPrint('💾 [userCompaniesProvider] Last cached selection: Company=$lastCompanyName, Store=$lastStoreName');

    String? selectedCompanyId;
    String? selectedCompanyName;
    List<dynamic>? selectedCompanyStores;

    // Check if last selected company still exists
    if (lastCompanyId != null && lastCompanyId.isNotEmpty) {
      try {
        final cachedCompany = companiesData.firstWhere(
          (company) => (company as Map<String, dynamic>)['company_id'] == lastCompanyId,
        );

        final companyMap = cachedCompany as Map<String, dynamic>;
        selectedCompanyId = companyMap['company_id'] as String;
        selectedCompanyName = companyMap['company_name'] as String;
        selectedCompanyStores = (companyMap['stores'] as List<dynamic>?) ?? [];
        debugPrint('✅ [userCompaniesProvider] Restored cached company: $selectedCompanyName');
      } catch (e) {
        debugPrint('⚠️ [userCompaniesProvider] Cached company not found, will use first company');
      }
    }

    // If no cached company found, use first company
    if (selectedCompanyId == null) {
      final firstCompany = companiesData.first as Map<String, dynamic>;
      selectedCompanyId = firstCompany['company_id'] as String;
      selectedCompanyName = firstCompany['company_name'] as String;
      selectedCompanyStores = (firstCompany['stores'] as List<dynamic>?) ?? [];
      debugPrint('🔵 [userCompaniesProvider] Using first company: $selectedCompanyName');
    }

    // Select company
    appStateNotifier.selectCompany(selectedCompanyId, companyName: selectedCompanyName);

    // Verify it was set
    final updatedAppState = ref.read(appStateProvider);

    // Auto-select store
    if (selectedCompanyStores!.isNotEmpty) {
      String? selectedStoreId;
      String? selectedStoreName;

      // Check if last selected store still exists in this company
      if (lastStoreId != null && lastStoreId.isNotEmpty) {
        try {
          final cachedStore = selectedCompanyStores.firstWhere(
            (store) => (store as Map<String, dynamic>)['store_id'] == lastStoreId,
          );

          final storeMap = cachedStore as Map<String, dynamic>;
          selectedStoreId = storeMap['store_id'] as String;
          selectedStoreName = storeMap['store_name'] as String;
          debugPrint('✅ [userCompaniesProvider] Restored cached store: $selectedStoreName');
        } catch (e) {
          debugPrint('⚠️ [userCompaniesProvider] Cached store not found, will use first store');
        }
      }

      // If no cached store found, use first store
      if (selectedStoreId == null) {
        final firstStore = selectedCompanyStores.first as Map<String, dynamic>;
        selectedStoreId = firstStore['store_id'] as String;
        selectedStoreName = firstStore['store_name'] as String;
        debugPrint('🔵 [userCompaniesProvider] Using first store: $selectedStoreName');
      }

      appStateNotifier.selectStore(selectedStoreId, storeName: selectedStoreName);

      // Verify it was set
      final finalAppState = ref.read(appStateProvider);
    } else {
      debugPrint('⚠️ [userCompaniesProvider] No stores found for company: $selectedCompanyName');
    }
  } else if (companiesData.isEmpty) {
    debugPrint('⚠️ [userCompaniesProvider] No companies available for user');
  } else {
    debugPrint('ℹ️ [userCompaniesProvider] Company already selected: ${appState.companyChoosen}');
  }

  return userData;
});

// === UI State Providers ===

/// Selected revenue period for revenue card
final selectedRevenuePeriodProvider = StateProvider<RevenuePeriod>(
  (ref) => RevenuePeriod.today,
);
