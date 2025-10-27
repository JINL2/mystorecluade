import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/data/repositories/repository_providers.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/category_with_features.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/revenue.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/top_feature.dart';
import 'package:myfinance_improved/features/homepage/domain/revenue_period.dart';
import 'package:myfinance_improved/app/providers/auth_providers.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// === Revenue Provider ===

/// Revenue view tab (Company or Store)
enum RevenueViewTab { company, store }

/// Provider for selected revenue view tab
final selectedRevenueTabProvider = StateProvider<RevenueViewTab>((ref) {
  return RevenueViewTab.company;
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
final categoriesWithFeaturesProvider =
    FutureProvider<List<CategoryWithFeatures>>((ref) async {
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
        appStateNotifier.updateCategoryFeatures(_convertCategoriesToDynamic(freshCategories));
      }

      return freshCategories;
    } catch (e) {
      // On error, return empty list if cache is empty
      return [];
    }
  }

  // No cache, fetch fresh data
  final repository = ref.watch(homepageRepositoryProvider);
  final categories = await repository.getCategoriesWithFeatures();

  // Save to AppState for caching
  appStateNotifier.updateCategoryFeatures(_convertCategoriesToDynamic(categories));

  return categories;
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

  // Fetch user companies data (either from cache or repository)
  Map<String, dynamic> userData;
  List<dynamic> companiesData;

  if (appState.user.isNotEmpty && appState.user['user_id'] == user.id) {
    userData = appState.user;
    companiesData = (userData['companies'] as List<dynamic>?) ?? [];
  } else {
    // Fetch fresh user companies data from repository
    final repository = ref.watch(homepageRepositoryProvider);
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
        'company_code': company.companyCode,
        'stores': company.stores.map((store) => {
          'store_id': store.id,
          'store_name': store.storeName,
          'store_code': store.storeCode,
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
  }

  // Auto-select company and store
  if (companiesData.isNotEmpty && appState.companyChoosen.isEmpty) {
    // Try to load last selected company/store from cache
    final lastSelection = await appStateNotifier.loadLastSelection();
    final lastCompanyId = lastSelection['companyId'];
    final lastStoreId = lastSelection['storeId'];

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
      } catch (e) {
        // Cached company not found, will use first company
      }
    }

    // If no cached company found, use first company
    if (selectedCompanyId == null) {
      final firstCompany = companiesData.first as Map<String, dynamic>;
      selectedCompanyId = firstCompany['company_id'] as String;
      selectedCompanyName = firstCompany['company_name'] as String;
      selectedCompanyStores = (firstCompany['stores'] as List<dynamic>?) ?? [];
    }

    // Select company
    appStateNotifier.selectCompany(selectedCompanyId, companyName: selectedCompanyName);

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
        } catch (e) {
          // Cached store not found, will use first store
        }
      }

      // If no cached store found, use first store
      if (selectedStoreId == null) {
        final firstStore = selectedCompanyStores.first as Map<String, dynamic>;
        selectedStoreId = firstStore['store_id'] as String;
        selectedStoreName = firstStore['store_name'] as String;
      }

      appStateNotifier.selectStore(selectedStoreId, storeName: selectedStoreName);
    }
  }

  return userData;
});

// === UI State Providers ===

/// Selected revenue period for revenue card
final selectedRevenuePeriodProvider = StateProvider<RevenuePeriod>(
  (ref) => RevenuePeriod.today,
);
