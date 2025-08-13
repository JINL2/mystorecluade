import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceService {
  final SupabaseClient _supabase = Supabase.instance.client;

  /// Fetch user shift overview for the month
  Future<Map<String, dynamic>> getUserShiftOverview({
    required String requestDate,
    required String userId,
    required String companyId,
    required String storeId,
  }) async {
    try {
      print('AttendanceService.getUserShiftOverview called with:');
      print('  requestDate: $requestDate');
      print('  userId: $userId');
      print('  companyId: $companyId');
      print('  storeId: $storeId');
      
      final response = await _supabase.rpc(
        'user_shift_overview',
        params: {
          'p_request_date': requestDate,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      );

      print('AttendanceService: Raw response = $response');
      print('AttendanceService: Response type = ${response.runtimeType}');

      if (response == null) {
        print('AttendanceService: Response is null, returning empty data');
        // Return empty data structure instead of throwing
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
          print('AttendanceService: Empty list response, returning default data');
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
        print('AttendanceService: Returning first item from list');
        return response.first as Map<String, dynamic>;
      }
      
      print('AttendanceService: Returning response as is');
      return response as Map<String, dynamic>;
    } catch (e) {
      print('AttendanceService: Error - $e');
      rethrow;
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
      print('Error fetching shift requests: $e');
      rethrow;
    }
  }

  /// Check in for a shift
  Future<void> checkIn({
    required String shiftRequestId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _supabase.from('shift_requests').update({
        'actual_start_time': DateTime.now().toIso8601String(),
        'checkin_location': 'POINT($longitude $latitude)',
      }).eq('shift_request_id', shiftRequestId);
    } catch (e) {
      print('Error checking in: $e');
      rethrow;
    }
  }

  /// Check out from a shift
  Future<void> checkOut({
    required String shiftRequestId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      await _supabase.from('shift_requests').update({
        'actual_end_time': DateTime.now().toIso8601String(),
        'checkout_location': 'POINT($longitude $latitude)',
      }).eq('shift_request_id', shiftRequestId);
    } catch (e) {
      print('Error checking out: $e');
      rethrow;
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
      print('AttendanceService.getUserShiftCards called with:');
      print('  requestDate: $requestDate');
      print('  userId: $userId');
      print('  companyId: $companyId');
      print('  storeId: $storeId');
      
      final response = await _supabase.rpc(
        'user_shift_cards',
        params: {
          'p_request_date': requestDate,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      );

      print('AttendanceService: Shift cards response = $response');
      print('AttendanceService: Response type = ${response.runtimeType}');

      if (response == null) {
        print('AttendanceService: Response is null, returning empty list');
        return [];
      }

      // Return the response as a list
      if (response is List) {
        print('AttendanceService: Returning ${response.length} shift cards');
        return List<Map<String, dynamic>>.from(response);
      }
      
      print('AttendanceService: Unexpected response type, returning empty list');
      return [];
    } catch (e) {
      print('AttendanceService: Error fetching shift cards - $e');
      rethrow;
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
          .eq('request_date', '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}')
          .maybeSingle();

      return response;
    } catch (e) {
      print('Error fetching current shift: $e');
      return null;
    }
  }
  
  /// Report an issue with a shift
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
  }) async {
    try {
      print('AttendanceService.reportShiftIssue called with:');
      print('  shiftRequestId: $shiftRequestId');
      
      // Update the shift_requests table
      // Set is_reported to TRUE and is_problem_solved to FALSE
      final response = await _supabase
          .from('shift_requests')
          .update({
            'is_reported': true,
            'is_problem_solved': false,
          })
          .eq('shift_request_id', shiftRequestId);
      
      print('AttendanceService.reportShiftIssue: Update successful');
      return true;
    } catch (e) {
      print('Error reporting shift issue: $e');
      return false;
    }
  }
  
  /// Update shift request check-in/out via QR scan
  Future<Map<String, dynamic>?> updateShiftRequest({
    required String userId,
    required String storeId,
    required String requestDate,
    required String timestamp,
    required double lat,
    required double lng,
  }) async {
    try {
      print('AttendanceService.updateShiftRequest called with:');
      print('  userId: $userId');
      print('  storeId: $storeId');
      print('  requestDate: $requestDate');
      print('  timestamp: $timestamp');
      print('  lat: $lat');
      print('  lng: $lng');
      
      final response = await _supabase.rpc(
        'update_shift_requests_v3',
        params: {
          'p_user_id': userId,
          'p_store_id': storeId,
          'p_request_date': requestDate,
          'p_time': timestamp,
          'p_lat': lat,
          'p_lng': lng,
        },
      );
      
      print('AttendanceService.updateShiftRequest: Response = $response');
      
      if (response == null) {
        return null;
      }
      
      // Return the response
      if (response is List && response.isNotEmpty) {
        return response.first as Map<String, dynamic>;
      } else if (response is Map<String, dynamic>) {
        return response;
      }
      
      return null;
    } catch (e) {
      print('Error updating shift request: $e');
      return null;
    }
  }
}