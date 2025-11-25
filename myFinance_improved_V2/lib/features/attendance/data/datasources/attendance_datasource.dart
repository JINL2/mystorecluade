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

  /// Process data from database - keeps UTC strings as-is
  ///
  /// **중요:** UTC 문자열을 그대로 유지합니다!
  /// 변환은 Model 레이어에서 수행됩니다:
  /// - ShiftRequestModel.fromJson()에서 DateTimeUtils.toLocal() 사용
  /// - attendance_content.dart의 _formatTime()에서 DateTimeUtils.toLocal() 사용
  ///
  /// 이렇게 하면:
  /// 1. 데이터 일관성 유지 (항상 UTC 문자열로 저장)
  /// 2. 중복 변환 방지
  /// 3. 타임존 정보 손실 방지
  ///
  /// Datetime 필드:
  /// - actual_start_time, actual_end_time (실제 QR 스캔 시간)
  /// - confirm_start_time, confirm_end_time (관리자 확정 시간)
  /// - created_at, updated_at (레코드 생성/수정 시각)
  /// - report_time (문제 신고 시각)
  ///
  /// Time-only 필드 (변환 불필요):
  /// - scheduled_start_time, scheduled_end_time (HH:mm:ss)
  /// - shift_start_time, shift_end_time (HH:mm:ss)
  Map<String, dynamic> _convertToLocalTime(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);

    // Keep UTC strings as-is
    // Conversion will be done in Model layer (ShiftRequestModel.fromJson)
    // This prevents double conversion and maintains data consistency

    // If there's nested store_shifts data, process it too
    if (result['store_shifts'] is Map<String, dynamic>) {
      result['store_shifts'] = _convertToLocalTime(result['store_shifts'] as Map<String, dynamic>);
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
        return _convertToLocalTime(firstItem);
      }

      final result = response as Map<String, dynamic>;
      return _convertToLocalTime(result);
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

      // Convert UTC times to local time and return as list
      if (response is List) {
        final results = List<Map<String, dynamic>>.from(response);
        return results.map((item) {
          final converted = _convertToLocalTime(item);

          // Convert request_time (UTC) to request_date (local date only)
          if (converted.containsKey('request_time')) {
            try {
              final utcString = converted['request_time']?.toString() ?? '';
              if (utcString.isNotEmpty) {
                final localDateTime = DateTimeUtils.toLocal(utcString);
                converted['request_date'] = DateTimeUtils.toDateOnly(localDateTime);
              }
            } catch (e) {
              // If conversion fails, use request_time as-is
              converted['request_date'] = converted['request_time'];
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
            .map((item) => _convertToLocalTime(item as Map<String, dynamic>))
            .toList();
      }

      // If it's a single map, wrap it in a list
      return [_convertToLocalTime(response as Map<String, dynamic>)];
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
        return results.map((item) => _convertToLocalTime(item)).toList();
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
          return _convertToLocalTime(data);
        }

        // If no data field but successful, return null
        return null;
      }

      // If response doesn't have success field, treat it as direct data
      return _convertToLocalTime(result);
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Delete shift request
  ///
  /// Filters by request_time (TIMESTAMPTZ) converted to local date
  /// - Converts request_time to user's timezone
  /// - Extracts date portion (yyyy-MM-dd)
  /// - Matches against requestDate parameter
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
    required String timezone,
  }) async {
    try {
      // Use RPC to handle timezone conversion and date filtering
      // PostgreSQL: DATE(request_time AT TIME ZONE timezone) = requestDate
      await _supabase.rpc<void>(
        'delete_shift_request_by_date',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_request_date': requestDate,
          'p_timezone': timezone,
        },
      );
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }
}
