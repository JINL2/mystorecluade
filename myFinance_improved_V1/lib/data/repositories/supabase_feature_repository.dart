import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/repositories/feature_repository.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';

class SupabaseFeatureRepository implements FeatureRepository {
  final SupabaseClient _client;

  SupabaseFeatureRepository(this._client);

  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    try {
      // This would call the existing RPC function get_categories_with_features
      final response = await _client.rpc('get_categories_with_features');
      
      if (response == null) return [];
      
      return (response as List)
          .map((json) => CategoryWithFeatures.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch categories with features: $e');
    }
  }

  @override
  Future<List<TopFeature>> getTopFeaturesByUser({
    required String userId,
  }) async {
    try {
      // Query the top_features_by_user view
      final response = await _client
          .from('top_features_by_user')
          .select('*')
          .eq('user_id', userId)
          .order('click_count', ascending: false)
          .limit(10); // Limit to top 10 features
      
      if (response.isEmpty) return [];
      
      // The response should contain a single row with top_features as JSON array
      final topFeaturesJson = response.first['top_features'] as List;
      
      return topFeaturesJson
          .map((json) => TopFeature.fromJson(json))
          .toList();
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
      // This would call an RPC function to track feature clicks
      // The RPC function would update the click count and last_clicked timestamp
      await _client.rpc('track_feature_click', params: {
        'p_user_id': userId,
        'p_feature_id': featureId,
      });
    } catch (e) {
      // Fail silently for tracking - we don't want to interrupt user flow
      print('Failed to track feature click: $e');
    }
  }
}