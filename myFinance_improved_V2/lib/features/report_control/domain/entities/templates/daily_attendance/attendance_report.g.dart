// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attendance_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AttendanceReportImpl _$$AttendanceReportImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceReportImpl(
      heroStats: HeroStats.fromJson(json['hero_stats'] as Map<String, dynamic>),
      costImpact:
          CostImpact.fromJson(json['cost_impact'] as Map<String, dynamic>),
      issues: (json['issues'] as List<dynamic>)
          .map((e) => AttendanceIssue.fromJson(e as Map<String, dynamic>))
          .toList(),
      stores: (json['stores'] as List<dynamic>)
          .map((e) => StorePerformance.fromJson(e as Map<String, dynamic>))
          .toList(),
      urgentActions: (json['urgent_actions'] as List<dynamic>)
          .map((e) => UrgentAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      managerQualityFlags: (json['manager_quality_flags'] as List<dynamic>?)
          ?.map((e) => ManagerQualityFlag.fromJson(e as Map<String, dynamic>))
          .toList(),
      aiSummary: json['ai_summary'] as String?,
    );

Map<String, dynamic> _$$AttendanceReportImplToJson(
        _$AttendanceReportImpl instance) =>
    <String, dynamic>{
      'hero_stats': instance.heroStats,
      'cost_impact': instance.costImpact,
      'issues': instance.issues,
      'stores': instance.stores,
      'urgent_actions': instance.urgentActions,
      'manager_quality_flags': instance.managerQualityFlags,
      'ai_summary': instance.aiSummary,
    };

