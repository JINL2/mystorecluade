import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';

/// Schedule Data Source
///
/// Handles Supabase RPC calls for schedule operations (insert and retrieve).
class ScheduleDatasource {
  final SupabaseClient _supabase;

  ScheduleDatasource(this._supabase);

  /// Insert new schedule (assign employee to shift) using v4 RPC
  ///
  /// Uses manager_shift_insert_schedule_v4 RPC
  /// - p_start_time and p_end_time are user's LOCAL timestamps (yyyy-MM-dd HH:mm:ss)
  /// - p_timezone is required for converting local time to UTC
  /// - Duplicate check based on (user_id, shift_id, start_time_utc, end_time_utc)
  /// - No longer uses request_date or request_time columns
  Future<Map<String, dynamic>> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String approvedBy,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_insert_schedule_v4',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_store_id': storeId,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_approved_by': approvedBy,
          'p_timezone': timezone,
        },
      );

      if (response == null) return {};

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to add schedule: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get schedule data (employees and shifts) using v2 RPC
  ///
  /// Uses manager_shift_get_schedule_v2 RPC with timezone support
  /// - Uses start_time_utc and end_time_utc columns from store_shifts
  /// - Returns times converted to local timezone using p_timezone parameter
  /// - Includes timezone information in response
  Future<Map<String, dynamic>> getScheduleData({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_schedule_v2',
        params: {
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch schedule data: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
