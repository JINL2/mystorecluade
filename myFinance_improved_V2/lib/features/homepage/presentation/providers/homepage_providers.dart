import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../data/models/user_companies_model.dart';
import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/company_type.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/providers/use_case_providers.dart';
import '../../domain/revenue_period.dart';

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
///
/// ✅ Optimized: Uses read for one-time checks, watch only for reactive state
final revenueProvider = FutureProvider.family<Revenue, RevenuePeriod>(
  (ref, period) async {
    // ✅ Use read for authentication check (one-time, not reactive)
    final authState = ref.read(authStateProvider);
    final isAuthenticated = authState.maybeWhen(
      data: (user) => user != null,
      orElse: () => false,
    );

    if (!isAuthenticated) {
      throw Exception('User not authenticated');
    }

    // ✅ Watch only what needs to trigger rebuilds
    final appState = ref.watch(appStateProvider);
    final selectedTab = ref.watch(selectedRevenueTabProvider);

    // ✅ Use read for repository (static dependency)
    final repository = ref.read(homepageRepositoryProvider);

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
///
/// ✅ Optimized: Uses read for static dependencies
final categoriesWithFeaturesProvider =
    FutureProvider<List<CategoryWithFeatures>>((ref) async {
  // ✅ Watch appState to react to cache changes
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // ✅ Check if we have cached data in AppState
  if (appState.categoryFeatures.isNotEmpty) {
    // Return cached data immediately (no API call)
    return _convertDynamicToCategories(appState.categoryFeatures);
  }

  // ✅ No cache, fetch fresh data from repository (use read, not watch)
  final repository = ref.read(homepageRepositoryProvider);
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
///
/// ✅ Optimized: Reduced dependency chain and removed redundant await
final quickAccessFeaturesProvider = FutureProvider<List<TopFeature>>((ref) async {
  // ✅ Use read for authentication check (one-time)
  final authState = ref.read(authStateProvider);
  final isAuthenticated = authState.maybeWhen(
    data: (user) => user != null,
    orElse: () => false,
  );

  if (!isAuthenticated) {
    return [];
  }

  // ✅ Watch appState (reactive to company/store changes)
  final appState = ref.watch(appStateProvider);
  final userId = appState.userId;
  final companyId = appState.companyChoosen;

  // If AppState is not initialized yet, wait for userCompanies to load
  if (userId.isEmpty || companyId.isEmpty) {
    final userCompanies = await ref.watch(userCompaniesProvider.future);
    if (userCompanies == null) {
      return [];
    }

    // Re-check appState after userCompanies loaded
    final updatedAppState = ref.read(appStateProvider);
    if (updatedAppState.userId.isEmpty || updatedAppState.companyChoosen.isEmpty) {
      return [];
    }
  }

  // ✅ Use read for repository (static dependency)
  final repository = ref.read(homepageRepositoryProvider);

  final features = await repository.getQuickAccessFeatures(
    userId: appState.userId,
    companyId: appState.companyChoosen,
  );
  return features;
});

// === User Companies Provider ===

/// Provider for fetching user companies and stores
///
/// Returns type-safe UserCompaniesModel instead of dynamic Map
/// Caches data in AppState and auto-selects company/store
final userCompaniesProvider = FutureProvider<UserCompaniesModel?>((ref) async {
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
  UserCompaniesModel userCompaniesModel;

  if (appState.user.isNotEmpty && appState.user['user_id'] == user.id) {
    // ✅ Reconstruct UserCompaniesModel from cached AppState
    userCompaniesModel = UserCompaniesModel(
      userId: appState.user['user_id'] as String,
      userFirstName: appState.user['user_first_name'] as String?,
      userLastName: appState.user['user_last_name'] as String?,
      profileImage: appState.user['profile_image'] as String?,
      companies: (appState.user['companies'] as List<dynamic>? ?? [])
          .map((companyData) {
            final company = companyData as Map<String, dynamic>;
            return CompanyModel(
              companyId: company['company_id'] as String,
              companyName: company['company_name'] as String,
              companyCode: company['company_code'] as String?,
              role: company['role'] != null
                  ? RoleModel(
                      roleName: (company['role'] as Map<String, dynamic>)['role_name'] as String,
                      permissions: ((company['role'] as Map<String, dynamic>)['permissions'] as List<dynamic>)
                          .map((p) => p as String)
                          .toList(),
                    )
                  : null,
              stores: (company['stores'] as List<dynamic>? ?? [])
                  .map((storeData) {
                    final store = storeData as Map<String, dynamic>;
                    return StoreModel(
                      storeId: store['store_id'] as String,
                      storeName: store['store_name'] as String,
                      storeCode: store['store_code'] as String?,
                    );
                  }).toList(),
            );
          }).toList(),
    );
  } else {
    // ✅ Fetch fresh user companies data from repository (already returns UserWithCompanies entity)
    final repository = ref.watch(homepageRepositoryProvider);
    final userCompaniesEntity = await repository.getUserCompanies(user.id);

    // ✅ Convert domain entity to model
    userCompaniesModel = UserCompaniesModel.fromDomain(userCompaniesEntity);

    // ✅ Convert to Map for AppState (keep for backward compatibility)
    final userData = {
      'user_id': userCompaniesModel.userId,
      'user_first_name': userCompaniesModel.userFirstName,
      'user_last_name': userCompaniesModel.userLastName,
      'profile_image': userCompaniesModel.profileImage,
      'companies': userCompaniesModel.companies.map((company) => {
        'company_id': company.companyId,
        'company_name': company.companyName,
        'company_code': company.companyCode,
        'stores': company.stores.map((store) => {
          'store_id': store.storeId,
          'store_name': store.storeName,
          'store_code': store.storeCode,
        }).toList(),
        'role': company.role != null
            ? {
                'role_name': company.role!.roleName,
                'permissions': company.role!.permissions,
              }
            : null,
      }).toList(),
    };

    // Save to AppState
    appStateNotifier.updateUser(
      user: userData,
      isAuthenticated: true,
    );
  }

  // Auto-select company and store
  if (userCompaniesModel.companies.isNotEmpty && appState.companyChoosen.isEmpty) {
    // Try to load last selected company/store from cache
    final lastSelection = await appStateNotifier.loadLastSelection();
    final lastCompanyId = lastSelection['companyId'];
    final lastStoreId = lastSelection['storeId'];

    CompanyModel? selectedCompany;

    // Check if last selected company still exists
    if (lastCompanyId != null && lastCompanyId.isNotEmpty) {
      try {
        selectedCompany = userCompaniesModel.companies.firstWhere(
          (company) => company.companyId == lastCompanyId,
        );
      } catch (e) {
        // Cached company not found, will use first company
      }
    }

    // If no cached company found, use first company
    selectedCompany ??= userCompaniesModel.companies.first;

    // Auto-select store
    StoreModel? selectedStore;

    if (selectedCompany.stores.isNotEmpty) {
      // Check if last selected store still exists in this company
      if (lastStoreId != null && lastStoreId.isNotEmpty) {
        try {
          selectedStore = selectedCompany.stores.firstWhere(
            (store) => store.storeId == lastStoreId,
          );
        } catch (e) {
          // Cached store not found, will use first store
        }
      }

      // If no cached store found, use first store
      selectedStore ??= selectedCompany.stores.first;
    }

    // Update both company and store in single call to avoid duplicate save
    appStateNotifier.updateBusinessContext(
      companyId: selectedCompany.companyId,
      storeId: selectedStore?.storeId ?? '',
      companyName: selectedCompany.companyName,
      storeName: selectedStore?.storeName,
    );
  }

  return userCompaniesModel;
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
