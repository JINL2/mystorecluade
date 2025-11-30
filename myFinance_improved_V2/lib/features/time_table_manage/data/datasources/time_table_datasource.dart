
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';

/// Time Table Data Source
///
/// Handles all Supabase RPC calls and database queries for time table management.
class TimeTableDatasource {
  final SupabaseClient _supabase;

  TimeTableDatasource(this._supabase);

  /// Fetch shift metadata from Supabase RPC
  ///
  /// Uses get_shift_metadata_v2 RPC with timezone parameter
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  /// - Returns shift times converted to local timezone
  Future<dynamic> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_shift_metadata_v2',
        params: {
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return [];
      }

      // RPC can return List or Map
      return response;
    } catch (e, stackTrace) {
      throw ShiftMetadataException(
        'Failed to fetch shift metadata: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch monthly shift status for manager from Supabase RPC
  ///
  /// Uses get_monthly_shift_status_manager_v3 RPC with local time + timezone
  /// - p_request_time: Local time (e.g., "2024-11-15 10:30:25") - RPC calculates month range from this
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul")
  /// - Returns 3 months of data starting from the month of p_request_time
  Future<List<dynamic>> getMonthlyShiftStatus({
    required String requestTime,
    required String storeId,
    required String timezone,
  }) async {
    try {
      print('🔵 [getMonthlyShiftStatus] RPC params: requestTime=$requestTime, storeId=$storeId, timezone=$timezone');

      final response = await _supabase.rpc<dynamic>(
        'get_monthly_shift_status_manager_v3',
        params: {
          'p_store_id': storeId,
          'p_request_time': requestTime,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return [];
      }

      if (response is List) {
        return response;
      }

      return [];
    } catch (e, stackTrace) {
      throw ShiftStatusException(
        'Failed to fetch monthly shift status: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch manager overview data from Supabase RPC
  ///
  /// Uses manager_shift_get_overview_v2 RPC with timezone parameter
  /// - p_start_date and p_end_date are local dates (yyyy-MM-dd)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  /// - RPC converts request_time to local timezone for date filtering
  Future<Map<String, dynamic>> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_overview_v2',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': storeId,
          'p_company_id': companyId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      if (response is List && response.isNotEmpty) {
        return response.first as Map<String, dynamic>;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch manager overview: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Fetch manager shift cards from Supabase RPC
  ///
  /// Uses manager_shift_get_cards_v2 RPC with timezone parameter
  /// - p_start_date and p_end_date are local dates (yyyy-MM-dd)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  /// - RPC converts request_time to local timezone for date filtering
  /// - Uses is_problem_v2 and is_problem_solved_v2 columns
  Future<Map<String, dynamic>> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_cards_v2',
        params: {
          'p_start_date': startDate,
          'p_end_date': endDate,
          'p_store_id': storeId,
          'p_company_id': companyId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      // Try to convert to Map if possible
      if (response is Map) {
        final converted = Map<String, dynamic>.from(response);
        return converted;
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch manager shift cards: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Toggle shift request approval status using v2 RPC
  ///
  /// Uses toggle_shift_approval_v2 RPC
  /// - Toggles is_approved state (instead of setting it)
  /// - Updates approved_by and updated_at_utc
  /// - Updates start_time_utc and end_time_utc from store_shifts
  /// - Handles overnight shifts correctly
  /// - Returns void
  Future<void> toggleShiftApproval({
    required List<String> shiftRequestIds,
    required String userId,
  }) async {
    try {
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval_v2',
        params: {
          'p_shift_request_ids': shiftRequestIds,
          'p_user_id': userId,
        },
      );
    } catch (e, stackTrace) {
      throw ShiftApprovalException(
        'Failed to toggle shift approval: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a shift
  Future<void> deleteShift({
    required String shiftId,
  }) async {
    try {
      await _supabase.from('store_shifts').delete().eq('shift_id', shiftId);
    } catch (e, stackTrace) {
      throw ShiftDeletionException(
        'Failed to delete shift: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Delete a shift tag using v2 RPC
  ///
  /// Uses manager_shift_delete_tag_v2 RPC
  /// - Uses notice_tag_v2 column (not notice_tag)
  /// - Updates updated_at_utc (not updated_at)
  /// - Validates permissions (manager or tag owner)
  /// - Protects special tag types (resolution tags require manager permission)
  Future<Map<String, dynamic>> deleteShiftTag({
    required String tagId,
    required String userId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_delete_tag_v2',
        params: {
          'p_tag_id': tagId,
          'p_user_id': userId,
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
        'Failed to delete shift tag: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Insert new schedule (assign employee to shift) using v2 RPC
  ///
  /// Uses manager_shift_insert_schedule_v2 RPC with timezone support
  /// - p_request_time is UTC timestamp (TIMESTAMPTZ)
  /// - p_timezone is user's local timezone (e.g., "Asia/Seoul")
  /// - Handles duplicate detection and overnight shifts
  /// - Calculates start_time_utc and end_time_utc automatically
  Future<Map<String, dynamic>> insertSchedule({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestTime,
    required String approvedBy,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_insert_schedule_v2',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_store_id': storeId,
          'p_request_time': requestTime,
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

  /// Input card data (comprehensive shift update with tags) using v2 RPC
  ///
  /// Uses manager_shift_input_card_v2 RPC with timezone support
  /// - Uses v2/_utc columns (confirm_start_time_utc, confirm_end_time_utc, notice_tag_v2, is_late_v2, is_problem_solved_v2)
  /// - Supports night shifts (when end time < start time, adds 1 day to end time)
  /// - Auto-generates tags when is_late or is_problem_solved values change
  /// - Enriches tags with creator names from users table
  /// - Returns timezone-converted times using p_timezone parameter
  /// - Validates minimum work time (30 min) and maximum work time (12 hours)
  /// - Removes existing auto-generated manual_override tags before adding new ones
  /// - confirmStartTime/confirmEndTime can be null to keep existing values
  Future<Map<String, dynamic>> inputCard({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,  // Nullable - RPC keeps existing if null
    String? confirmEndTime,    // Nullable - RPC keeps existing if null
    String? newTagContent,
    String? newTagType,
    required bool isLate,
    required bool isProblemSolved,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_input_card_v2',
        params: {
          'p_manager_id': managerId,
          'p_shift_request_id': shiftRequestId,
          'p_confirm_start_time': confirmStartTime,  // null is valid - RPC keeps existing
          'p_confirm_end_time': confirmEndTime,      // null is valid - RPC keeps existing
          'p_new_tag_content': newTagContent,
          'p_new_tag_type': newTagType,
          'p_is_late': isLate,
          'p_is_problem_solved': isProblemSolved,
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
        'Failed to input card: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get available employees for shift assignment using v2 RPC
  ///
  /// Uses manager_shift_get_schedule_v2 RPC with timezone support
  /// - Uses start_time_utc and end_time_utc columns from store_shifts
  /// - Returns times converted to local timezone using p_timezone parameter
  /// - Includes timezone information in response
  /// - Returns empty arrays on error instead of throwing
  Future<Map<String, dynamic>> getAvailableEmployees({
    required String storeId,
    required String shiftDate,
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
        return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
      }

      if (response is Map<String, dynamic>) {
        // manager_shift_get_schedule_v2 returns {store_employees: [], store_shifts: [], timezone: ""}
        // Map to expected format {employees: [], shifts: []}
        return {
          'employees': response['store_employees'] ?? <dynamic>[],
          'shifts': response['store_shifts'] ?? <dynamic>[],
        };
      }

      return {'employees': <dynamic>[], 'shifts': <dynamic>[]};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch employee list: $e',
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
      print('🔍 Datasource: Calling manager_shift_get_schedule_v2 with storeId: $storeId, timezone: $timezone');

      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_schedule_v2',
        params: {
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      print('🔍 Datasource: RPC response type: ${response.runtimeType}');
      print('🔍 Datasource: RPC response: $response');

      if (response == null) {
        print('⚠️ Datasource: Response is null');
        return {};
      }

      if (response is Map<String, dynamic>) {
        print('✅ Datasource: Response is Map with keys: ${response.keys.toList()}');
        if (response.containsKey('store_employees')) {
          print('   - store_employees count: ${(response['store_employees'] as List?)?.length ?? 0}');
        }
        if (response.containsKey('store_shifts')) {
          print('   - store_shifts count: ${(response['store_shifts'] as List?)?.length ?? 0}');
        }
        return response;
      }

      print('⚠️ Datasource: Response is not a Map, returning empty');
      return {};
    } catch (e, stackTrace) {
      print('❌ Datasource: Error fetching schedule data: $e');
      throw TimeTableException(
        'Failed to fetch schedule data: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Process bulk shift approval using toggle_shift_approval_v2
  ///
  /// Uses toggle_shift_approval_v2 RPC
  /// - Toggles approval state for multiple shift requests
  /// - Returns void, so we manually construct the result
  Future<Map<String, dynamic>> processBulkApproval({
    required List<String> shiftRequestIds,
    required List<bool> approvalStates,
  }) async {
    try {
      // Get current user ID
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) {
        throw const TimeTableException('User not authenticated');
      }

      // Call toggle_shift_approval_v2 (returns void)
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval_v2',
        params: {
          'p_shift_request_ids': shiftRequestIds,
          'p_user_id': userId,
        },
      );

      // Manually construct success result
      return {
        'total_processed': shiftRequestIds.length,
        'success_count': shiftRequestIds.length,
        'failure_count': 0,
        'successful_ids': shiftRequestIds,
        'errors': <String>[],
      };
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to process bulk approval: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Add bonus to shift
  /// Note: manager_shift_add_bonus RPC doesn't exist, using direct DB update instead
  Future<Map<String, dynamic>> addBonus({
    required String shiftRequestId,
    required double bonusAmount,
    required String bonusReason,
  }) async {
    try {
      // Update shift_requests table directly
      await _supabase
          .from('shift_requests')
          .update({
            'bonus_amount_v2': bonusAmount,
          })
          .eq('shift_request_id', shiftRequestId);

      // Return success result in expected format
      return {
        'success': true,
        'message': 'Bonus added successfully',
        'data': {
          'shift_request_id': shiftRequestId,
          'bonus_amount_v2': bonusAmount,
        },
      };
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to add bonus: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Update bonus amount for shift request
  Future<void> updateBonusAmount({
    required String shiftRequestId,
    required double bonusAmount,
  }) async {
    try {
      await _supabase
          .from('shift_requests')
          .update({'bonus_amount_v2': bonusAmount})
          .eq('shift_request_id', shiftRequestId);
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to update bonus: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
