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
      
      final response = await _supabase.rpc(
        'user_shift_overview',
        params: {
          'p_request_date': requestDate,
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_store_id': storeId,
        },
      );


      if (response == null) {
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
      
      final response = await _supabase.rpc(
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
      return null;
    }
  }
  
  /// Report an issue with a shift
  Future<bool> reportShiftIssue({
    required String shiftRequestId,
  }) async {
    try {
      
      // Update the shift_requests table
      // Set is_reported to TRUE and is_problem_solved to FALSE
      await _supabase
          .from('shift_requests')
          .update({
            'is_reported': true,
            'is_problem_solved': false,
          })
          .eq('shift_request_id', shiftRequestId);
      
      return true;
    } catch (e) {
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
      print('Calling update_shift_requests_v3 with params:');
      print('  p_user_id: $userId');
      print('  p_store_id: $storeId');
      print('  p_request_date: $requestDate');
      print('  p_time: $timestamp');
      print('  p_lat: $lat');
      print('  p_lng: $lng');
      
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
      
      print('RPC Response: $response');
      
      if (response == null) {
        print('Response is null');
        return null;
      }
      
      // Handle different response formats
      // The RPC should return something like: {"action": "check_in"} or {"action": "check_out"}
      if (response is List && response.isNotEmpty) {
        final result = response.first as Map<String, dynamic>;
        // Add a default action if not present
        if (!result.containsKey('action')) {
          result['action'] = 'check_in';
        }
        return result;
      } else if (response is Map<String, dynamic>) {
        // Add a default action if not present
        if (!response.containsKey('action')) {
          response['action'] = 'check_in';
        }
        return response;
      } else if (response == true || response.toString() == 'true') {
        // If RPC just returns true, create a response object
        return {'success': true, 'action': 'check_in'};
      }
      
      // Default response if format is unexpected
      return {'success': true, 'action': 'check_in'};
    } catch (e) {
      print('Error calling update_shift_requests_v3: $e');
      rethrow;
    }
  }
}