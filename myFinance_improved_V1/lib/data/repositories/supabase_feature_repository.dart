import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/feature_repository.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';

class SupabaseFeatureRepository implements FeatureRepository {
  final SupabaseClient _client;
  
  // Cache for categories with TTL (6 hours)
  static List<CategoryWithFeatures>? _cachedCategories;
  static DateTime? _categoriesCacheTime;
  static const Duration _categoriesCacheTTL = Duration(hours: 6);
  
  // Cache for user top features with TTL (2 hours)
  static final Map<String, List<TopFeature>> _userFeaturesCache = {};
  static final Map<String, DateTime> _userFeaturesCacheTime = {};
  static const Duration _userFeaturesCacheTTL = Duration(hours: 2);

  SupabaseFeatureRepository(this._client);

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
  }) async {
    try {
      // Check user-specific cache first
      if (_userFeaturesCache.containsKey(userId) && _userFeaturesCacheTime.containsKey(userId)) {
        final cacheAge = DateTime.now().difference(_userFeaturesCacheTime[userId]!);
        if (cacheAge < _userFeaturesCacheTTL) {
          return _userFeaturesCache[userId]!;
        }
      }
      
      
      // Use the RPC function instead of the view since the view doesn't exist or has wrong columns
      final response = await _client.rpc('get_user_quick_access_features', params: {'p_user_id': userId});
      
      
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
        
        // 🎯 SMART LOGIC: Only return features if user has sufficient real usage
        const minFeaturesForQuickAccess = 6;
        
        if (realUserFeatures.length >= minFeaturesForQuickAccess) {
          // User has enough real usage - show top clicked features
          realUserFeatures.sort((a, b) => b.clickCount.compareTo(a.clickCount));
          final topFeatures = realUserFeatures.take(6).toList();
          
          
          // Cache and return real user features only
          _userFeaturesCache[userId] = topFeatures;
          _userFeaturesCacheTime[userId] = DateTime.now();
          return topFeatures;
        } else {
          // Insufficient real usage - return empty to hide Quick Access
          
          // Cache empty result to avoid repeated API calls
          _userFeaturesCache[userId] = [];
          _userFeaturesCacheTime[userId] = DateTime.now();
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
  
  /// Clear cache for specific user
  static void clearUserCache(String userId) {
    _userFeaturesCache.remove(userId);
    _userFeaturesCacheTime.remove(userId);
  }
}