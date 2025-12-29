import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../domain/exceptions/store_shift_exceptions.dart';

/// Business Hours Data Source
///
/// Handles Supabase operations for business hours
class BusinessHoursDataSource {
  final SupabaseService _supabaseService;

  BusinessHoursDataSource(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  /// Get business hours for a store
  ///
  /// Uses RPC function 'get_store_business_hours'
  Future<List<Map<String, dynamic>>> getBusinessHours(String storeId) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_store_business_hours',
        params: {
          'p_store_id': storeId,
        },
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      throw StoreNotFoundException(
        'Failed to fetch business hours for store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Upsert business hours for a store
  ///
  /// Uses RPC function 'upsert_store_business_hours'
  Future<bool> upsertBusinessHours({
    required String storeId,
    required List<Map<String, dynamic>> hours,
  }) async {
    try {
      final response = await _client.rpc<bool>(
        'upsert_store_business_hours',
        params: {
          'p_store_id': storeId,
          'p_hours': hours,
        },
      );

      return response;
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update business hours: $e',
        stackTrace,
      );
    }
  }
}
