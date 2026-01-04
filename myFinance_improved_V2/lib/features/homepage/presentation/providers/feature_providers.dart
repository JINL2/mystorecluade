/// Feature Presentation Layer Providers
///
/// This file contains feature-related providers for homepage.
/// - Categories with features (menu grid)
/// - Quick access features (frequently used)
///
/// Uses SWR (Stale-While-Revalidate) pattern with Hive persistence:
/// 1. Return cached data immediately (from Hive)
/// 2. Fetch fresh data in background
/// 3. Update cache when fresh data arrives
///
/// Extracted from homepage_providers.dart for better organization.
library;

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../../app/providers/auth_providers.dart';
import '../../../../core/cache/hive_cache_service.dart';
import '../../../../core/domain/entities/feature.dart';
import '../../domain/entities/category_with_features.dart';
import '../../domain/entities/top_feature.dart';
import '../../domain/providers/repository_providers.dart';
import 'user_companies_providers.dart';

// ============================================================================
// Categories with Features Provider (SWR Pattern)
// ============================================================================

/// Provider for fetching all categories with features
///
/// Uses SWR (Stale-While-Revalidate) pattern:
/// 1. If Hive cache exists → return immediately + refresh in background
/// 2. If no cache → fetch from API and cache
///
/// Categories are static data with long TTL (365 days).
final categoriesWithFeaturesProvider =
    FutureProvider<List<CategoryWithFeatures>>((ref) async {
  final cache = HiveCacheService.instance;
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // =========================================================================
  // SWR Step 1: Try to load from Hive cache first
  // =========================================================================
  final cachedData = await cache.getCategories();

  if (cachedData != null) {
    if (kDebugMode) {
      debugPrint('📦 [SWR] Using cached categories data');
    }

    final categories = _convertDynamicToCategories(cachedData);

    // Update AppState for in-memory access
    appStateNotifier.updateCategoryFeatures(cachedData);

    // Trigger background refresh (non-blocking)
    _refreshCategoriesInBackground(ref);

    return categories;
  }

  // =========================================================================
  // SWR Step 2: No cache - fetch from API
  // =========================================================================
  if (kDebugMode) {
    debugPrint('🌐 [SWR] No categories cache, fetching from API...');
  }

  return await _fetchAndCacheCategories(ref, appStateNotifier);
});

/// Background refresh for categories (SWR pattern)
///
/// Note: We capture repository and notifier before async gap to avoid ref state issues
void _refreshCategoriesInBackground(Ref ref) {
  // Capture dependencies BEFORE async gap to avoid ref state issues
  final repository = ref.read(homepageRepositoryProvider);
  final appStateNotifier = ref.read(appStateProvider.notifier);

  // Fire and forget - don't await
  Future(() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 [SWR] Categories background refresh started...');
      }

      final categories = await repository.getCategoriesWithFeatures();
      final dynamicCategories = _convertCategoriesToDynamic(categories);

      // Save to Hive cache
      await HiveCacheService.instance.saveCategories(dynamicCategories);

      // Update AppState
      appStateNotifier.updateCategoryFeatures(dynamicCategories);

      if (kDebugMode) {
        debugPrint('✅ [SWR] Categories background refresh completed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SWR] Categories background refresh failed: $e');
      }
      // Don't throw - background refresh failure is non-critical
    }
  });
}

/// Fetch categories from API and cache
Future<List<CategoryWithFeatures>> _fetchAndCacheCategories(
  Ref ref,
  dynamic appStateNotifier,
) async {
  final repository = ref.read(homepageRepositoryProvider);
  final categories = await repository.getCategoriesWithFeatures();
  final dynamicCategories = _convertCategoriesToDynamic(categories);

  // Save to Hive cache
  await HiveCacheService.instance.saveCategories(dynamicCategories);

  // Update AppState for in-memory access
  appStateNotifier.updateCategoryFeatures(dynamicCategories);

  if (kDebugMode) {
    debugPrint('💾 [SWR] Categories cached');
  }

  return categories;
}

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
// Quick Access Features Provider (SWR Pattern)
// ============================================================================

