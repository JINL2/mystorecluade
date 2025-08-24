import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/feature_repository.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';
import '../../presentation/providers/app_state_provider.dart';

class SupabaseFeatureRepository implements FeatureRepository {
  final SupabaseClient _client;
  final Ref? _ref; // Optional ref for accessing app state
  
  // Cache for categories with TTL (6 hours)
  static List<CategoryWithFeatures>? _cachedCategories;
  static DateTime? _categoriesCacheTime;
  static const Duration _categoriesCacheTTL = Duration(hours: 6);
  
  // Cache for user top features with TTL (2 hours)
  // Cache now includes company_id in the key
  static final Map<String, List<TopFeature>> _userFeaturesCache = {};
  static final Map<String, DateTime> _userFeaturesCacheTime = {};
  static const Duration _userFeaturesCacheTTL = Duration(hours: 2);

  SupabaseFeatureRepository(this._client, [this._ref]);

  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    try {
      // Check cache first
      if (_cachedCategories != null && _categoriesCacheTime != null) {
        final cacheAge = DateTime.now().difference(_categoriesCacheTime!);
        if (cacheAge < _categoriesCacheTTL) {
          return _cachedCategories!;
        }
      }
      
      // Fetch fresh data with v2/v1 fallback
      dynamic response;
      try {
        response = await _client.rpc('get_categories_with_features_v2');
      } catch (e) {
        // Fallback to original function if v2 doesn't exist yet
        response = await _client.rpc('get_categories_with_features');
      }
      
      if (response == null) return [];
      
      final categories = (response as List)
          .map((json) => CategoryWithFeatures.fromJson(json))
          .toList();
      
      // Cache the result
      _cachedCategories = categories;
      _categoriesCacheTime = DateTime.now();
      
      return categories;
    } catch (e) {
      throw Exception('Failed to fetch categories with features: $e');
    }
  }

  @override
  Future<List<TopFeature>> getTopFeaturesByUser({
    required String userId,
    String? companyId,
  }) async {
    try {
      // Get company_id from app state if not provided and ref is available
      String? effectiveCompanyId = companyId;
      if ((effectiveCompanyId == null || effectiveCompanyId.isEmpty) && _ref != null) {
        try {
          // Import app_state_provider if ref is available
          final appState = _ref!.read(appStateProvider);
          effectiveCompanyId = appState.companyChoosen;
        } catch (e) {
          // If we can't get company_id, proceed without it for backward compatibility
        }
      }
      
      // Create cache key including company_id
      final cacheKey = '${userId}_${effectiveCompanyId ?? 'default'}';
      
      // TEMP: Skip cache for testing - remove this in production
      // Check user-specific cache first
      // if (_userFeaturesCache.containsKey(cacheKey) && _userFeaturesCacheTime.containsKey(cacheKey)) {
      //   final cacheAge = DateTime.now().difference(_userFeaturesCacheTime[cacheKey]!);
      //   if (cacheAge < _userFeaturesCacheTTL) {
      //     return _userFeaturesCache[cacheKey]!;
      //   }
      // }
      
      
      // Use the updated RPC function with company_id parameter
      final params = <String, dynamic>{'p_user_id': userId};
      if (effectiveCompanyId != null && effectiveCompanyId.isNotEmpty) {
        params['p_company_id'] = effectiveCompanyId;
      }
      
      final response = await _client.rpc('get_user_quick_access_features', params: params);
      
      
      if (response == null) {
        return [];
      }
      
      if (response is List) {
        
        if (response.isEmpty) {
          return [];
        }
        
        
        final features = <TopFeature>[];
        final realUserFeatures = <TopFeature>[];
        
        for (final feature in response) {
          try {
            final topFeature = TopFeature.fromJson(feature as Map<String, dynamic>);
            features.add(topFeature);
            
            // Separate real user features (with actual clicks) from defaults
            final isDefault = feature['is_default'] == true;
            final hasRealClicks = topFeature.clickCount > 0;
            
            if (!isDefault && hasRealClicks) {
              realUserFeatures.add(topFeature);
            }
            
          } catch (e) {
          }
        }
        
        // 🎯 IMPROVED LOGIC: The RPC function now handles defaults, so we return what it gives us
        // This allows the database function to decide the best features to show
        
        if (features.isNotEmpty) {
          // Sort all features by click count (real clicks first, then defaults)
          features.sort((a, b) {
            // Prioritize real user features (non-default with clicks > 0)
            final aIsReal = a.clickCount > 0;
            final bIsReal = b.clickCount > 0;
            
            if (aIsReal && !bIsReal) return -1; // a comes first
            if (!aIsReal && bIsReal) return 1;  // b comes first
            
            // Both are real or both are default, sort by click count
            return b.clickCount.compareTo(a.clickCount);
          });
          
          final topFeatures = features.take(6).toList();
          
          // Cache and return features
          _userFeaturesCache[cacheKey] = topFeatures;
          _userFeaturesCacheTime[cacheKey] = DateTime.now();
          return topFeatures;
        } else {
          // No features returned from RPC - cache empty result
          _userFeaturesCache[cacheKey] = [];
          _userFeaturesCacheTime[cacheKey] = DateTime.now();
          return [];
        }
      }
      
      return [];
    } catch (e) {
      throw Exception('Failed to fetch top features by user: $e');
    }
  }

  @override
  Future<void> trackFeatureClick({
    required String userId,
    required String featureId,
  }) async {
    try {
      // Clear user's cached top features since click data changed
      _userFeaturesCache.remove(userId);
      _userFeaturesCacheTime.remove(userId);
      
      // This would call an RPC function to track feature clicks
      // The RPC function would update the click count and last_clicked timestamp
      await _client.rpc('track_feature_click', params: {
        'p_user_id': userId,
        'p_feature_id': featureId,
      });
    } catch (e) {
      // Fail silently for tracking - we don't want to interrupt user flow
    }
  }
  
  /// Clear all caches (useful for testing or manual refresh)
  static void clearCache() {
    _cachedCategories = null;
    _categoriesCacheTime = null;
    _userFeaturesCache.clear();
    _userFeaturesCacheTime.clear();
  }
  
  /// Clear cache for specific user (clears all company contexts)
  static void clearUserCache(String userId) {
    // Clear all cache entries that start with this userId
    final keysToRemove = _userFeaturesCache.keys
        .where((key) => key.startsWith(userId))
        .toList();
    for (final key in keysToRemove) {
      _userFeaturesCache.remove(key);
      _userFeaturesCacheTime.remove(key);
    }
  }
}