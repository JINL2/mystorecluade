import 'dart:developer' as developer;

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/attendance_location.dart';
import '../../domain/exceptions/attendance_exceptions.dart';

/// Attendance Data Source
///
/// Handles all Supabase RPC calls and database queries for attendance.
class AttendanceDatasource {
  final SupabaseClient _supabase;

  AttendanceDatasource(this._supabase);

  /// Process nested data structures from database
  ///
  /// **Purpose**: Handle nested JSON structures (e.g., store_shifts)
  /// **Important**: Does NOT perform timezone conversion!
  ///
  /// Timezone conversion strategy:
  /// - Database stores: TIMESTAMPTZ in UTC
  /// - Datasource returns: UTC strings unchanged
  /// - Model layer converts: UTC → Local time (via DateTimeUtils.toLocal())
  /// - UI displays: Local time
  ///
  /// Benefits:
  /// 1. Data consistency: Always UTC in datasource
  /// 2. Single conversion point: Only in Model layer
  /// 3. No timezone info loss: UTC preserved until needed
  ///
  /// Datetime fields (UTC strings from DB):
  /// - actual_start_time, actual_end_time (QR scan timestamps)
  /// - confirm_start_time, confirm_end_time (admin confirmation times)
  /// - created_at, updated_at (record metadata)
  /// - report_time (issue report timestamp)
  ///
  /// Time-only fields (no conversion needed):
  /// - scheduled_start_time, scheduled_end_time (HH:mm:ss format)
  /// - shift_start_time, shift_end_time (HH:mm:ss format)
  Map<String, dynamic> _processNestedData(
    Map<String, dynamic> data, {
    int depth = 0,
    int maxDepth = 10,
  }) {
    // ✅ Prevent stack overflow from circular references
    if (depth >= maxDepth) {
      return data; // Return data as-is if max depth reached
    }

    final result = Map<String, dynamic>.from(data);

    // Recursively process nested structures with depth tracking
    // Note: No timezone conversion happens here - data stays as UTC strings
    if (result['store_shifts'] is Map<String, dynamic>) {
      result['store_shifts'] = _processNestedData(
        result['store_shifts'] as Map<String, dynamic>,
        depth: depth + 1,
        maxDepth: maxDepth,
      );
    }

    return result;
  }

  /// Update shift request (check-in or check-out) via QR scan
  ///
  /// Uses update_shift_requests_v8 RPC with shift_request_id
  /// - p_shift_request_id: Target shift request UUID (required)
  /// - p_time: Local timestamp without timezone offset (e.g., "2024-11-15 10:30:25")
  /// - p_timezone: User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  ///
  /// v8 Changes:
  /// - Full backward chain detection (doesn't stop at unchecked shifts)
  /// - Finds first checked-in shift in chain
  /// - Processes from checked-in shift to requested shift
  ///
  /// RPC returns: {'status': 'attend'|'check_out'|'error', 'message': '...'}
  /// Maps to: {'action': 'check_in'|'check_out', 'timestamp': '...', ...}
  Future<Map<String, dynamic>?> updateShiftRequest({
    required String shiftRequestId,
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'update_shift_requests_v8',
        params: {
          'p_shift_request_id': shiftRequestId,
          'p_user_id': userId,
          'p_store_id': storeId,
          'p_time': timestamp,
          'p_lat': location.latitude,
          'p_lng': location.longitude,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        throw const AttendanceServerException(
            'RPC call failed - please check database function exists',
        );
      }

      // Parse response
      Map<String, dynamic> rawResult = {};

      if (response is List) {
        if (response.isEmpty) {
          throw const AttendanceServerException('RPC returned empty response');
        }
        final firstItem = response.first;
        if (firstItem is Map<String, dynamic>) {
          rawResult = firstItem;
        } else {
          throw const AttendanceServerException('Invalid RPC response format');
        }
      } else if (response is Map<String, dynamic>) {
        rawResult = response;
      } else {
        throw const AttendanceServerException('Invalid RPC response format');
      }

      // Check for error response from v7 RPC
      final status = rawResult['status'] as String?;

      if (status == 'error') {
        final message = rawResult['message'] as String? ?? 'Unknown error';
        throw AttendanceServerException(message);
      }

      // Map RPC response fields to expected model fields
      // v7 RPC returns: {'status': 'attend'|'check_out', 'message': '...', 'chain_length': ...}
      // - 'attend' = check-in (출근)
      // - 'check_out' = check-out (퇴근)
      final mappedResult = <String, dynamic>{
        'action': status == 'attend' ? 'check_in' : status,
        'timestamp': timestamp,
        'success': true,
        'message': rawResult['message'],
        'shift_request_id': shiftRequestId,
        'request_date': _extractDateFromTimestamp(timestamp),
      };

      // Include chain_length if present (for continuous shift checkout)
      if (rawResult.containsKey('chain_length')) {
        mappedResult['chain_length'] = rawResult['chain_length'];
      }

      return mappedResult;
    } catch (e) {
      print('❌ [CHECK_IN_OUT] EXCEPTION: $e');
      throw AttendanceServerException(e.toString());
    }
  }

