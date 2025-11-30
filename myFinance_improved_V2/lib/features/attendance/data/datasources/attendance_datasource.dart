import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/utils/datetime_utils.dart';
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
  /// Uses update_shift_requests_v6 RPC with local time + timezone offset
  /// - p_request_date parameter removed (date extracted from p_time in RPC)
  /// - p_time must be local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+07:00")
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  ///
  /// RPC returns: {'status': 'check_in'|'check_out'|'attend', 'time': '...'}
  /// Maps to: {'action': 'check_in'|'check_out', 'timestamp': '...', ...}
  Future<Map<String, dynamic>?> updateShiftRequest({
    required String userId,
    required String storeId,
    required String timestamp,
    required AttendanceLocation location,
    required String timezone,
  }) async {
    try {
      // Call the RPC function
      final response = await _supabase.rpc<dynamic>(
        'update_shift_requests_v6',
        params: {
          'p_user_id': userId,
          'p_store_id': storeId,
          'p_time': timestamp,
          'p_lat': location.latitude,
          'p_lng': location.longitude,
          'p_timezone': timezone,
        },
      );

      // If response is null, the RPC call itself failed
      if (response == null) {
        throw const AttendanceServerException(
            'RPC call failed - please check database function exists',
        );
      }

      // Parse different possible response formats
      Map<String, dynamic> rawResult = {};

      if (response is List) {
        if (response.isEmpty) {
          rawResult = {'status': 'check_in', 'time': timestamp};
        } else {
          // Take first item from list
          final firstItem = response.first;
          if (firstItem is Map<String, dynamic>) {
            rawResult = firstItem;
          } else {
            rawResult = {'status': 'check_in', 'time': timestamp};
          }
        }
      } else if (response is Map<String, dynamic>) {
        rawResult = response;
      } else if (response is bool) {
        // If RPC returns boolean, create appropriate response
        rawResult = {
          'status': 'check_in',
          'time': timestamp,
        };
      } else {
        rawResult = {'status': 'check_in', 'time': timestamp};
      }

      // Map RPC response fields to expected model fields
      // RPC returns: {'status': 'attend'|'check_out', 'time': '...'}
      // - 'attend' = check-in (출근)
      // - 'check_out' = check-out (퇴근)
      // Model expects: {'action': 'check_in'|'check_out', 'timestamp': '...', 'request_date': '...', ...}
      final status = rawResult['status'] ?? 'attend';
      final mappedResult = <String, dynamic>{
        // Map 'attend' to 'check_in' for consistency
        'action': status == 'attend' ? 'check_in' : status,
        'timestamp': rawResult['time'] ?? timestamp,
        'success': true,
        // Extract date from timestamp for request_date field
        'request_date': _extractDateFromTimestamp((rawResult['time'] ?? timestamp) as String),
      };

      // ✅ Debug: Log RPC response mapping
      assert(() {
        debugPrint('🔵 [updateShiftRequest] RPC response: $rawResult');
        debugPrint('🔄 [updateShiftRequest] Mapped result: $mappedResult');
        return true;
      }());

      return mappedResult;
    } catch (e) {
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
  /// Uses user_shift_cards_v3 RPC with local time + timezone offset
  /// - p_request_time must be local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+07:00")
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  Future<List<Map<String, dynamic>>> getUserShiftCards({
    required String requestTime,
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone,
  }) async {
    try {
      // ✅ Debug: Log RPC parameters
      assert(() {
        debugPrint('🔵 [getUserShiftCards] RPC params:');
        debugPrint('  - requestTime: $requestTime');
        debugPrint('  - userId: $userId');
        debugPrint('  - companyId: $companyId');
        debugPrint('  - storeId: $storeId');
        debugPrint('  - timezone: $timezone');
        return true;
      }());

      final response = await _supabase.rpc<dynamic>(
        'user_shift_cards_v3',
        params: {
          'p_request_time': requestTime,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_timezone': timezone,
        },
      );

      if (response == null) {
        return [];
      }

      // ✅ Debug: Log raw response
      assert(() {
        final count = response is List ? response.length : 'not a list';
        debugPrint('🟢 [getUserShiftCards] Raw response count: $count');
        return true;
      }());

      // Convert UTC times to local time and return as list
      if (response is List) {
        final results = List<Map<String, dynamic>>.from(response);
        return results.map((item) {
          final converted = _processNestedData(item);

          // Convert request_time (UTC) to request_date (local date only)
          if (converted.containsKey('request_time')) {
            try {
              final utcString = converted['request_time']?.toString() ?? '';
              if (utcString.isNotEmpty) {
                final localDateTime = DateTimeUtils.toLocal(utcString);
                converted['request_date'] = DateTimeUtils.toDateOnly(localDateTime);
                // ✅ Debug: Log conversion
                assert(() {
                  debugPrint('🔄 [getUserShiftCards] Converted: $utcString → ${converted['request_date']}');
                  return true;
                }());
              }
            } catch (e) {
              // If conversion fails, use request_time as-is
              converted['request_date'] = converted['request_time'];
              assert(() {
                debugPrint('⚠️ [getUserShiftCards] Conversion failed: $e');
                return true;
              }());
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
  /// Uses get_shift_metadata_v2 RPC with timezone parameter
  /// - Returns shift times converted to user's local timezone
  Future<List<Map<String, dynamic>>> getShiftMetadata({
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
  /// Uses get_monthly_shift_status_manager_v3 RPC with local time + timezone
  /// - p_request_time: Local time (e.g., "2024-11-15 10:30:25") - RPC calculates month range from this
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul")
  /// - Returns 3 months of data starting from the month of p_request_time
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) async {
    try {
      // Debug: Log RPC parameters
      assert(() {
        debugPrint('🔵 [getMonthlyShiftStatusManager] RPC params:');
        debugPrint('  - storeId: $storeId');
        debugPrint('  - requestTime: $requestTime');
        debugPrint('  - timezone: $timezone');
        return true;
      }());

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
  /// Uses insert_shift_request_v4 RPC with local time + timezone
  /// - p_request_time must be local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+07:00")
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  Future<Map<String, dynamic>?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestTime,
    required String timezone,
  }) async {
    try {
      // ✅ Clean code: Debug logs wrapped in assert for development only
      assert(() {
        debugPrint('🔵 [insertShiftRequest] Calling RPC with params:');
        debugPrint('  - userId: $userId');
        debugPrint('  - shiftId: $shiftId');
        debugPrint('  - storeId: $storeId');
        debugPrint('  - requestTime: $requestTime');
        debugPrint('  - timezone: $timezone');
        return true;
      }());

      final response = await _supabase.rpc<dynamic>(
        'insert_shift_request_v4',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_store_id': storeId,
          'p_request_time': requestTime,
          'p_timezone': timezone,
        },
      );

      // ✅ Clean code: Debug logs wrapped in assert for development only
      assert(() {
        debugPrint('🟢 [insertShiftRequest] Raw RPC response: $response');
        return true;
      }());

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
  /// Uses delete_shift_request_v2 RPC function
  /// - p_request_time: Local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+09:00")
  /// - p_timezone: User's local timezone (e.g., "Asia/Seoul")
  /// - RPC extracts UTC date from request_time for matching
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestTime,
    required String timezone,
  }) async {
    try {
      // Debug: Log RPC parameters
      assert(() {
        debugPrint('🔵 [deleteShiftRequest] RPC params:');
        debugPrint('  - userId: $userId');
        debugPrint('  - shiftId: $shiftId');
        debugPrint('  - requestTime: $requestTime');
        debugPrint('  - timezone: $timezone');
        return true;
      }());

      final response = await _supabase.rpc<dynamic>(
        'delete_shift_request_v2',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_request_time': requestTime,
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
