// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reliability_score_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReliabilityScoreDtoImpl _$$ReliabilityScoreDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ReliabilityScoreDtoImpl(
      companyId: json['company_id'] as String,
      periodStart: json['period_start'] as String?,
      periodEnd: json['period_end'] as String?,
      shiftSummary: ShiftSummaryDto.fromJson(
          json['shift_summary'] as Map<String, dynamic>),
      understaffedShifts: UnderstaffedShiftsDto.fromJson(
          json['understaffed_shifts'] as Map<String, dynamic>),
      employees: (json['employees'] as List<dynamic>?)
              ?.map((e) =>
                  EmployeeReliabilityDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ReliabilityScoreDtoImplToJson(
        _$ReliabilityScoreDtoImpl instance) =>
    <String, dynamic>{
      'company_id': instance.companyId,
      'period_start': instance.periodStart,
      'period_end': instance.periodEnd,
      'shift_summary': instance.shiftSummary,
      'understaffed_shifts': instance.understaffedShifts,
      'employees': instance.employees,
    };

_$ShiftSummaryDtoImpl _$$ShiftSummaryDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftSummaryDtoImpl(
      today: PeriodStatsDto.fromJson(json['today'] as Map<String, dynamic>),
      yesterday:
          PeriodStatsDto.fromJson(json['yesterday'] as Map<String, dynamic>),
      thisMonth:
          PeriodStatsDto.fromJson(json['this_month'] as Map<String, dynamic>),
      lastMonth:
          PeriodStatsDto.fromJson(json['last_month'] as Map<String, dynamic>),
      twoMonthsAgo: PeriodStatsDto.fromJson(
          json['two_months_ago'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$ShiftSummaryDtoImplToJson(
        _$ShiftSummaryDtoImpl instance) =>
    <String, dynamic>{
      'today': instance.today,
      'yesterday': instance.yesterday,
      'this_month': instance.thisMonth,
      'last_month': instance.lastMonth,
      'two_months_ago': instance.twoMonthsAgo,
    };

_$PeriodStatsDtoImpl _$$PeriodStatsDtoImplFromJson(Map<String, dynamic> json) =>
    _$PeriodStatsDtoImpl(
      totalShifts: (json['total_shifts'] as num?)?.toInt() ?? 0,
      lateCount: (json['late_count'] as num?)?.toInt() ?? 0,
      overtimeCount: (json['overtime_count'] as num?)?.toInt() ?? 0,
      overtimeAmountSum: json['overtime_amount_sum'] as num? ?? 0,
      problemCount: (json['problem_count'] as num?)?.toInt() ?? 0,
      problemSolvedCount: (json['problem_solved_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$PeriodStatsDtoImplToJson(
        _$PeriodStatsDtoImpl instance) =>
    <String, dynamic>{
      'total_shifts': instance.totalShifts,
      'late_count': instance.lateCount,
      'overtime_count': instance.overtimeCount,
      'overtime_amount_sum': instance.overtimeAmountSum,
      'problem_count': instance.problemCount,
      'problem_solved_count': instance.problemSolvedCount,
    };

_$UnderstaffedShiftsDtoImpl _$$UnderstaffedShiftsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$UnderstaffedShiftsDtoImpl(
      today: (json['today'] as num?)?.toInt() ?? 0,
      yesterday: (json['yesterday'] as num?)?.toInt() ?? 0,
      thisMonth: (json['this_month'] as num?)?.toInt() ?? 0,
      lastMonth: (json['last_month'] as num?)?.toInt() ?? 0,
      twoMonthsAgo: (json['two_months_ago'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$UnderstaffedShiftsDtoImplToJson(
        _$UnderstaffedShiftsDtoImpl instance) =>
    <String, dynamic>{
      'today': instance.today,
      'yesterday': instance.yesterday,
      'this_month': instance.thisMonth,
      'last_month': instance.lastMonth,
      'two_months_ago': instance.twoMonthsAgo,
    };

_$EmployeeReliabilityDtoImpl _$$EmployeeReliabilityDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$EmployeeReliabilityDtoImpl(
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      profileImage: json['profile_image'] as String?,
      totalApplications: (json['total_applications'] as num?)?.toInt() ?? 0,
      approvedShifts: (json['approved_shifts'] as num?)?.toInt() ?? 0,
      completedShifts: (json['completed_shifts'] as num?)?.toInt() ?? 0,
      lateCount: (json['late_count'] as num?)?.toInt() ?? 0,
      lateRate: json['late_rate'] as num? ?? 0,
      onTimeRate: json['on_time_rate'] as num? ?? 0,
      avgLateMinutes: json['avg_late_minutes'] as num? ?? 0,
      reliability: json['reliability'] as num? ?? 0,
      finalScore: json['final_score'] as num? ?? 0,
    );

Map<String, dynamic> _$$EmployeeReliabilityDtoImplToJson(
        _$EmployeeReliabilityDtoImpl instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'user_name': instance.userName,
      'profile_image': instance.profileImage,
      'total_applications': instance.totalApplications,
      'approved_shifts': instance.approvedShifts,
      'completed_shifts': instance.completedShifts,
      'late_count': instance.lateCount,
      'late_rate': instance.lateRate,
      'on_time_rate': instance.onTimeRate,
      'avg_late_minutes': instance.avgLateMinutes,
      'reliability': instance.reliability,
      'final_score': instance.finalScore,
    };