  /// Extract date from timestamp string
  /// Input: "2024-11-15T10:30:25+09:00"
  /// Output: "2024-11-15"
  String _extractDateFromTimestamp(String timestamp) {
    try {
      // Parse the timestamp and extract date only
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      // If parsing fails, try to extract manually
      if (timestamp.contains('T')) {
        return timestamp.split('T').first;
      }
      return timestamp;
    }
  }

  /// Fetch user shift cards for the month
  ///
  /// Uses user_shift_cards_v7 RPC with local time + timezone
  /// - p_request_time: Local timestamp (e.g., "2025-12-15 10:00:00") - no timezone offset
  /// - p_timezone: User's local timezone (e.g., "Asia/Ho_Chi_Minh")
  /// - Returns shift cards filtered by start_time_utc (actual shift date)
  ///
  /// v5 변경사항:
  /// - 개별 문제 컬럼 제거 (is_late, late_minutes, is_extratime 등)
  /// - problem_details JSONB 추가 (모든 문제 정보 통합)
  /// v6: storeId optional - null이면 회사 전체 조회
  /// v7: manager_memo 추가 - 매니저가 남긴 메모 표시
  Future<List<Map<String, dynamic>>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    String? storeId,  // Optional: null이면 회사 전체
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_shift_cards_v7',
        params: {
          'p_request_time': requestTime,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,  // null이면 RPC에서 회사 전체 조회
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
      // Map shift_date to request_date for backward compatibility with existing code
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


  /// Report an issue with a shift
  ///
  /// Uses report_shift_request RPC with timezone-aware time handling
  /// - p_shift_request_id: The shift request ID to report
  /// - p_report_reason: The reason for reporting
  /// - p_time: Local time string (e.g., "2024-11-15 10:30:25")
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul")
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    required String reportReason,
    required String time,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'report_shift_request',
        params: {
          'p_shift_request_id': shiftRequestId,
          'p_report_reason': reportReason,
          'p_time': time,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return false;
      }

      final Map<String, dynamic> result = response is Map<String, dynamic>
          ? response
          : Map<String, dynamic>.from(response as Map);

      return result['success'] == true;
    } catch (e) {
      return false;
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
  /// - p_request_time: Local time (e.g., "2024-11-15 10:30:25") - RPC calculates month range from this
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

  /// Insert shift request
  ///
  /// Uses insert_shift_request_v6 RPC with local time + timezone
  /// - p_start_time: Shift start time as local timestamp (e.g., "2025-12-06 09:00:00")
  /// - p_end_time: Shift end time as local timestamp (e.g., "2025-12-06 18:00:00")
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// NOTE: All timestamps must be WITHOUT timezone offset
  Future<Map<String, dynamic>?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'insert_shift_request_v6',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_store_id': storeId,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return null;
      }

      Map<String, dynamic> result;

      if (response is List) {
        if (response.isEmpty) return null;
        result = response.first as Map<String, dynamic>;
      } else {
        result = response as Map<String, dynamic>;
      }

      // Check if response contains success/data structure from RPC
      if (result.containsKey('success')) {
        final success = result['success'] as bool?;

        // If not successful, throw exception with error message
        if (success == false) {
          final message = result['message'] as String? ?? 'Unknown error';
          final errorCode = result['error_code'] as String? ?? 'UNKNOWN';
          throw AttendanceServerException('$errorCode: $message');
        }

        // Extract the actual data if present
        if (result.containsKey('data') && result['data'] != null) {
          final data = result['data'] as Map<String, dynamic>;
          return _processNestedData(data);
        }

        // If no data field but successful, return null
        return null;
      }

      // If response doesn't have success field, treat it as direct data
      return _processNestedData(result);
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

  /// Delete shift request
  ///
  /// Uses delete_shift_request_v3 RPC function
  /// - p_start_time: Shift start time as local timestamp (e.g., "2025-12-06 09:00:00")
  /// - p_end_time: Shift end time as local timestamp (e.g., "2025-12-06 18:00:00")
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
  /// NOTE: All timestamps must be WITHOUT timezone offset
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String startTime,
    required String endTime,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'delete_shift_request_v3',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_start_time': startTime,
          'p_end_time': endTime,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        throw const AttendanceServerException('RPC call failed - no response');
      }

      // Parse response
      Map<String, dynamic> result;
      if (response is List) {
        if (response.isEmpty) {
          throw const AttendanceServerException('RPC returned empty response');
        }
        result = response.first as Map<String, dynamic>;
      } else {
        result = response as Map<String, dynamic>;
      }

      // Check if deletion was successful
      final success = result['success'] as bool?;
      if (success == false) {
        final message = result['message'] as String? ?? 'Unknown error';
        final errorCode = result['error_code'] as String? ?? 'UNKNOWN';
        throw AttendanceServerException('$errorCode: $message');
      }
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }
}
