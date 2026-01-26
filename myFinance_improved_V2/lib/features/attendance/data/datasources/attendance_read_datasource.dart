import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/attendance_exceptions.dart';

/// Attendance Read Data Source
///
/// Handles all READ operations for attendance data:
/// - getUserShiftCards: Fetch user shift cards for the month
/// - getShiftMetadata: Get shift metadata for a store
/// - getMonthlyShiftStatusManager: Get monthly shift status for manager view
/// - getBaseCurrency: Get base currency for a company
/// - getUserShiftStats: Get user shift stats
class AttendanceReadDatasource {
  final SupabaseClient _supabase;

  AttendanceReadDatasource(this._supabase);

  /// Process nested data structures from database
  ///
  /// **Purpose**: Handle nested JSON structures (e.g., store_shifts)
  /// **Important**: Does NOT perform timezone conversion!
  ///
  /// Timezone conversion strategy:
  /// - Database stores: TIMESTAMPTZ in UTC
  /// - Datasource returns: UTC strings unchanged
  /// - Model layer converts: UTC -> Local time (via DateTimeUtils.toLocal())
  /// - UI displays: Local time
  Map<String, dynamic> _processNestedData(
    Map<String, dynamic> data, {
    int depth = 0,
    int maxDepth = 10,
  }) {
    // Prevent stack overflow from circular references
    if (depth >= maxDepth) {
      return data;
    }

    final result = Map<String, dynamic>.from(data);

    // Recursively process nested structures with depth tracking
    if (result['store_shifts'] is Map<String, dynamic>) {
      result['store_shifts'] = _processNestedData(
        result['store_shifts'] as Map<String, dynamic>,
        depth: depth + 1,
        maxDepth: maxDepth,
      );
    }

    return result;
  }

  /// Fetch user shift cards for the month
  ///
  /// Uses user_shift_cards_v7 RPC with local time + timezone
  /// - p_request_time: Local timestamp (e.g., "2025-12-15 10:00:00") - no timezone offset
  /// - p_timezone: User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  /// - Returns shift cards filtered by start_time_utc (actual shift date)
  ///
  /// v5 changes:
  /// - Individual problem columns removed (is_late, late_minutes, is_extratime, etc.)
  /// - problem_details JSONB added (all problem info unified)
  /// v6: storeId optional - null queries entire company
  /// v7: manager_memo added - displays memo left by manager
  Future<List<Map<String, dynamic>>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_shift_cards_v7',
        params: {
          'p_request_time': requestTime,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      if (response == null) return [];

      // Check for error response
      if (response is Map<String, dynamic> && response['error'] == true) {
        final errorCode = response['error_code'] ?? 'UNKNOWN';
        final errorMessage = response['error_message'] ?? 'Unknown error';
        throw AttendanceServerException('$errorCode: $errorMessage');
      }

      // v5 returns shift_date instead of request_date
      // Map shift_date to request_date for backward compatibility
      if (response is List) {
        final results = List<Map<String, dynamic>>.from(response);

        return results.map((item) {
          final converted = _processNestedData(item);

          // Map shift_date to request_date for backward compatibility
          if (converted.containsKey('shift_date')) {
            final shiftDate = converted['shift_date']?.toString() ?? '';
            if (shiftDate.contains('T')) {
              converted['request_date'] = shiftDate.split('T').first;
            } else {
              converted['request_date'] = shiftDate;
            }
          }

          return converted;
        }).toList();
      }

      return [];
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Get shift metadata for a store
  ///
  /// Uses get_shift_metadata_v2_utc RPC with timezone parameter
  /// - Returns shift times converted to user's local timezone
  Future<List<Map<String, dynamic>>> getShiftMetadata({
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

      if (response is List) {
        return response
            .map((item) => _processNestedData(item as Map<String, dynamic>))
            .toList();
      }

      // If it's a single map, wrap it in a list
      return [_processNestedData(response as Map<String, dynamic>)];
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Get monthly shift status for manager view
  ///
  /// Uses get_monthly_shift_status_manager_v4 RPC with local time + timezone
  /// - p_request_time: Local time (e.g., "2024-11-15 10:30:25") - RPC calculates month range
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul")
  /// - Returns 3 months of data starting from the month of p_request_time
  /// - Filters by start_time_utc (actual shift date) instead of request_date
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
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
        final results = List<Map<String, dynamic>>.from(response);
        return results.map((item) => _processNestedData(item)).toList();
      }

      return [];
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Get base currency for a company
  ///
  /// Uses get_base_currency RPC to fetch company's base currency settings
  /// Returns the full response including base_currency and company_currencies
  Future<Map<String, dynamic>> getBaseCurrency({
    required String companyId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_base_currency',
        params: {
          'p_company_id': companyId,
        },
      );

      if (response == null) {
        return {};
      }

      // Handle list response (RPC returns array)
      if (response is List) {
        if (response.isEmpty) return {};
        return response.first as Map<String, dynamic>;
      }

      return response as Map<String, dynamic>;
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Get user shift stats
  ///
  /// Uses user_shift_stats RPC with local time + timezone
  Future<Map<String, dynamic>> getUserShiftStats({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_shift_stats',
        params: {
          'p_request_time': requestTime,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return {};
      }

      if (response is List) {
        if (response.isEmpty) return {};
        return response.first as Map<String, dynamic>;
      }

      return response as Map<String, dynamic>;
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }
}
