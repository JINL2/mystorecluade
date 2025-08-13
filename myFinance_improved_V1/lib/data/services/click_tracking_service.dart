import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/feature.dart';

// Click tracking service provider
final clickTrackingServiceProvider = Provider<ClickTrackingService>((ref) {
  return ClickTrackingService();
});

class ClickTrackingService {
  final _supabase = Supabase.instance.client;

  /// Track when a user clicks on a feature
  Future<void> trackFeatureClick({
    required String featureId,
    required String featureName,
    required String categoryId,
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        print('ClickTrackingService: No user logged in, skipping tracking');
        return;
      }

      // Create the tracking data according to the schema
      final trackingData = {
        'user_id': userId,
        'feature_id': featureId,
        'feature_name': featureName,
        'category_id': categoryId,
        'clicked_at': DateTime.now().toIso8601String(),
      };

      // Insert into user_preferences table
      await _supabase
          .from('user_preferences')
          .insert(trackingData);

      print('ClickTrackingService: Successfully tracked click for feature: $featureName');
    } catch (e) {
      // Don't throw error to prevent disrupting user experience
      print('ClickTrackingService Error: Failed to track click: $e');
    }
  }

  /// Track feature from Feature entity with required categoryId
  Future<void> trackFeatureEntityClick(Feature feature, {required String categoryId}) async {
    await trackFeatureClick(
      featureId: feature.featureId,
      featureName: feature.featureName,
      categoryId: categoryId,
    );
  }

  /// Get user's click history
  Future<List<Map<String, dynamic>>> getUserClickHistory() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return [];
      }

      final response = await _supabase
          .from('user_preferences')
          .select('*')
          .eq('user_id', userId)
          .order('clicked_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('ClickTrackingService Error: Failed to get click history: $e');
      return [];
    }
  }

  /// Get top clicked features for current user
  Future<List<Map<String, dynamic>>> getTopClickedFeatures({int limit = 10}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return [];
      }

      // Use the view if available, otherwise query directly
      final response = await _supabase
          .from('top_features_by_user')
          .select('*')
          .eq('user_id', userId)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      print('ClickTrackingService Error: Failed to get top features: $e');
      return [];
    }
  }
}