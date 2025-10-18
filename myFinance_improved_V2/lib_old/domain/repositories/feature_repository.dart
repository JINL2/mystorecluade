import 'package:supabase_flutter/supabase_flutter.dart';
import '../../presentation/pages/homepage/models/homepage_models.dart';

abstract class FeatureRepository {
  /// Get all categories with their features
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures();
  
  /// Get top features by user based on usage statistics
  /// This fetches data from the top_features_by_user view in Supabase
  Future<List<TopFeature>> getTopFeaturesByUser({
    required String userId,
    String? companyId,
  });
  
  /// Update feature click count (for tracking usage)
  Future<void> trackFeatureClick({
    required String userId,
    required String featureId,
  });
}


// Supabase implementation
class SupabaseFeatureRepository implements FeatureRepository {
  @override
  Future<List<CategoryWithFeatures>> getCategoriesWithFeatures() async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_categories_with_features');
      
      
      if (response == null) {
        return [];
      }
      
      if (response is List) {
        return (response as List<dynamic>)
            .map((category) => CategoryWithFeatures.fromJson(category as Map<String, dynamic>))
            .toList();
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<TopFeature>> getTopFeaturesByUser({required String userId, String? companyId}) async {
    try {
      
      final params = <String, dynamic>{'p_user_id': userId};
      if (companyId != null && companyId.isNotEmpty) {
        params['p_company_id'] = companyId;
      }
      
      final response = await Supabase.instance.client
          .rpc('get_user_quick_access_features', params: params);
      
      
      if (response == null) {
        return [];
      }
      
      if (response is List) {
        final features = (response as List<dynamic>)
            .map((feature) => TopFeature.fromJson(feature as Map<String, dynamic>))
            .toList();
        
        return features;
      }
      
      return [];
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> trackFeatureClick({
    required String userId,
    required String featureId,
  }) async {
    try {
      // For now do nothing - can be implemented later
    } catch (e) {
      // Ignore errors for now
    }
  }
}