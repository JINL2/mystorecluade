import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/store_shift_exceptions.dart';

/// Store Shift Data Source
///
/// Handles all Supabase database operations for store shifts.
/// This layer is responsible for:
/// - Direct Supabase client calls
/// - RPC function calls
/// - Table queries (INSERT, UPDATE, DELETE, SELECT)
/// - Error handling and exception throwing
class StoreShiftDataSource {
  final SupabaseService _supabaseService;

  StoreShiftDataSource(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  /// Fetch all shifts for a specific store
  ///
  /// Uses RPC function 'get_shift_metadata_v2_utc'
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_timezone: text (IANA timezone, e.g., 'Asia/Seoul')
  ///
  /// Returns shifts with time converted to user's local timezone
  Future<List<Map<String, dynamic>>> getShiftsByStoreId(String storeId) async {
    try {
      // Get IANA timezone name (e.g., 'Asia/Seoul', 'Asia/Ho_Chi_Minh')
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<List<dynamic>>(
        'get_shift_metadata_v2_utc',
        params: {
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      return List<Map<String, dynamic>>.from(response);
    } catch (e, stackTrace) {
      throw ShiftNotFoundException(
        'Failed to fetch shifts for store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Create a new shift
  ///
  /// Uses RPC function 'create_store_shift'
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_shift_name: text (required)
  /// - p_start_time: text (local time, HH:mm format)
  /// - p_end_time: text (local time, HH:mm format)
  /// - p_number_shift: integer (optional, default: 1)
  /// - p_is_can_overtime: boolean (optional, default: true)
  /// - p_shift_bonus: numeric (optional, default: 0)
  /// - p_time: text (local timestamp, 'yyyy-MM-dd HH:mm:ss')
  /// - p_timezone: text (IANA timezone, e.g., 'Asia/Seoul')
  Future<Map<String, dynamic>> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    try {
      // Get current local time formatted as 'yyyy-MM-dd HH:mm:ss'
      final now = DateTime.now();
      final localTime = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      // Get IANA timezone name (e.g., 'Asia/Seoul', 'Asia/Ho_Chi_Minh')
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'create_store_shift',
        params: {
          'p_store_id': storeId,
          'p_shift_name': shiftName,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_number_shift': numberShift,
          'p_is_can_overtime': isCanOvertime,
          'p_shift_bonus': shiftBonus,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      // Check RPC response for success
      if (response['success'] == false) {
        throw ShiftCreationException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftCreationException) rethrow;

      throw ShiftCreationException(
        'Failed to create shift: $e',
        stackTrace,
      );
    }
  }

  /// Update an existing shift
  ///
  /// Uses RPC function 'edit_store_shift'
  /// Parameters:
  /// - p_shift_id: uuid (required)
  /// - p_shift_name: text (optional)
  /// - p_start_time: text (local time, HH:mm format)
  /// - p_end_time: text (local time, HH:mm format)
  /// - p_number_shift: integer (optional, required employees)
  /// - p_is_can_overtime: boolean (optional)
  /// - p_shift_bonus: numeric (optional)
  /// - p_time: text (local timestamp, 'yyyy-MM-dd HH:mm:ss')
  /// - p_timezone: text (IANA timezone, e.g., 'Asia/Seoul')
  Future<Map<String, dynamic>> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
  }) async {
    try {
      // Get current local time formatted as 'yyyy-MM-dd HH:mm:ss'
      final now = DateTime.now();
      final localTime = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      // Get IANA timezone name (e.g., 'Asia/Seoul', 'Asia/Ho_Chi_Minh')
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'edit_store_shift',
        params: {
          'p_shift_id': shiftId,
          'p_shift_name': shiftName,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_number_shift': numberShift,
          'p_is_can_overtime': isCanOvertime,
          'p_shift_bonus': shiftBonus,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      // Check RPC response for success
      if (response['success'] == false) {
        throw ShiftUpdateException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }

      return response;
    } catch (e, stackTrace) {
      if (e is ShiftUpdateException) rethrow;

      throw ShiftUpdateException(
        'Failed to update shift $shiftId: $e',
        stackTrace,
      );
    }
  }

  /// Delete a shift (soft delete)
  ///
  /// Sets is_active to false instead of hard delete
  Future<void> deleteShift(String shiftId) async {
    try {
      await _client
          .from('store_shifts')
          .update({'is_active': false})
          .eq('shift_id', shiftId);
    } catch (e, stackTrace) {
      throw ShiftDeletionException(
        'Failed to delete shift $shiftId: $e',
        stackTrace,
      );
    }
  }

  /// Get detailed store information by ID
  ///
  /// Uses direct table query on 'stores'
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
      await _client.rpc<void>('update_store_location', params: {
        'p_store_id': storeId,
        'p_latitude': latitude,
        'p_longitude': longitude,
        'p_address': address,
      },);
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
  /// Parameters:
  /// - p_store_id: uuid (required)
  /// - p_huddle_time: integer (optional)
  /// - p_payment_time: integer (optional)
  /// - p_allowed_distance: integer (optional)
  /// - p_time: text (local time, e.g., '2025-11-26 16:30:00')
  /// - p_timezone: text (e.g., 'Asia/Ho_Chi_Minh')
  Future<void> updateOperationalSettings({
    required String storeId,
    int? huddleTime,
    int? paymentTime,
    int? allowedDistance,
  }) async {
    try {
      // Get current local time formatted as 'yyyy-MM-dd HH:mm:ss'
      final now = DateTime.now();
      final localTime = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} '
          '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}';

      // Get IANA timezone name (e.g., 'Asia/Seoul', 'Asia/Ho_Chi_Minh')
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

      // Check RPC response for success
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
}
