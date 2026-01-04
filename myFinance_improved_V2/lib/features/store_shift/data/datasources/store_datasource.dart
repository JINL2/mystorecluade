import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/store_shift_exceptions.dart';

/// Store Data Source
///
/// Handles Supabase operations for store information and settings
class StoreDataSource {
  final SupabaseService _supabaseService;

  StoreDataSource(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  /// Get detailed store information by ID
  Future<Map<String, dynamic>> getStoreById(String storeId) async {
    try {
      final response = await _client
          .from('stores')
          .select()
          .eq('store_id', storeId)
          .single();

      return response;
    } catch (e, stackTrace) {
      throw StoreNotFoundException(
        'Failed to fetch store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Update store location
  ///
  /// Uses RPC function 'update_store_location'
  Future<void> updateStoreLocation({
    required String storeId,
    required double latitude,
    required double longitude,
    required String address,
  }) async {
    try {
      await _client.rpc<void>(
        'update_store_location',
        params: {
          'p_store_id': storeId,
          'p_latitude': latitude,
          'p_longitude': longitude,
          'p_address': address,
        },
      );
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update store location: $e',
        stackTrace,
      );
    }
  }

  /// Update operational settings
  ///
  /// Uses RPC function 'update_store_setting'
  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    try {
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'update_store_setting',
        params: {
          'p_store_id': storeId,
          'p_huddle_time': huddleTime,
          'p_payment_time': paymentTime,
          'p_allowed_distance': allowedDistance,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      if (response['success'] == false) {
        throw Exception(response['message'] ?? 'Unknown error');
      }
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update operational settings: $e',
        stackTrace,
      );
    }
  }

  /// Update store information (name, email, phone, address)
  ///
  /// Direct update to stores table
  Future<void> updateStoreInfo({
    required String storeId,
    String? storeName,
    String? storeEmail,
    String? storePhone,
    String? storeAddress,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'updated_at': DateTime.now().toIso8601String(),
        'updated_at_utc': DateTime.now().toUtc().toIso8601String(),
      };

      if (storeName != null) updateData['store_name'] = storeName;
      if (storeEmail != null) updateData['store_email'] = storeEmail;
      if (storePhone != null) updateData['store_phone'] = storePhone;
      if (storeAddress != null) updateData['store_address'] = storeAddress;

      await _client
          .from('stores')
          .update(updateData)
          .eq('store_id', storeId);
    } catch (e, stackTrace) {
      throw StoreLocationUpdateException(
        'Failed to update store info: $e',
        stackTrace,
      );
    }
  }
}
