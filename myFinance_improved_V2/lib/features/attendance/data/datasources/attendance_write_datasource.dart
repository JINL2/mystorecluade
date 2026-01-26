import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../../domain/entities/attendance_location.dart';
import '../../domain/exceptions/attendance_exceptions.dart';

/// Attendance Write Data Source
///
/// Handles all WRITE operations for attendance data:
/// - updateShiftRequest: Process check-in or check-out via QR scan
/// - reportShiftIssue: Report an issue with a shift
/// - insertShiftRequest: Insert a new shift request
/// - deleteShiftRequest: Delete an existing shift request
class AttendanceWriteDatasource {
  final SupabaseClient _supabase;

  AttendanceWriteDatasource(this._supabase);

  /// Process nested data structures from database
  ///
  /// **Purpose**: Handle nested JSON structures (e.g., store_shifts)
  /// **Important**: Does NOT perform timezone conversion!
  Map<String, dynamic> _processNestedData(
    Map<String, dynamic> data, {
    int depth = 0,
    int maxDepth = 10,
  }) {
    if (depth >= maxDepth) {
      return data;
    }

    final result = Map<String, dynamic>.from(data);

    if (result['store_shifts'] is Map<String, dynamic>) {
      result['store_shifts'] = _processNestedData(
        result['store_shifts'] as Map<String, dynamic>,
        depth: depth + 1,
        maxDepth: maxDepth,
      );
    }

    return result;
  }

  /// Extract date from timestamp string
  /// Input: "2024-11-15T10:30:25+09:00"
  /// Output: "2024-11-15"
  String _extractDateFromTimestamp(String timestamp) {
    try {
      final dateTime = DateTime.parse(timestamp);
      return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
    } catch (e) {
      if (timestamp.contains('T')) {
        return timestamp.split('T').first;
      }
      return timestamp;
    }
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
      print('... [CHECK_IN_OUT] EXCEPTION: $e');
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

      // Log response for debugging
      SentryConfig.addBreadcrumb(
        message: 'reportShiftIssue RPC response',
        category: 'attendance',
        data: {
          'shiftRequestId': shiftRequestId,
          'responseType': response.runtimeType.toString(),
          'response': response?.toString() ?? 'null',
        },
      );

      if (response == null) {
        SentryConfig.captureMessage(
          'reportShiftIssue: RPC returned null',
          extra: {'shiftRequestId': shiftRequestId},
        );
        return false;
      }

      // Handle different response types robustly
      // Case 1: response is already a bool
      if (response is bool) {
        return response;
      }

      // Case 2: response is a Map
      if (response is Map<String, dynamic>) {
        return response['success'] == true;
      }

      // Case 3: response is a Map but not Map<String, dynamic>
      if (response is Map) {
        try {
          final Map<String, dynamic> result =
              Map<String, dynamic>.from(response);
          return result['success'] == true;
        } catch (e) {
          SentryConfig.captureException(
            e,
            StackTrace.current,
            hint: 'reportShiftIssue: Failed to convert Map response',
            extra: {
              'shiftRequestId': shiftRequestId,
              'responseType': response.runtimeType.toString(),
              'response': response.toString(),
            },
          );
          return false;
        }
      }

      // Case 4: response is a List (unexpected but handle gracefully)
      if (response is List && response.isNotEmpty) {
        final firstItem = response.first;
        if (firstItem is bool) return firstItem;
        if (firstItem is Map<String, dynamic>) {
          return firstItem['success'] == true;
        }
        if (firstItem is Map) {
          try {
            final Map<String, dynamic> result =
                Map<String, dynamic>.from(firstItem);
            return result['success'] == true;
          } catch (e) {
            // Fall through to error logging
          }
        }
      }

      // Unexpected response type - log and return false
      SentryConfig.captureMessage(
        'reportShiftIssue: Unexpected response type',
        extra: {
          'shiftRequestId': shiftRequestId,
          'responseType': response.runtimeType.toString(),
          'response': response.toString(),
        },
      );
      return false;
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'reportShiftIssue failed',
        extra: {
          'shiftRequestId': shiftRequestId,
          'reportReason': reportReason,
        },
      );
      return false;
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
