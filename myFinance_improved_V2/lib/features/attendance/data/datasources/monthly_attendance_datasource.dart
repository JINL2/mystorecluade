import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/monthly_attendance_model.dart';

/// Monthly Attendance DataSource
///
/// Supabase RPC 호출을 담당
/// - monthly_check_in
/// - monthly_check_out
/// - get_monthly_attendance_stats
/// - get_monthly_attendance_list
abstract class MonthlyAttendanceDataSource {
  /// 체크인
  Future<MonthlyCheckResultModel> checkIn({
    required String userId,
    required String companyId,
    String? storeId,
  });

  /// 체크아웃
  Future<MonthlyCheckResultModel> checkOut({
    required String userId,
    required String companyId,
  });

  /// 월간 통계 조회
  Future<MonthlyAttendanceStatsModel> getStats({
    required String userId,
    required String companyId,
    int? year,
    int? month,
  });

  /// 월간 목록 조회
  Future<MonthlyAttendanceListModel> getList({
    required String userId,
    required String companyId,
    required int year,
    required int month,
  });
}

/// MonthlyAttendanceDataSource 구현
class MonthlyAttendanceDataSourceImpl implements MonthlyAttendanceDataSource {
  final SupabaseClient _client;

  MonthlyAttendanceDataSourceImpl(this._client);

  @override
  Future<MonthlyCheckResultModel> checkIn({
    required String userId,
    required String companyId,
    String? storeId,
  }) async {
    final response = await _client.rpc(
      'monthly_check_in',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
        if (storeId != null) 'p_store_id': storeId,
      },
    );

    return MonthlyCheckResultModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MonthlyCheckResultModel> checkOut({
    required String userId,
    required String companyId,
  }) async {
    final response = await _client.rpc(
      'monthly_check_out',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
      },
    );

    return MonthlyCheckResultModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MonthlyAttendanceStatsModel> getStats({
    required String userId,
    required String companyId,
    int? year,
    int? month,
  }) async {
    debugPrint('🔍 [DataSource] getStats RPC call');
    debugPrint('   params: p_user_id=$userId, p_company_id=$companyId, p_year=$year, p_month=$month');

    final response = await _client.rpc(
      'get_monthly_attendance_stats',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
        if (year != null) 'p_year': year,
        if (month != null) 'p_month': month,
      },
    );

    // 🔍 DEBUG: Raw RPC response
    debugPrint('🔍 [DataSource] RPC raw response:');
    debugPrint('   $response');

    return MonthlyAttendanceStatsModel.fromJson(
      response as Map<String, dynamic>,
    );
  }

  @override
  Future<MonthlyAttendanceListModel> getList({
    required String userId,
    required String companyId,
    required int year,
    required int month,
  }) async {
    final response = await _client.rpc(
      'get_monthly_attendance_list',
      params: {
        'p_user_id': userId,
        'p_company_id': companyId,
        'p_year': year,
        'p_month': month,
      },
    );

    return MonthlyAttendanceListModel.fromJson(
      response as Map<String, dynamic>,
    );
  }
}
