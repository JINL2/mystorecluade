import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../domain/entities/feature.dart';
import '../../presentation/providers/app_state_provider.dart';

// Click tracking service provider
final clickTrackingServiceProvider = Provider<ClickTrackingService>((ref) {
  // Pass ref to access app state for company_id
  return ClickTrackingService(ref);
});

class ClickTrackingService {
  final _supabase = Supabase.instance.client;
  final Ref _ref;

  ClickTrackingService(this._ref);

  /// Track when a user clicks on a feature
  Future<void> trackFeatureClick({
    required String featureId,
    required String featureName,
    required String categoryId,
    String? companyId, // Optional parameter for backward compatibility
  }) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return;
      }

      // Get company_id from app state if not provided
      String? effectiveCompanyId = companyId;
      if (effectiveCompanyId == null || effectiveCompanyId.isEmpty) {
        final appState = _ref.read(appStateProvider);
        effectiveCompanyId = appState.companyChoosen;
      }

      // If still no company_id, return early (shouldn't track without company context)
      if (effectiveCompanyId == null || effectiveCompanyId.isEmpty) {
        print('Warning: Cannot track feature click without company_id');
        return;
      }

      // Call the updated log_feature_click function with company_id
      await _supabase.rpc('log_feature_click', params: {
        'p_feature_id': featureId,
        'p_feature_name': featureName,
        'p_company_id': effectiveCompanyId,
        'p_category_id': categoryId,
      });

    } catch (e) {
      // Don't throw error to prevent disrupting user experience
    }
  }

  /// Track feature from Feature entity with required categoryId
  Future<void> trackFeatureEntityClick(Feature feature, {required String categoryId, String? companyId}) async {
    await trackFeatureClick(
      featureId: feature.featureId,
      featureName: feature.featureName,
      categoryId: categoryId,
      companyId: companyId,
    );
  }

  /// Get user's click history for current company
  Future<List<Map<String, dynamic>>> getUserClickHistory({String? companyId}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return [];
      }

      // Get company_id from app state if not provided
      String? effectiveCompanyId = companyId;
      if (effectiveCompanyId == null || effectiveCompanyId.isEmpty) {
        final appState = _ref.read(appStateProvider);
        effectiveCompanyId = appState.companyChoosen;
      }

      if (effectiveCompanyId == null || effectiveCompanyId.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('user_preferences')
          .select('*')
          .eq('user_id', userId)
          .eq('company_id', effectiveCompanyId)
          .order('clicked_at', ascending: false);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }

  /// Get top clicked features for current user and company
  Future<List<Map<String, dynamic>>> getTopClickedFeatures({int limit = 10, String? companyId}) async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        return [];
      }

      // Get company_id from app state if not provided
      String? effectiveCompanyId = companyId;
      if (effectiveCompanyId == null || effectiveCompanyId.isEmpty) {
        final appState = _ref.read(appStateProvider);
        effectiveCompanyId = appState.companyChoosen;
      }

      if (effectiveCompanyId == null || effectiveCompanyId.isEmpty) {
        return [];
      }

      // Use the updated view with company_id filter
      final response = await _supabase
          .from('top_features_by_user')
          .select('*')
          .eq('user_id', userId)
          .eq('company_id', effectiveCompanyId)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e) {
      return [];
    }
  }
}