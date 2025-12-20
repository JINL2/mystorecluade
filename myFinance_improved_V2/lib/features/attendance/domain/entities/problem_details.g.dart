// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'problem_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProblemDetailsImpl _$$ProblemDetailsImplFromJson(Map<String, dynamic> json) =>
    _$ProblemDetailsImpl(
      hasLate: json['has_late'] as bool? ?? false,
      hasAbsence: json['has_absence'] as bool? ?? false,
      hasOvertime: json['has_overtime'] as bool? ?? false,
      hasEarlyLeave: json['has_early_leave'] as bool? ?? false,
      hasNoCheckout: json['has_no_checkout'] as bool? ?? false,
      hasLocationIssue: json['has_location_issue'] as bool? ?? false,
      hasReported: json['has_reported'] as bool? ?? false,
      isSolved: json['is_solved'] as bool? ?? false,
      problemCount: (json['problem_count'] as num?)?.toInt() ?? 0,
      detectedAt: json['detected_at'] as String?,
      problems: (json['problems'] as List<dynamic>?)
              ?.map((e) => Problem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProblemDetailsImplToJson(
        _$ProblemDetailsImpl instance) =>
    <String, dynamic>{
      'has_late': instance.hasLate,
      'has_absence': instance.hasAbsence,
      'has_overtime': instance.hasOvertime,
      'has_early_leave': instance.hasEarlyLeave,
      'has_no_checkout': instance.hasNoCheckout,
      'has_location_issue': instance.hasLocationIssue,
      'has_reported': instance.hasReported,
      'is_solved': instance.isSolved,
      'problem_count': instance.problemCount,
      'detected_at': instance.detectedAt,
      'problems': instance.problems,
    };

_$LateProblemImpl _$$LateProblemImplFromJson(Map<String, dynamic> json) =>
    _$LateProblemImpl(
      actualMinutes: (json['actual_minutes'] as num?)?.toInt() ?? 0,
      payrollMinutes: (json['payroll_minutes'] as num?)?.toInt() ?? 0,
      isPayrollAdjusted: json['is_payroll_adjusted'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$LateProblemImplToJson(_$LateProblemImpl instance) =>
    <String, dynamic>{
      'actual_minutes': instance.actualMinutes,
      'payroll_minutes': instance.payrollMinutes,
      'is_payroll_adjusted': instance.isPayrollAdjusted,
      'type': instance.$type,
    };

_$OvertimeProblemImpl _$$OvertimeProblemImplFromJson(
        Map<String, dynamic> json) =>
    _$OvertimeProblemImpl(
      actualMinutes: (json['actual_minutes'] as num?)?.toInt() ?? 0,
      payrollMinutes: (json['payroll_minutes'] as num?)?.toInt() ?? 0,
      isPayrollAdjusted: json['is_payroll_adjusted'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$OvertimeProblemImplToJson(
        _$OvertimeProblemImpl instance) =>
    <String, dynamic>{
      'actual_minutes': instance.actualMinutes,
      'payroll_minutes': instance.payrollMinutes,
      'is_payroll_adjusted': instance.isPayrollAdjusted,
      'type': instance.$type,
    };

_$EarlyLeaveProblemImpl _$$EarlyLeaveProblemImplFromJson(
        Map<String, dynamic> json) =>
    _$EarlyLeaveProblemImpl(
      actualMinutes: (json['actual_minutes'] as num?)?.toInt() ?? 0,
      payrollMinutes: (json['payroll_minutes'] as num?)?.toInt() ?? 0,
      isPayrollAdjusted: json['is_payroll_adjusted'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$EarlyLeaveProblemImplToJson(
        _$EarlyLeaveProblemImpl instance) =>
    <String, dynamic>{
      'actual_minutes': instance.actualMinutes,
      'payroll_minutes': instance.payrollMinutes,
      'is_payroll_adjusted': instance.isPayrollAdjusted,
      'type': instance.$type,
    };

_$AbsenceProblemImpl _$$AbsenceProblemImplFromJson(Map<String, dynamic> json) =>
    _$AbsenceProblemImpl(
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$AbsenceProblemImplToJson(
        _$AbsenceProblemImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$NoCheckoutProblemImpl _$$NoCheckoutProblemImplFromJson(
        Map<String, dynamic> json) =>
    _$NoCheckoutProblemImpl(
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$NoCheckoutProblemImplToJson(
        _$NoCheckoutProblemImpl instance) =>
    <String, dynamic>{
      'type': instance.$type,
    };

_$InvalidCheckinProblemImpl _$$InvalidCheckinProblemImplFromJson(
        Map<String, dynamic> json) =>
    _$InvalidCheckinProblemImpl(
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$InvalidCheckinProblemImplToJson(
        _$InvalidCheckinProblemImpl instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'type': instance.$type,
    };

_$InvalidCheckoutProblemImpl _$$InvalidCheckoutProblemImplFromJson(
        Map<String, dynamic> json) =>
    _$InvalidCheckoutProblemImpl(
      distance: (json['distance'] as num?)?.toInt() ?? 0,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$InvalidCheckoutProblemImplToJson(
        _$InvalidCheckoutProblemImpl instance) =>
    <String, dynamic>{
      'distance': instance.distance,
      'type': instance.$type,
    };

_$ReportedProblemImpl _$$ReportedProblemImplFromJson(
        Map<String, dynamic> json) =>
    _$ReportedProblemImpl(
      reason: json['reason'] as String? ?? '',
      reportedAt: json['reported_at'] as String?,
      isReportSolved: json['is_report_solved'] as bool? ?? false,
      $type: json['type'] as String?,
    );

Map<String, dynamic> _$$ReportedProblemImplToJson(
        _$ReportedProblemImpl instance) =>
    <String, dynamic>{
      'reason': instance.reason,
      'reported_at': instance.reportedAt,
      'is_report_solved': instance.isReportSolved,
      'type': instance.$type,
    };
