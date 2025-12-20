import 'package:flutter/foundation.dart';
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
  /// Uses get_shift_metadata_v2_utc RPC with timezone parameter
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  /// - Returns shift times converted to local timezone
  Future<dynamic> getShiftMetadata({
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_shift_metadata_v2_utc',
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
  /// Uses get_monthly_shift_status_manager_v4 RPC with timezone parameters
  /// - p_request_time must be user's LOCAL timestamp in "yyyy-MM-dd HH:mm:ss" format
  ///   (no timezone info, local time as-is)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// - Returns shift data based on actual work date (start_time_utc converted to timezone)
  Future<List<dynamic>> getMonthlyShiftStatus({
    required String requestTime,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_monthly_shift_status_manager_v4',
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
  /// Uses manager_shift_get_overview_v3 RPC with timezone parameter
  /// - p_start_date and p_end_date are user's local dates (yyyy-MM-dd)
  /// - p_store_id is optional (NULL for all stores)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// - Filters by start_time_utc converted to timezone (actual work date)
  Future<Map<String, dynamic>> getManagerOverview({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_overview_v3',
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
  /// Uses manager_shift_get_cards_v5 RPC with timezone parameter
  /// - p_company_id is the company UUID
  /// - p_start_date and p_end_date are user's local dates (yyyy-MM-dd)
  /// - p_store_id is optional (NULL for all stores)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// - Filters by start_time_utc converted to timezone (actual work date)
  /// - Uses v_shift_request view with is_problem_v2, is_problem_solved_v2 columns
  /// - v5 adds: problem_details (JSONB with detailed problem info for calendar)
  Future<Map<String, dynamic>> getManagerShiftCards({
    required String startDate,
    required String endDate,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'manager_shift_get_cards_v5',
        params: {
          'p_company_id': companyId,
          'p_start_date': startDate,
          'p_end_date': endDate,
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

  /// Toggle shift request approval status using v3 RPC
  ///
  /// Uses toggle_shift_approval_v3 RPC
  /// - Toggles is_approved state (TRUE ↔ FALSE)
  /// - Updates approved_by and updated_at_utc
  /// - No longer recalculates start_time_utc/end_time_utc (already set by insert_shift_request_v6)
  /// - Returns void
  Future<void> toggleShiftApproval({
    required List<String> shiftRequestIds,
    required String userId,
  }) async {
    try {
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval_v3',
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

  /// Process bulk shift approval using toggle_shift_approval_v3
  ///
  /// Uses toggle_shift_approval_v3 RPC
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

      // Call toggle_shift_approval_v3 (returns void)
      await _supabase.rpc<dynamic>(
        'toggle_shift_approval_v3',
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

  /// Get reliability score data for stats tab
  ///
  /// Uses get_reliability_score RPC
  /// - p_time must be user's LOCAL timestamp in "yyyy-MM-dd HH:mm:ss" format
  ///   (no timezone conversion - send device local time as-is)
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul", "America/Los_Angeles")
  /// - Returns shift_summary (today, yesterday, this_month, last_month, two_months_ago)
  /// - Returns understaffed_shifts counts per period
  /// - Returns employees with reliability scores
  Future<Map<String, dynamic>> getReliabilityScore({
    required String companyId,
    required String storeId,
    required String time,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_reliability_score',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_time': time,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch reliability score: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get employee info for a specific store
  ///
  /// Uses get_employee_info RPC
  /// - p_store_id: When provided, returns only employees for that store
  /// - Returns user_id, full_name, email, role_ids, role_names, stores, etc.
  /// - Used to filter reliability leaderboard by store employees
  Future<List<dynamic>> getStoreEmployees({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_employee_info',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
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
      throw TimeTableException(
        'Failed to fetch store employees: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Input card data (manager updates shift) using v5 RPC
  ///
  /// Uses manager_shift_input_card_v5 RPC
  /// - Simplified parameters: confirm times, report solved status, bonus amount, manager memo
  /// - Times must be in user's LOCAL timezone (HH:mm:ss format with timezone)
  /// - RPC converts local times to UTC internally
  /// - Returns simple success/error response
  ///
  /// Parameters:
  /// - [managerId] - Manager user ID performing the update
  /// - [shiftRequestId] - Shift request ID to update
  /// - [confirmStartTime] - Confirmed start time (HH:mm:ss format), null to keep existing
  /// - [confirmEndTime] - Confirmed end time (HH:mm:ss format), null to keep existing
  /// - [isProblemSolved] - Problem solved status (for Late/Overtime), null to keep existing
  /// - [isReportedSolved] - Report solved status (for employee reports), null to keep existing
  /// - [bonusAmount] - Bonus amount, null to keep existing
  /// - [managerMemo] - Manager memo text, null to keep existing (new in v5)
  /// - [timezone] - User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  Future<Map<String, dynamic>> inputCardV5({
    required String managerId,
    required String shiftRequestId,
    String? confirmStartTime,
    String? confirmEndTime,
    bool? isProblemSolved,
    bool? isReportedSolved,
    double? bonusAmount,
    String? managerMemo,
    required String timezone,
  }) async {
    try {
      final rpcParams = {
        'p_manager_id': managerId,
        'p_shift_request_id': shiftRequestId,
        'p_confirm_start_time': confirmStartTime,
        'p_confirm_end_time': confirmEndTime,
        'p_is_problem_solved': isProblemSolved,
        'p_is_reported_solved': isReportedSolved,
        'p_bonus_amount': bonusAmount,
        'p_manager_memo': managerMemo,
        'p_timezone': timezone,
      };

      debugPrint('[Datasource] inputCardV5 RPC params: $rpcParams');

      final response = await _supabase.rpc<dynamic>(
        'manager_shift_input_card_v5',
        params: rpcParams,
      );

      debugPrint('[Datasource] inputCardV5 RPC response: $response');

      if (response == null) {
        return {'success': false, 'error': 'NULL_RESPONSE', 'message': 'No response from server'};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      return {'success': false, 'error': 'INVALID_RESPONSE', 'message': 'Invalid response format'};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to input card v5: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Get employee monthly detail log
  ///
  /// Uses get_employee_monthly_detail_log RPC
  /// - Returns comprehensive monthly data including shifts, audit logs, summary, salary
  /// - p_year_month: Format 'YYYY-MM' (e.g., '2024-12')
  /// - p_timezone: User's local timezone for date conversions
  Future<Map<String, dynamic>> getEmployeeMonthlyDetailLog({
    required String userId,
    required String companyId,
    required String yearMonth,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_employee_monthly_detail_log',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_year_month': yearMonth,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return {'success': false, 'error': 'NULL_RESPONSE'};
      }

      if (response is Map<String, dynamic>) {
        return response;
      }

      if (response is Map) {
        return Map<String, dynamic>.from(response);
      }

      return {'success': false, 'error': 'INVALID_RESPONSE'};
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch employee monthly detail: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
