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
    String? reportReason,
  }) async {
    try {
      final now = DateTime.now().toIso8601String();
      
      // Update the shift_requests table with report details
      await _supabase
          .from('shift_requests')
          .update({
            'is_reported': true,
            'is_problem_solved': false,
            'report_time': now,
            'report_reason': reportReason ?? '',
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
      // Call the RPC function
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
      
      // If response is null, the RPC call itself failed
      if (response == null) {
        throw Exception('RPC call failed - please check database function exists');
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
      } else if (response is String) {
        // If RPC returns string message
        result = {
          'success': true,
          'action': response.toLowerCase().contains('out') ? 'check_out' : 'check_in',
          'message': response,
        };
      } else {
        // Unexpected format
        result = {
          'success': true,
          'action': 'check_in',
          'raw': response.toString(),
        };
      }
      
      // Try to determine if it was check-in or check-out from the response
      if (!result.containsKey('action') || result['action'] == null) {
        // Look for clues in other fields
        if (result['type']?.toString().toLowerCase().contains('out') == true ||
            result['status']?.toString().toLowerCase().contains('out') == true ||
            result['message']?.toString().toLowerCase().contains('out') == true) {
          result['action'] = 'check_out';
        } else {
          result['action'] = 'check_in';
        }
      }
      
      return result;
      
    } catch (e) {
      // Check if it's a specific Supabase/PostgreSQL error
      if (e.toString().contains('function') && e.toString().contains('does not exist')) {
        throw Exception('RPC function update_shift_requests_v3 does not exist in database');
      } else if (e.toString().contains('permission') || e.toString().contains('denied')) {
        throw Exception('Permission denied - please check RPC security settings');
      } else if (e.toString().contains('invalid') || e.toString().contains('malformed')) {
        throw Exception('Invalid parameters - please check data format');
      }
      
      rethrow;
    }
  }
}