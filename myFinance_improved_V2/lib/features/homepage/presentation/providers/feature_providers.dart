/// Feature Presentation Layer Providers
///
/// This file contains feature-related providers for homepage.
/// - Categories with features (menu grid)
/// - Quick access features (frequently used)
///
/// Extracted from homepage_providers.dart for better organization.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/providers/repository_providers.dart';
import 'user_companies_providers.dart';

// ============================================================================
// Categories with Features Provider
// ============================================================================

/// Provider for fetching all categories with features
///
/// Caches data in AppState to avoid frequent API calls.
/// Returns cached data immediately if available, fetches fresh data on invalidation.
final categoriesWithFeaturesProvider =
    FutureProvider<List<CategoryWithFeatures>>((ref) async {
  final appState = ref.watch(appStateProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // Check if we have cached data in AppState
  if (appState.categoryFeatures.isNotEmpty) {
    // Return cached data immediately (no API call)
    return _convertDynamicToCategories(appState.categoryFeatures);
  }

  // No cache, fetch fresh data from repository
  final repository = ref.watch(homepageRepositoryProvider);
  final categories = await repository.getCategoriesWithFeatures();

  // Save to AppState for future caching
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

// ============================================================================
// Quick Access Features Provider
// ============================================================================

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
