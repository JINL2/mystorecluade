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

  /// Fetch user shift overview for the month
  ///
  /// Uses user_shift_overview_v3 RPC with local time + timezone offset
  Future<Map<String, dynamic>> getUserShiftOverview({
    required String requestTime, // ISO 8601 with offset (e.g., "2024-11-15T10:30:25+07:00")
    required String userId,
    required String companyId,
    required String storeId,
    required String timezone, // User's local timezone (e.g., "Asia/Seoul")
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_shift_overview_v3', // Changed from v2 to v3
        params: {
          'p_request_time': requestTime,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_timezone': timezone, // New: user's local timezone
        },
      );

      if (response == null) {
        // Return empty data structure
        return {
          'request_month': requestTime.substring(0, 7), // yyyy-MM from yyyy-MM-dd HH:mm:ss
          'actual_work_days': 0,
          'actual_work_hours': 0.0,
          'estimated_salary': '0',
          'currency_symbol': '₩',
          'salary_amount': 0.0,
          'salary_type': 'hourly',
          'late_deduction_total': 0,
          'overtime_total': 0,
          'salary_stores': <Map<String, dynamic>>[],
        };
      }

      // Return the first item if it's a list, otherwise return as is
      if (response is List) {
        if (response.isEmpty) {
          return {
            'request_month': requestTime.substring(0, 7),
            'actual_work_days': 0,
            'actual_work_hours': 0.0,
            'estimated_salary': '0',
            'currency_symbol': '₩',
            'salary_amount': 0.0,
            'salary_type': 'hourly',
            'late_deduction_total': 0,
            'overtime_total': 0,
            'salary_stores': <Map<String, dynamic>>[],
          };
        }
        final firstItem = response.first as Map<String, dynamic>;
        return _processNestedData(firstItem);
      }

      final result = response as Map<String, dynamic>;
      return _processNestedData(result);
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }


  /// Update shift request (check-in or check-out) via QR scan
  ///
  /// Uses update_shift_requests_v6 RPC with local time + timezone offset
  /// - p_request_date parameter removed (date extracted from p_time in RPC)
  /// - p_time must be local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+07:00")
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
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
      Map<String, dynamic> result = {};

      if (response is List) {
        if (response.isEmpty) {
          result = {'success': true, 'action': 'check_in'};
        } else {
          // Take first item from list
          final firstItem = response.first;
          if (firstItem is Map<String, dynamic>) {
            result = firstItem;
          } else {
            result = {'success': true, 'action': 'check_in', 'data': firstItem};
          }
        }
      } else if (response is Map<String, dynamic>) {
        result = response;
      } else if (response is bool) {
        // If RPC returns boolean, create appropriate response
        result = {
          'success': response,
          'action': 'check_in',
        };
      } else {
        result = {'success': true, 'action': 'check_in', 'data': response};
      }

      return result;
    } catch (e) {
      throw AttendanceServerException(e.toString());
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
  /// Updates shift_requests table with report details using new v2 columns
  /// - is_reported_v2: boolean flag for reported status
  /// - is_problem_solved_v2: boolean flag for problem resolution status
  /// - report_time_utc: TIMESTAMPTZ with local time + timezone offset
  /// - report_reason_v2: text field for report reason
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    String? reportReason,
  }) async {
    try {
      // Get current time with timezone offset for TIMESTAMPTZ column
      final now = DateTime.now();
      final reportTimeWithOffset = DateTimeUtils.toLocalWithOffset(now);

      // Update the shift_requests table with report details (v2 columns)
      await _supabase.from('shift_requests').update({
        'is_reported_v2': true,
        'is_problem_solved_v2': false,
        'report_time_utc': reportTimeWithOffset, // TIMESTAMPTZ with offset
        'report_reason_v2': reportReason ?? '',
      }).eq('shift_request_id', shiftRequestId);

      return true;
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
  /// Uses get_monthly_shift_status_manager_v2 RPC with local time + timezone offset
  /// - p_request_time must be local timestamp with timezone offset (e.g., "2024-11-15T10:30:25+07:00")
  /// - p_timezone must be user's local timezone (e.g., "Asia/Seoul")
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestTime,
    required String timezone,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_monthly_shift_status_manager_v2',
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
  /// Uses insert_shift_request_v3 RPC with local time + timezone offset
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
        'insert_shift_request_v3',
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

  /// Delete shift request
  ///
  /// Uses delete_shift_request RPC function
  /// Converts request_time to local date using timezone for filtering
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
    required String timezone,
  }) async {
    try {
      // Call RPC function
      // Note: RPC expects request_time (TIMESTAMPTZ format with timezone offset)
      // Convert requestDate string to DateTime, then to ISO 8601 with offset
      // Example: "2025-11-26" → DateTime(2025, 11, 26) → "2025-11-26T00:00:00+00:00"
      final dateParts = requestDate.split('-');
      final requestDateTime = DateTime(
        int.parse(dateParts[0]), // year
        int.parse(dateParts[1]), // month
        int.parse(dateParts[2]), // day
      );
      final requestTime = DateTimeUtils.toLocalWithOffset(requestDateTime);

      final response = await _supabase.rpc<dynamic>(
        'delete_shift_request',
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
