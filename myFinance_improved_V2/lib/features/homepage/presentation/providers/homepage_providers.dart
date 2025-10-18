import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:myfinance_improved/features/homepage/data/repositories/repository_providers.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/category_with_features.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/revenue.dart';
import 'package:myfinance_improved/features/homepage/domain/entities/top_feature.dart';
import 'package:myfinance_improved/features/homepage/domain/revenue_period.dart';
import 'package:myfinance_improved/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:myfinance_improved/app/providers/app_state_provider.dart';

// === Revenue Provider ===

/// Provider for fetching revenue data
///
/// Depends on app state for company/store selection.
final revenueProvider = FutureProvider.family<Revenue, RevenuePeriod>(
  (ref, period) async {
    debugPrint('🔵 [revenueProvider] Provider called with period: ${period.name}');

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

    debugPrint('🔵 [revenueProvider] companyId: $companyId, storeId: $storeId');

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
      debugPrint('🔵 [revenueProvider] Successfully fetched revenue: ${revenue.amount}');
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
    debugPrint('🔵 [categoriesWithFeaturesProvider] Using cached data from AppState (${appState.categoryFeatures.length} categories)');

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
    debugPrint('🔵 [categoriesWithFeaturesProvider] Fetching from repository...');

    final categories = await repository.getCategoriesWithFeatures();
    debugPrint('🔵 [categoriesWithFeaturesProvider] Successfully fetched ${categories.length} categories');

    for (var i = 0; i < categories.length; i++) {
      final category = categories[i];
      debugPrint('🔵 [categoriesWithFeaturesProvider]   Category $i: ${category.categoryName} (${category.features.length} features)');
    }

    // Save to AppState for caching
    appStateNotifier.updateCategoryFeatures(_convertCategoriesToDynamic(categories));
    debugPrint('🔵 [categoriesWithFeaturesProvider] Saved to AppState cache');

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

  debugPrint('🔵 [quickAccessFeaturesProvider] userId: $userId, companyId: $companyId');

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
    debugPrint('🔵 [quickAccessFeaturesProvider] Successfully fetched ${features.length} features');
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
      debugPrint('🔵 [userCompaniesProvider] Successfully fetched user companies');

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

  // Auto-select first company and store if not selected
  debugPrint('🔵 [userCompaniesProvider] Total companies: ${companiesData.length}');
  debugPrint('🔵 [userCompaniesProvider] Current companyChoosen: "${appState.companyChoosen}"');

  if (companiesData.isNotEmpty && appState.companyChoosen.isEmpty) {
    final firstCompany = companiesData.first as Map<String, dynamic>;
    final companyId = firstCompany['company_id'] as String;
    final companyName = firstCompany['company_name'] as String;
    final stores = (firstCompany['stores'] as List<dynamic>?) ?? [];

    debugPrint('🔵 [userCompaniesProvider] Auto-selecting company: $companyName (ID: $companyId)');
    appStateNotifier.selectCompany(companyId, companyName: companyName);

    // Verify it was set
    final updatedAppState = ref.read(appStateProvider);
    debugPrint('🔵 [userCompaniesProvider] After selectCompany - companyChoosen: "${updatedAppState.companyChoosen}", companyName: "${updatedAppState.companyName}"');

    // Auto-select first store
    if (stores.isNotEmpty) {
      final firstStore = stores.first as Map<String, dynamic>;
      final storeId = firstStore['store_id'] as String;
      final storeName = firstStore['store_name'] as String;

      debugPrint('🔵 [userCompaniesProvider] Auto-selecting store: $storeName (ID: $storeId)');
      appStateNotifier.selectStore(storeId, storeName: storeName);

      // Verify it was set
      final finalAppState = ref.read(appStateProvider);
      debugPrint('🔵 [userCompaniesProvider] After selectStore - storeChoosen: "${finalAppState.storeChoosen}", storeName: "${finalAppState.storeName}"');
    } else {
      debugPrint('⚠️ [userCompaniesProvider] No stores found for company: $companyName');
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
