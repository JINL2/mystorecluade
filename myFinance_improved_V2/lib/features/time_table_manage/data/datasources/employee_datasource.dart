import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/time_table_exceptions.dart';

/// Employee Data Source
///
/// Handles Supabase RPC calls for employee-related operations:
/// - Reliability score and statistics
/// - Store employees list
/// - Employee monthly detail logs
/// - Shift audit logs
class EmployeeDatasource {
  final SupabaseClient _supabase;

  EmployeeDatasource(this._supabase);

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

  /// Get shift audit logs for a specific shift request
  ///
  /// Queries shift_request_audit_log table directly
  /// - Returns all audit log entries ordered by changed_at (oldest first)
  /// - Shows who changed what, when, and how
  /// - Uses RPC to join user profile info (name, profile image)
  Future<List<dynamic>> getShiftAuditLogs({
    required String shiftRequestId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_shift_audit_logs',
        params: {'p_shift_request_id': shiftRequestId},
      );

      return response as List<dynamic>;
    } catch (e, stackTrace) {
      throw TimeTableException(
        'Failed to fetch shift audit logs: $e',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }
}
