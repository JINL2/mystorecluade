// lib/features/report_control/domain/entities/templates/daily_attendance/attendance_report.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'attendance_report.freezed.dart';
part 'attendance_report.g.dart';

/// Daily Attendance Report - Domain Entity
@freezed
class AttendanceReport with _$AttendanceReport {
  const factory AttendanceReport({
    @JsonKey(name: 'hero_stats') required HeroStats heroStats,
    @JsonKey(name: 'cost_impact') required CostImpact costImpact,
    required List<AttendanceIssue> issues,
    required List<StorePerformance> stores,
    @JsonKey(name: 'urgent_actions') required List<UrgentAction> urgentActions,
    @JsonKey(name: 'manager_quality_flags') List<ManagerQualityFlag>? managerQualityFlags,
    @JsonKey(name: 'ai_summary') String? aiSummary,
  }) = _AttendanceReport;

  factory AttendanceReport.fromJson(Map<String, dynamic> json) =>
      _$AttendanceReportFromJson(json);
}

/// Hero Statistics
@freezed
class HeroStats with _$HeroStats {
  const factory HeroStats({
    @JsonKey(name: 'total_shifts') required int totalShifts,
    @JsonKey(name: 'total_issues') required int totalIssues,
    @JsonKey(name: 'solved_count') int? solvedCount,
    @JsonKey(name: 'unsolved_count') int? unsolvedCount,
  }) = _HeroStats;

  factory HeroStats.fromJson(Map<String, dynamic> json) =>
      _$HeroStatsFromJson(json);
}

/// Cost Impact
@freezed
class CostImpact with _$CostImpact {
  const factory CostImpact({
    @JsonKey(name: 'net_minutes') required int netMinutes,
    @JsonKey(name: 'overtime_pay_minutes') required int overtimePayMinutes,
    @JsonKey(name: 'late_deduction_minutes') required int lateDeductionMinutes,
  }) = _CostImpact;

  factory CostImpact.fromJson(Map<String, dynamic> json) =>
      _$CostImpactFromJson(json);
}

/// Attendance Issue
@freezed
class AttendanceIssue with _$AttendanceIssue {
  const factory AttendanceIssue({
    @JsonKey(name: 'employee_id') required String employeeId,
    @JsonKey(name: 'employee_name') required String employeeName,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'shift_name') required String shiftName,
    @JsonKey(name: 'problem_type') required String problemType,
    required String severity,
    @JsonKey(name: 'is_solved') required bool isSolved,
    @JsonKey(name: 'time_detail') required TimeDetail timeDetail,
    @JsonKey(name: 'manager_adjustment') required ManagerAdjustment managerAdjustment,
    @JsonKey(name: 'monthly_performance') MonthlyPerformance? monthlyPerformance,
    @JsonKey(name: 'ai_comment') String? aiComment,
  }) = _AttendanceIssue;

  factory AttendanceIssue.fromJson(Map<String, dynamic> json) =>
      _$AttendanceIssueFromJson(json);
}

/// Time Detail
@freezed
class TimeDetail with _$TimeDetail {
  const factory TimeDetail({
    @JsonKey(name: 'scheduled_start') required String scheduledStart,
    @JsonKey(name: 'scheduled_end') required String scheduledEnd,
    @JsonKey(name: 'scheduled_hours') double? scheduledHours,
    @JsonKey(name: 'actual_start') String? actualStart,
    @JsonKey(name: 'actual_end') String? actualEnd,
    @JsonKey(name: 'actual_hours') double? actualHours,
    @JsonKey(name: 'late_minutes') double? lateMinutes,
    @JsonKey(name: 'overtime_minutes') double? overtimeMinutes,
  }) = _TimeDetail;

  factory TimeDetail.fromJson(Map<String, dynamic> json) =>
      _$TimeDetailFromJson(json);
}

/// Manager Adjustment
@freezed
class ManagerAdjustment with _$ManagerAdjustment {
  const factory ManagerAdjustment({
    @JsonKey(name: 'is_adjusted') required bool isAdjusted,
    @JsonKey(name: 'payment_start') String? paymentStart,
    @JsonKey(name: 'payment_end') String? paymentEnd,
    @JsonKey(name: 'final_penalty_minutes') required int finalPenaltyMinutes,
    @JsonKey(name: 'final_overtime_minutes') required int finalOvertimeMinutes,
    @JsonKey(name: 'adjusted_by') String? adjustedBy,
    String? reason,
  }) = _ManagerAdjustment;

  factory ManagerAdjustment.fromJson(Map<String, dynamic> json) =>
      _$ManagerAdjustmentFromJson(json);
}

/// Monthly Performance
@freezed
class MonthlyPerformance with _$MonthlyPerformance {
  const factory MonthlyPerformance({
    String? month,
    @JsonKey(name: 'total_shifts') int? totalShifts,
    @JsonKey(name: 'attendance_rate') double? attendanceRate,
    @JsonKey(name: 'late_count') int? lateCount,
    @JsonKey(name: 'avg_late_minutes') double? avgLateMinutes,
    @JsonKey(name: 'no_checkin_count') int? noCheckinCount,
  }) = _MonthlyPerformance;

  factory MonthlyPerformance.fromJson(Map<String, dynamic> json) =>
      _$MonthlyPerformanceFromJson(json);
}

/// Store Performance
@freezed
class StorePerformance with _$StorePerformance {
  const factory StorePerformance({
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'issues_count') required int issuesCount,
    required String status, // 'critical', 'warning', 'good'
  }) = _StorePerformance;

  factory StorePerformance.fromJson(Map<String, dynamic> json) =>
      _$StorePerformanceFromJson(json);
}

/// Urgent Action
@freezed
class UrgentAction with _$UrgentAction {
  const factory UrgentAction({
    required String priority,
    required String employee,
    required String store,
    required String issue,
    required String action,
  }) = _UrgentAction;

  factory UrgentAction.fromJson(Map<String, dynamic> json) =>
      _$UrgentActionFromJson(json);
}

/// Manager Quality Flag
@freezed
class ManagerQualityFlag with _$ManagerQualityFlag {
  const factory ManagerQualityFlag({
    @JsonKey(name: 'flag_type') required String flagType,
    required String description,
    @JsonKey(name: 'affected_employee') String? affectedEmployee,
    String? manager,
  }) = _ManagerQualityFlag;

  factory ManagerQualityFlag.fromJson(Map<String, dynamic> json) =>
      _$ManagerQualityFlagFromJson(json);
}
