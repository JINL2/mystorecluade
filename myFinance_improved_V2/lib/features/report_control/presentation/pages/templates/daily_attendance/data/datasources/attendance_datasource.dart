// lib/features/report_control/presentation/pages/templates/daily_attendance/data/datasources/attendance_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';

/// Attendance Remote Datasource
///
/// Handles RPC calls to Supabase
class AttendanceDataSource {
  final SupabaseClient _supabase;

  AttendanceDataSource(this._supabase);

  /// Call get_daily_attendance_report RPC
  Future<Map<String, dynamic>> getDailyAttendanceReport({
    required String companyId,
    String? storeId,
    required DateTime targetDate,
  }) async {
    try {
      print('📞 [AttendanceDataSource] Calling RPC: get_daily_attendance_report');
      print('   - company_id: $companyId');
      print('   - store_id: $storeId');
      print('   - target_date: ${DateFormat('yyyy-MM-dd').format(targetDate)}');

      final response = await _supabase.rpc(
        'get_daily_attendance_report',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_target_date': DateFormat('yyyy-MM-dd').format(targetDate),
        },
      );

      print('✅ [AttendanceDataSource] RPC success');

      if (response == null) {
        throw Exception('No data returned from RPC');
      }

      return response as Map<String, dynamic>;
    } catch (e, stackTrace) {
      print('❌ [AttendanceDataSource] RPC failed: $e');
      print('📚 [AttendanceDataSource] Stack trace: $stackTrace');
      rethrow;
    }
  }
}
