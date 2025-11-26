import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/company_type.dart';
import '../../domain/entities/currency.dart';
import '../../domain/entities/revenue.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/entities/user_with_companies.dart';
import '../../domain/providers/repository_providers.dart';
import '../../domain/providers/use_case_providers.dart';
import '../../domain/revenue_period.dart';
import '../../domain/usecases/auto_select_company_store.dart';

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
  UserWithCompanies userEntity;

  if (appState.user.isNotEmpty && appState.user['user_id'] == user.id) {
    // Return cached entity - need to convert Map back to entity
    // This is a workaround until AppState is refactored to store entities
    final repository = ref.watch(homepageRepositoryProvider);
    userEntity = await repository.getUserCompanies(user.id);
  } else {
    // Fetch fresh user companies data from repository
    final repository = ref.watch(homepageRepositoryProvider);
    userEntity = await repository.getUserCompanies(user.id);

    // Convert entity to Map for AppState (backward compatibility)
    final userData = {
      'user_id': userEntity.userId,
      'user_first_name': userEntity.userFirstName,
      'user_last_name': userEntity.userLastName,
      'profile_image': userEntity.profileImage,
      'companies': userEntity.companies.map((company) => {
        'company_id': company.id,
        'company_name': company.companyName,
        'company_code': company.companyCode,
        'stores': company.stores.map((store) => {
          'store_id': store.id,
          'store_name': store.storeName,
          'store_code': store.storeCode,
        },).toList(),
        'role': {
          'role_name': company.role.roleName,
          'permissions': company.role.permissions,
        },
      },).toList(),
    };

    // Save to AppState
    appStateNotifier.updateUser(
      user: userData,
      isAuthenticated: true,
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

    // Update app state with selected company/store
    if (selection.hasSelection) {
      appStateNotifier.updateBusinessContext(
        companyId: selection.company!.id,
        storeId: selection.store?.id ?? '',
        companyName: selection.company!.companyName,
        storeName: selection.store?.storeName,
      );
    }
  }

  // Convert entity to Map for global compatibility
  return {
    'user_id': userEntity.userId,
    'user_first_name': userEntity.userFirstName,
    'user_last_name': userEntity.userLastName,
    'profile_image': userEntity.profileImage,
    'companies': userEntity.companies.map((company) => {
      'company_id': company.id,
      'company_name': company.companyName,
      'company_code': company.companyCode,
      'stores': company.stores.map((store) => {
        'store_id': store.id,
        'store_name': store.storeName,
        'store_code': store.storeCode,
      },).toList(),
      'role': {
        'role_name': company.role.roleName,
        'permissions': company.role.permissions,
      },
    },).toList(),
  };
});

/// Entity-based provider for homepage (Clean Architecture)
///
/// This provider returns UserWithCompanies entity for use within the homepage feature.
/// It leverages the global userCompaniesProvider but converts the Map to entity.
final userCompaniesEntityProvider = FutureProvider<UserWithCompanies?>((ref) async {
  final userDataMap = await ref.watch(userCompaniesProvider.future);

  if (userDataMap == null) {
    return null;
  }

  // Convert Map to Entity
  final repository = ref.watch(homepageRepositoryProvider);
  final userId = userDataMap['user_id'] as String;

  return await repository.getUserCompanies(userId);
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
