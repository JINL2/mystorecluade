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
  /// Uses direct table query on 'store_shifts'
  /// Filters: store_id, is_active = true
  /// Order: start_time_utc ascending
  ///
  /// Note: Fetches both legacy (created_at, updated_at) and new (created_at_utc, updated_at_utc) columns
  Future<List<Map<String, dynamic>>> getShiftsByStoreId(String storeId) async {
    try {
      final response = await _client
          .from('store_shifts')
          .select('shift_id, shift_name, start_time_utc, end_time_utc, shift_bonus, is_active, created_at, updated_at, created_at_utc, updated_at_utc')
          .eq('store_id', storeId)
          .eq('is_active', true)
          .order('start_time_utc', ascending: true);

      return List<Map<String, dynamic>>.from(response as List);
    } catch (e, stackTrace) {
      throw ShiftNotFoundException(
        'Failed to fetch shifts for store $storeId: $e',
        stackTrace,
      );
    }
  }

  /// Create a new shift
  ///
  /// Uses INSERT on 'store_shifts' table
  /// Stores all time data in *_utc columns (timetz type with timezone offset)
  /// - start_time_utc, end_time_utc: HH:mm+ZZ:ZZ format
  /// - created_at_utc, updated_at_utc: HH:mm:ss+ZZ:ZZ format
  Future<Map<String, dynamic>> createShift({
    required String storeId,
    required String shiftName,
    required String startTime,
    required String endTime,
    required int shiftBonus,
  }) async {
    try {
      // Get current time with timezone offset (HH:mm:ss+ZZ:ZZ format)
      final now = DateTime.now();
      final currentTime = _formatDateTimeWithTimezone(now);

      final insertData = {
        'store_id': storeId,
        'shift_name': shiftName,
        // timetz columns with timezone
        'start_time_utc': startTime,
        'end_time_utc': endTime,
        'created_at_utc': currentTime,
        'updated_at_utc': currentTime,
        'shift_bonus': shiftBonus,
        'is_active': true,
      };

      final response = await _client
          .from('store_shifts')
          .insert(insertData)
          .select()
          .single();

      return response;
    } catch (e, stackTrace) {
      throw ShiftCreationException(
        'Failed to create shift: $e',
        stackTrace,
      );
    }
  }

  /// Format DateTime to timetz format with timezone offset
  /// Example: 2025-01-15 14:30:45 in UTC+9 -> "14:30:45+09:00"
  String _formatDateTimeWithTimezone(DateTime dateTime) {
    final offset = dateTime.timeZoneOffset;

    // Format time part (HH:mm:ss)
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    // Format timezone offset (+HH:mm or -HH:mm)
    final offsetHours = offset.inHours.abs().toString().padLeft(2, '0');
    final offsetMinutes = (offset.inMinutes.abs() % 60).toString().padLeft(2, '0');
    final offsetSign = offset.isNegative ? '-' : '+';

    return '$hour:$minute:$second$offsetSign$offsetHours:$offsetMinutes';
  }

  /// Update an existing shift
  ///
  /// Uses UPDATE on 'store_shifts' table
  /// Updates *_utc columns (timetz type with timezone offset)
  /// Always updates updated_at_utc with current time (HH:mm:ss+ZZ:ZZ format)
  Future<Map<String, dynamic>> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? shiftBonus,
  }) async {
    try {
      final updateData = <String, dynamic>{};

      if (shiftName != null) updateData['shift_name'] = shiftName;
      if (startTime != null) updateData['start_time_utc'] = startTime;
      if (endTime != null) updateData['end_time_utc'] = endTime;
      if (shiftBonus != null) updateData['shift_bonus'] = shiftBonus;

      if (updateData.isEmpty) {
        throw const InvalidShiftDataException('No fields to update');
      }

      // Always update updated_at_utc with current time
      final now = DateTime.now();
      updateData['updated_at_utc'] = _formatDateTimeWithTimezone(now);

      final response = await _client
          .from('store_shifts')
          .update(updateData)
          .eq('shift_id', shiftId)
          .select()
          .single();

      return response;
    } catch (e, stackTrace) {
      if (e is InvalidShiftDataException) rethrow;

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