_$HeroStatsImpl _$$HeroStatsImplFromJson(Map<String, dynamic> json) =>
    _$HeroStatsImpl(
      totalShifts: (json['total_shifts'] as num).toInt(),
      totalIssues: (json['total_issues'] as num).toInt(),
      solvedCount: (json['solved_count'] as num?)?.toInt(),
      unsolvedCount: (json['unsolved_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$HeroStatsImplToJson(_$HeroStatsImpl instance) =>
    <String, dynamic>{
      'total_shifts': instance.totalShifts,
      'total_issues': instance.totalIssues,
      'solved_count': instance.solvedCount,
      'unsolved_count': instance.unsolvedCount,
    };

_$CostImpactImpl _$$CostImpactImplFromJson(Map<String, dynamic> json) =>
    _$CostImpactImpl(
      netMinutes: (json['net_minutes'] as num).toInt(),
      overtimePayMinutes: (json['overtime_pay_minutes'] as num).toInt(),
      lateDeductionMinutes: (json['late_deduction_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$$CostImpactImplToJson(_$CostImpactImpl instance) =>
    <String, dynamic>{
      'net_minutes': instance.netMinutes,
      'overtime_pay_minutes': instance.overtimePayMinutes,
      'late_deduction_minutes': instance.lateDeductionMinutes,
    };

_$AttendanceIssueImpl _$$AttendanceIssueImplFromJson(
        Map<String, dynamic> json) =>
    _$AttendanceIssueImpl(
      employeeId: json['employee_id'] as String,
      employeeName: json['employee_name'] as String,
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      shiftName: json['shift_name'] as String,
      problemType: json['problem_type'] as String,
      severity: json['severity'] as String,
      isSolved: json['is_solved'] as bool,
      timeDetail:
          TimeDetail.fromJson(json['time_detail'] as Map<String, dynamic>),
      managerAdjustment: ManagerAdjustment.fromJson(
          json['manager_adjustment'] as Map<String, dynamic>),
      monthlyPerformance: json['monthly_performance'] == null
          ? null
          : MonthlyPerformance.fromJson(
              json['monthly_performance'] as Map<String, dynamic>),
      aiComment: json['ai_comment'] as String?,
    );

Map<String, dynamic> _$$AttendanceIssueImplToJson(
        _$AttendanceIssueImpl instance) =>
    <String, dynamic>{
      'employee_id': instance.employeeId,
      'employee_name': instance.employeeName,
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'shift_name': instance.shiftName,
      'problem_type': instance.problemType,
      'severity': instance.severity,
      'is_solved': instance.isSolved,
      'time_detail': instance.timeDetail,
      'manager_adjustment': instance.managerAdjustment,
      'monthly_performance': instance.monthlyPerformance,
      'ai_comment': instance.aiComment,
    };

_$TimeDetailImpl _$$TimeDetailImplFromJson(Map<String, dynamic> json) =>
    _$TimeDetailImpl(
      scheduledStart: json['scheduled_start'] as String,
      scheduledEnd: json['scheduled_end'] as String,
      scheduledHours: (json['scheduled_hours'] as num?)?.toDouble(),
      actualStart: json['actual_start'] as String?,
      actualEnd: json['actual_end'] as String?,
      actualHours: (json['actual_hours'] as num?)?.toDouble(),
      lateMinutes: (json['late_minutes'] as num?)?.toDouble(),
      overtimeMinutes: (json['overtime_minutes'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$TimeDetailImplToJson(_$TimeDetailImpl instance) =>
    <String, dynamic>{
      'scheduled_start': instance.scheduledStart,
      'scheduled_end': instance.scheduledEnd,
      'scheduled_hours': instance.scheduledHours,
      'actual_start': instance.actualStart,
      'actual_end': instance.actualEnd,
      'actual_hours': instance.actualHours,
      'late_minutes': instance.lateMinutes,
      'overtime_minutes': instance.overtimeMinutes,
    };

_$ManagerAdjustmentImpl _$$ManagerAdjustmentImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerAdjustmentImpl(
      isAdjusted: json['is_adjusted'] as bool,
      paymentStart: json['payment_start'] as String?,
      paymentEnd: json['payment_end'] as String?,
      finalPenaltyMinutes: (json['final_penalty_minutes'] as num).toInt(),
      finalOvertimeMinutes: (json['final_overtime_minutes'] as num).toInt(),
      adjustedBy: json['adjusted_by'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$$ManagerAdjustmentImplToJson(
        _$ManagerAdjustmentImpl instance) =>
    <String, dynamic>{
      'is_adjusted': instance.isAdjusted,
      'payment_start': instance.paymentStart,
      'payment_end': instance.paymentEnd,
      'final_penalty_minutes': instance.finalPenaltyMinutes,
      'final_overtime_minutes': instance.finalOvertimeMinutes,
      'adjusted_by': instance.adjustedBy,
      'reason': instance.reason,
    };

_$MonthlyPerformanceImpl _$$MonthlyPerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyPerformanceImpl(
      month: json['month'] as String?,
      totalShifts: (json['total_shifts'] as num?)?.toInt(),
      attendanceRate: (json['attendance_rate'] as num?)?.toDouble(),
      lateCount: (json['late_count'] as num?)?.toInt(),
      avgLateMinutes: (json['avg_late_minutes'] as num?)?.toDouble(),
      noCheckinCount: (json['no_checkin_count'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$MonthlyPerformanceImplToJson(
        _$MonthlyPerformanceImpl instance) =>
    <String, dynamic>{
      'month': instance.month,
      'total_shifts': instance.totalShifts,
      'attendance_rate': instance.attendanceRate,
      'late_count': instance.lateCount,
      'avg_late_minutes': instance.avgLateMinutes,
      'no_checkin_count': instance.noCheckinCount,
    };

_$StorePerformanceImpl _$$StorePerformanceImplFromJson(
        Map<String, dynamic> json) =>
    _$StorePerformanceImpl(
      storeId: json['store_id'] as String,
      storeName: json['store_name'] as String,
      issuesCount: (json['issues_count'] as num).toInt(),
      status: json['status'] as String,
    );

Map<String, dynamic> _$$StorePerformanceImplToJson(
        _$StorePerformanceImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'store_name': instance.storeName,
      'issues_count': instance.issuesCount,
      'status': instance.status,
    };

_$UrgentActionImpl _$$UrgentActionImplFromJson(Map<String, dynamic> json) =>
    _$UrgentActionImpl(
      priority: json['priority'] as String,
      employee: json['employee'] as String,
      store: json['store'] as String,
      issue: json['issue'] as String,
      action: json['action'] as String,
    );

Map<String, dynamic> _$$UrgentActionImplToJson(_$UrgentActionImpl instance) =>
    <String, dynamic>{
      'priority': instance.priority,
      'employee': instance.employee,
      'store': instance.store,
      'issue': instance.issue,
      'action': instance.action,
    };

_$ManagerQualityFlagImpl _$$ManagerQualityFlagImplFromJson(
        Map<String, dynamic> json) =>
    _$ManagerQualityFlagImpl(
      flagType: json['flag_type'] as String,
      description: json['description'] as String,
      affectedEmployee: json['affected_employee'] as String?,
      manager: json['manager'] as String?,
    );

Map<String, dynamic> _$$ManagerQualityFlagImplToJson(
        _$ManagerQualityFlagImpl instance) =>
    <String, dynamic>{
      'flag_type': instance.flagType,
      'description': instance.description,
      'affected_employee': instance.affectedEmployee,
      'manager': instance.manager,
    };
