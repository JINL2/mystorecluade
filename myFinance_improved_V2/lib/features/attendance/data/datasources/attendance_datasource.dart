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

  /// Convert UTC datetime fields to local time in a Map
  ///
  /// Only converts fields that represent actual events (timestamps):
  /// - actual_start_time, actual_end_time (실제 근무 시간)
  /// - confirm_start_time, confirm_end_time (관리자 확정 시간)
  /// - created_at, updated_at (레코드 생성/수정 시각)
  /// - report_time (문제 신고 시각)
  ///
  /// Does NOT convert schedule times (these are time-of-day only):
  /// - scheduled_start_time, scheduled_end_time (예정된 근무 시간 - HH:mm:ss)
  /// - shift_start_time, shift_end_time (시프트 시간 - HH:mm:ss)
  /// - plan_start_time, plan_end_time (계획된 시간 - HH:mm:ss)
  Map<String, dynamic> _convertToLocalTime(Map<String, dynamic> data) {
    final result = Map<String, dynamic>.from(data);

    // List of datetime fields to convert (actual events only)
    const timeFields = [
      'actual_start_time',      // 실제 출근 시각 (QR 스캔)
      'actual_end_time',        // 실제 퇴근 시각 (QR 스캔)
      'confirm_start_time',     // 관리자 확정 출근 시각
      'confirm_end_time',       // 관리자 확정 퇴근 시각
      'created_at',             // 레코드 생성 시각
      'updated_at',             // 레코드 수정 시각
      'report_time',            // 문제 신고 시각
    ];

    for (final field in timeFields) {
      if (result[field] != null && result[field] is String) {
        final localTime = DateTimeUtils.toLocalSafe(result[field] as String);
        if (localTime != null) {
          result[field] = localTime.toIso8601String();
        }
      }
    }

    // If there's nested store_shifts data, convert it too
    if (result['store_shifts'] is Map<String, dynamic>) {
      result['store_shifts'] = _convertToLocalTime(result['store_shifts'] as Map<String, dynamic>);
    }

    return result;
  }

  /// Fetch user shift overview for the month
  Future<Map<String, dynamic>> getUserShiftOverview({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_shift_overview',
        params: {
          'p_request_date': requestDate,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      );

      if (response == null) {
        // Return empty data structure
        return {
          'request_month': requestDate.substring(0, 7), // yyyy-MM from yyyy-MM-dd
          'actual_work_days': 0,
          'actual_work_hours': 0.0,
          'estimated_salary': '0',
          'currency_symbol': '₩',
          'salary_amount': 0.0,
          'salary_type': 'hourly',
          'late_deduction_total': 0,
          'overtime_total': 0,
        };
      }

      // Return the first item if it's a list, otherwise return as is
      if (response is List) {
        if (response.isEmpty) {
          return {
            'request_month': requestDate.substring(0, 7),
            'actual_work_days': 0,
            'actual_work_hours': 0.0,
            'estimated_salary': '0',
            'currency_symbol': '₩',
            'salary_amount': 0.0,
            'salary_type': 'hourly',
            'late_deduction_total': 0,
            'overtime_total': 0,
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

  /// Fetch shift requests for a specific date range
  Future<List<Map<String, dynamic>>> getShiftRequests({
    required String userId,
    required String storeId,
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    try {
      final response = await _supabase
          .from('shift_requests')
          .select('*, store_shifts(*)')
          .eq('user_id', userId)
          .eq('store_id', storeId)
          .gte('request_date', DateTimeUtils.toDateOnly(startDate))
          .lte('request_date', DateTimeUtils.toDateOnly(endDate))
          .order('request_date', ascending: true);

      // Convert UTC times to local time
      final results = List<Map<String, dynamic>>.from(response);
      return results.map((item) => _convertToLocalTime(item)).toList();
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Update shift request (check-in or check-out) via QR scan
  Future<Map<String, dynamic>?> updateShiftRequest({
    required String userId,
    required String storeId,
    required String requestDate,
    required String timestamp,
    required AttendanceLocation location,
  }) async {
    try {
      // Call the RPC function
      final response = await _supabase.rpc<dynamic>(
        'update_shift_requests_v4',
        params: {
          'p_user_id': userId,
          'p_store_id': storeId,
          'p_request_date': requestDate,
          'p_time': timestamp,
          'p_lat': location.latitude,
          'p_lng': location.longitude,
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

  /// Check in for a shift
  Future<void> checkIn({
    required String shiftRequestId,
    required AttendanceLocation location,
  }) async {
    try {
      await _supabase.from('shift_requests').update({
        'actual_start_time': DateTimeUtils.toUtc(DateTime.now()),
        'checkin_location': location.toPostGISPoint(),
      }).eq('shift_request_id', shiftRequestId);
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Check out from a shift
  Future<void> checkOut({
    required String shiftRequestId,
    required AttendanceLocation location,
  }) async {
    try {
      await _supabase.from('shift_requests').update({
        'actual_end_time': DateTimeUtils.toUtc(DateTime.now()),
        'checkout_location': location.toPostGISPoint(),
      }).eq('shift_request_id', shiftRequestId);
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Fetch user shift cards for the month
  Future<List<Map<String, dynamic>>> getUserShiftCards({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'user_shift_cards',
        params: {
          'p_request_date': requestDate,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      );

      if (response == null) {
        return [];
      }

      // Convert UTC times to local time and return as list
      if (response is List) {
        final results = List<Map<String, dynamic>>.from(response);
        return results.map((item) => _convertToLocalTime(item)).toList();
      }

      return [];
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Get current active shift for user
  Future<Map<String, dynamic>?> getCurrentShift({
    required String userId,
    required String storeId,
  }) async {
    try {
      final today = DateTime.now();
      final response = await _supabase
          .from('shift_requests')
          .select('*, store_shifts(*)')
          .eq('user_id', userId)
          .eq('store_id', storeId)
          .eq('request_date', DateTimeUtils.toDateOnly(today))
          .maybeSingle();

      // Convert UTC times to local time
      if (response != null) {
        return _convertToLocalTime(response);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Report an issue with a shift
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
    String? reportReason,
  }) async {
    try {
      // Update the shift_requests table with report details
      await _supabase.from('shift_requests').update({
        'is_reported': true,
        'is_problem_solved': false,
        'report_time': DateTimeUtils.toUtc(DateTime.now()),
        'report_reason': reportReason ?? '',
      }).eq('shift_request_id', shiftRequestId);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get shift metadata for a store
  Future<List<Map<String, dynamic>>> getShiftMetadata({
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_shift_metadata',
        params: {
          'p_store_id': storeId,
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
  Future<List<Map<String, dynamic>>> getMonthlyShiftStatusManager({
    required String storeId,
    required String companyId,
    required String requestDate,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'get_monthly_shift_status_manager',
        params: {
          'p_store_id': storeId,
          'p_company_id': companyId,
          'p_request_date': requestDate,
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
  Future<Map<String, dynamic>?> insertShiftRequest({
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'insert_shift_request_v2',
        params: {
          'p_user_id': userId,
          'p_shift_id': shiftId,
          'p_store_id': storeId,
          'p_request_date': requestDate,
        },
      );

      if (response == null) {
        return null;
      }

      if (response is List) {
        if (response.isEmpty) return null;
        final firstItem = response.first as Map<String, dynamic>;
        return _convertToLocalTime(firstItem);
      }

      return _convertToLocalTime(response as Map<String, dynamic>);
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }

  /// Delete shift request
  Future<void> deleteShiftRequest({
    required String userId,
    required String shiftId,
    required String requestDate,
  }) async {
    try {
      await _supabase
          .from('shift_requests')
          .delete()
          .eq('user_id', userId)
          .eq('shift_id', shiftId)
          .eq('request_date', requestDate);
    } catch (e) {
      throw AttendanceServerException(e.toString());
    }
  }
}
