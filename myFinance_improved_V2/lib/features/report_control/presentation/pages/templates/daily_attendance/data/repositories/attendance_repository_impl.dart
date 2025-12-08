// lib/features/report_control/presentation/pages/templates/daily_attendance/data/repositories/attendance_repository_impl.dart

import '../../domain/repositories/attendance_repository.dart';
import '../../../../../../../domain/entities/templates/daily_attendance/attendance_report.dart';
import '../datasources/attendance_datasource.dart';

/// Attendance Repository Implementation
///
/// Data layer - Converts RPC data to Domain entities
class AttendanceRepositoryImpl implements AttendanceRepository {
  final AttendanceDataSource _dataSource;

  AttendanceRepositoryImpl(this._dataSource);

  @override
  Future<AttendanceReport> getDailyAttendanceReport({
    required String companyId,
    String? storeId,
    required DateTime targetDate,
  }) async {
    try {
      // 1. Call RPC
      final rpcData = await _dataSource.getDailyAttendanceReport(
        companyId: companyId,
        storeId: storeId,
        targetDate: targetDate,
      );

      // 2. Transform RPC data to our JSON structure
      final transformedData = _transformRpcToEntity(rpcData);

      // 3. Convert to Entity
      return AttendanceReport.fromJson(transformedData);
    } catch (e) {
      print('❌ [AttendanceRepo] Error: $e');
      rethrow;
    }
  }

  /// Transform RPC structure to Entity structure
  Map<String, dynamic> _transformRpcToEntity(Map<String, dynamic> rpcData) {
    final metadata = rpcData['report_metadata'] as Map<String, dynamic>;
    final byStore = (rpcData['by_store'] as List?) ?? [];
    final summary = (rpcData['summary'] as Map<String, dynamic>?) ?? {};

    // Collect all issues from all stores
    final allIssues = <Map<String, dynamic>>[];
    final allStores = <Map<String, dynamic>>[];

    for (final store in byStore) {
      final storeData = store as Map<String, dynamic>;
      final storeName = storeData['store_name'] as String;
      final storeId = storeData['store_id'] as String;

      // Problems unsolved
      final problemsUnsolved = (storeData['problems_unsolved'] as List?) ?? [];
      for (final problem in problemsUnsolved) {
        final p = problem as Map<String, dynamic>;
        allIssues.add(_transformIssue(p, storeName, storeId, false));
      }

      // Problems solved
      final problemsSolved = (storeData['problems_solved'] as List?) ?? [];
      for (final problem in problemsSolved) {
        final p = problem as Map<String, dynamic>;
        allIssues.add(_transformIssue(p, storeName, storeId, true));
      }

      // Store summary
      final storeSummary = storeData['store_summary'] as Map<String, dynamic>;
      allStores.add({
        'store_id': storeId,
        'store_name': storeName,
        'issues_count': (storeSummary['problems'] as int?) ?? 0,
        'status': _getStoreStatus(storeSummary),
      });
    }

    return {
      'hero_stats': {
        'total_shifts': metadata['total_shifts_yesterday'] ?? 0,
        'total_issues': metadata['problems_yesterday'] ?? 0,
        'solved_count': (metadata['problems_yesterday'] ?? 0) - (metadata['unsolved_yesterday'] ?? 0),
        'unsolved_count': metadata['unsolved_yesterday'] ?? 0,
      },
      'cost_impact': {
        'net_minutes': (summary['total_cost_impact']?['net'] as num?)?.toInt() ?? 0,
        'overtime_pay_minutes': (summary['total_cost_impact']?['overtime_pay'] as num?)?.toInt() ?? 0,
        'late_deduction_minutes': (summary['total_cost_impact']?['late_deductions'] as num?)?.toInt() ?? 0,
      },
      'issues': allIssues,
      'stores': allStores,
      'urgent_actions': _transformActions(summary['urgent_actions'] as List?),
      'manager_quality_flags': [],
      'ai_summary': null,
    };
  }

  Map<String, dynamic> _transformIssue(
    Map<String, dynamic> problem,
    String storeName,
    String storeId,
    bool isSolved,
  ) {
    final timeDetail = problem['time_detail'] as Map<String, dynamic>;
    final scheduled = timeDetail['scheduled'] as Map<String, dynamic>;
    final actual = timeDetail['actual'] as Map<String, dynamic>;
    final managerAdjusted = timeDetail['manager_adjusted'] as Map<String, dynamic>;

    return {
      'employee_id': problem['user_id'],
      'employee_name': problem['user_name'],
      'store_id': storeId,
      'store_name': storeName,
      'shift_name': problem['shift_name'],
      'problem_type': problem['problem_type'],
      'severity': problem['severity'],
      'is_solved': isSolved,
      'time_detail': {
        'scheduled_start': scheduled['start'] ?? '00:00',
        'scheduled_end': scheduled['end'] ?? '00:00',
        'scheduled_hours': (scheduled['total_hours'] as num?)?.toDouble() ?? 0.0,
        'actual_start': actual['start'],
        'actual_end': actual['end'],
        'actual_hours': (actual['total_hours'] as num?)?.toDouble(),
        'late_minutes': (actual['late_minutes'] as num?)?.toDouble() ?? 0.0,
        'overtime_minutes': (actual['overtime_minutes'] as num?)?.toDouble() ?? 0.0,
      },
      'manager_adjustment': {
        'is_adjusted': managerAdjusted['adjusted'] ?? false,
        'payment_start': managerAdjusted['start'],
        'payment_end': managerAdjusted['end'],
        'final_penalty_minutes': (managerAdjusted['final_penalty'] as num?)?.toInt() ?? 0,
        'final_overtime_minutes': (managerAdjusted['final_overtime_pay'] as num?)?.toInt() ?? 0,
        'adjusted_by': null,
        'reason': null,
      },
      'monthly_performance': problem['monthly_performance'],
      'ai_comment': null,
    };
  }

  String _getStoreStatus(Map<String, dynamic> summary) {
    final unsolved = (summary['unsolved'] as int?) ?? 0;
    if (unsolved > 1) return 'critical';
    if (unsolved > 0) return 'warning';
    return 'good';
  }

  List<Map<String, dynamic>> _transformActions(List? actions) {
    if (actions == null) return [];
    return actions.map((a) {
      final action = a as Map<String, dynamic>;
      return {
        'priority': action['priority'] ?? 'medium',
        'employee': action['employee'] ?? '',
        'store': action['store'] ?? '',
        'issue': action['issue'] ?? '',
        'action': action['action'] ?? '',
      };
    }).toList();
  }
}