/// Provider for fetching user's frequently used features
///
/// Uses SWR (Stale-While-Revalidate) pattern:
/// 1. If Hive cache exists → return immediately + refresh in background
/// 2. If no cache → fetch from API and cache
///
/// Quick access features have 24h TTL.
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

  // Use ref.read() instead of ref.watch() to prevent multiple rebuilds
  // appStateProvider changes frequently during initialization, but we only need
  // the current snapshot of userId and companyId (which are already stable after userCompanies loads)
  final appState = ref.read(appStateProvider);
  final cache = HiveCacheService.instance;

  // Get user ID and selected company from app state
  final userId = appState.userId;
  final companyId = appState.companyChoosen;

  if (userId.isEmpty || companyId.isEmpty) {
    return [];
  }

  // =========================================================================
  // SWR Step 1: Try to load from Hive cache first
  // =========================================================================
  final cachedData = await cache.getQuickAccess(userId, companyId);

  if (cachedData != null) {
    if (kDebugMode) {
      debugPrint('📦 [SWR] Using cached quick access features');
    }

    final features = _convertDynamicToTopFeatures(cachedData);

    // Trigger background refresh (non-blocking)
    _refreshQuickAccessInBackground(ref, userId, companyId);

    return features;
  }

  // =========================================================================
  // SWR Step 2: No cache - fetch from API
  // =========================================================================
  if (kDebugMode) {
    debugPrint('🌐 [SWR] No quick access cache, fetching from API...');
  }

  return await _fetchAndCacheQuickAccess(ref, userId, companyId);
});

/// Background refresh for quick access features (SWR pattern)
///
/// Note: We capture repository before async gap to avoid ref state issues
void _refreshQuickAccessInBackground(
  Ref ref,
  String userId,
  String companyId,
) {
  // Capture repository BEFORE async gap to avoid ref state issues
  final repository = ref.read(homepageRepositoryProvider);

  // Fire and forget - don't await
  Future(() async {
    try {
      if (kDebugMode) {
        debugPrint('🔄 [SWR] Quick access background refresh started...');
      }

      final features = await repository.getQuickAccessFeatures(
        userId: userId,
        companyId: companyId,
      );
      final dynamicFeatures = _convertTopFeaturesToDynamic(features);

      // Save to Hive cache
      await HiveCacheService.instance.saveQuickAccess(userId, companyId, dynamicFeatures);

      if (kDebugMode) {
        debugPrint('✅ [SWR] Quick access background refresh completed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ [SWR] Quick access background refresh failed: $e');
      }
      // Don't throw - background refresh failure is non-critical
    }
  });
}

/// Fetch quick access features from API and cache
Future<List<TopFeature>> _fetchAndCacheQuickAccess(
  Ref ref,
  String userId,
  String companyId,
) async {
  final repository = ref.read(homepageRepositoryProvider);
  final features = await repository.getQuickAccessFeatures(
    userId: userId,
    companyId: companyId,
  );
  final dynamicFeatures = _convertTopFeaturesToDynamic(features);

  // Save to Hive cache
  await HiveCacheService.instance.saveQuickAccess(userId, companyId, dynamicFeatures);

  if (kDebugMode) {
    debugPrint('💾 [SWR] Quick access features cached');
  }

  return features;
}

/// Helper: Convert dynamic data to TopFeature entities
List<TopFeature> _convertDynamicToTopFeatures(List<dynamic> dynamicFeatures) {
  return dynamicFeatures.map((data) {
    final feature = data as Map<String, dynamic>;
    return TopFeature(
      featureId: feature['feature_id'] as String,
      featureName: feature['feature_name'] as String,
      featureDescription: feature['feature_description'] as String?,
      route: feature['route'] as String,
      icon: feature['icon'] as String,
      iconKey: feature['icon_key'] as String?,
      categoryId: feature['category_id'] as String?,
      clickCount: feature['click_count'] as int? ?? 0,
      lastClicked: DateTime.tryParse(feature['last_clicked'] as String? ?? '') ?? DateTime.now(),
    );
  }).toList();
}

/// Helper: Convert TopFeature entities to dynamic for cache storage
List<dynamic> _convertTopFeaturesToDynamic(List<TopFeature> features) {
  return features.map((feature) => {
    'feature_id': feature.featureId,
    'feature_name': feature.featureName,
    'feature_description': feature.featureDescription,
    'route': feature.route,
    'icon': feature.icon,
    'icon_key': feature.iconKey,
    'category_id': feature.categoryId,
    'click_count': feature.clickCount,
    'last_clicked': feature.lastClicked.toIso8601String(),
  }).toList();
}
