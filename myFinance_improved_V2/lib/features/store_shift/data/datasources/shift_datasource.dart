import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/services/supabase_service.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../domain/exceptions/store_shift_exceptions.dart';

/// Shift Data Source
///
/// Handles Supabase operations for shift CRUD
class ShiftDataSource {
  final SupabaseService _supabaseService;

  ShiftDataSource(this._supabaseService);

  SupabaseClient get _client => _supabaseService.client;

  /// Fetch all shifts for a specific store with employee count
  ///
  /// Uses RPC function 'get_shift_metadata_with_employee_count'
  Future<List<Map<String, dynamic>>> getShiftsByStoreId(String storeId) async {
    try {
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<List<dynamic>>(
        'get_shift_metadata_with_employee_count',
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
      final localTime = DateTimeUtils.formatLocalTimestamp();
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
  /// Uses RPC function 'edit_store_shift_v2'
  Future<Map<String, dynamic>> updateShift({
    required String shiftId,
    String? shiftName,
    String? startTime,
    String? endTime,
    int? numberShift,
    bool? isCanOvertime,
    int? shiftBonus,
    bool? isActive,
  }) async {
    try {
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'edit_store_shift_v2',
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
          'p_is_active': isActive,
        },
      );

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
  /// Uses RPC function 'edit_store_shift_v2' with p_is_active = false
  Future<void> deleteShift(String shiftId) async {
    try {
      final localTime = DateTimeUtils.formatLocalTimestamp();
      final timezone = DateTimeUtils.getLocalTimezone();

      final response = await _client.rpc<Map<String, dynamic>>(
        'edit_store_shift_v2',
        params: {
          'p_shift_id': shiftId,
          'p_is_active': false,
          'p_time': localTime,
          'p_timezone': timezone,
        },
      );

      if (response['success'] == false) {
        throw ShiftDeletionException(
          response['message'] as String? ?? 'Unknown error',
          StackTrace.current,
        );
      }
    } catch (e, stackTrace) {
      if (e is ShiftDeletionException) rethrow;

      throw ShiftDeletionException(
        'Failed to delete shift $shiftId: $e',
        stackTrace,
      );
    }
  }
}
