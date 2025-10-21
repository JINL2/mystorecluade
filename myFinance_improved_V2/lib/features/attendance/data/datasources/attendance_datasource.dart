import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/attendance_location.dart';
import '../../domain/exceptions/attendance_exceptions.dart';

/// Attendance Data Source
///
/// Handles all Supabase RPC calls and database queries for attendance.
class AttendanceDatasource {
  final SupabaseClient _supabase;

  AttendanceDatasource(this._supabase);

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
        return response.first as Map<String, dynamic>;
      }

      return response as Map<String, dynamic>;
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
          .gte('request_date', startDate.toIso8601String())
          .lte('request_date', endDate.toIso8601String())
          .order('request_date', ascending: true);

      return List<Map<String, dynamic>>.from(response);
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
        'actual_start_time': DateTime.now().toIso8601String(),
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
        'actual_end_time': DateTime.now().toIso8601String(),
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

      // Return the response as a list
      if (response is List) {
        return List<Map<String, dynamic>>.from(response);
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
          .eq(
            'request_date',
            '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}',
          )
          .maybeSingle();

      return response;
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
      final now = DateTime.now().toIso8601String();

      // Update the shift_requests table with report details
      await _supabase.from('shift_requests').update({
        'is_reported': true,
        'is_problem_solved': false,
        'report_time': now,
        'report_reason': reportReason ?? '',
      }).eq('shift_request_id', shiftRequestId);

      return true;
    } catch (e) {
      return false;
    }
  }
}
