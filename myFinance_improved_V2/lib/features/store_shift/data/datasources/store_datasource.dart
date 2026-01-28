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
  ///
  /// Uses RPC function 'get_store_info_v2' to fetch store with latitude/longitude
  Future<Map<String, dynamic>> getStoreById({
    required String storeId,
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_store_info_v2',
        params: {'p_company_id': companyId},
      );

      // Find the store by storeId from the list
      final store = response.cast<Map<String, dynamic>>().firstWhere(
        (s) => s['store_id'] == storeId,
        orElse: () => <String, dynamic>{},
      );

      if (store.isEmpty) {
        throw Exception('Store not found');
      }

      return store;
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
  /// Uses RPC function 'store_shift_update_store_info'
  Future<void> updateStoreInfo({
    required String storeId,
    String? storeName,
    String? storeEmail,
    String? storePhone,
    String? storeAddress,
  }) async {
    try {
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'store_shift_update_store_info',
        params: {
          'p_store_id': storeId,
          'p_store_name': storeName,
          'p_store_email': storeEmail,
          'p_store_phone': storePhone,
          'p_store_address': storeAddress,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      if (response['success'] == false) {
        throw StoreLocationUpdateException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      if (e is StoreLocationUpdateException) rethrow;

      throw StoreLocationUpdateException(
        'Failed to update store info: $e',
        stackTrace,
      );
    }
  }
}
