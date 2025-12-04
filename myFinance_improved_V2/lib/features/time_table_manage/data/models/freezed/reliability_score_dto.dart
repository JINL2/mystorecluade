import 'package:freezed_annotation/freezed_annotation.dart';

part 'reliability_score_dto.freezed.dart';
part 'reliability_score_dto.g.dart';

/// Reliability Score DTO - Top level
///
/// Maps to RPC: get_reliability_score
@freezed
class ReliabilityScoreDto with _$ReliabilityScoreDto {
  const factory ReliabilityScoreDto({
    @JsonKey(name: 'company_id') required String companyId,
    @JsonKey(name: 'period_start') String? periodStart,
    @JsonKey(name: 'period_end') String? periodEnd,
    @JsonKey(name: 'shift_summary') required ShiftSummaryDto shiftSummary,
    @JsonKey(name: 'understaffed_shifts')
    required UnderstaffedShiftsDto understaffedShifts,
    @JsonKey(name: 'employees') @Default([]) List<EmployeeReliabilityDto> employees,
  }) = _ReliabilityScoreDto;

  factory ReliabilityScoreDto.fromJson(Map<String, dynamic> json) =>
      _$ReliabilityScoreDtoFromJson(json);
}

/// Shift Summary DTO
@freezed
class ShiftSummaryDto with _$ShiftSummaryDto {
  const factory ShiftSummaryDto({
    @JsonKey(name: 'today') required PeriodStatsDto today,
    @JsonKey(name: 'yesterday') required PeriodStatsDto yesterday,
    @JsonKey(name: 'this_month') required PeriodStatsDto thisMonth,
    @JsonKey(name: 'last_month') required PeriodStatsDto lastMonth,
    @JsonKey(name: 'two_months_ago') required PeriodStatsDto twoMonthsAgo,
  }) = _ShiftSummaryDto;

  factory ShiftSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftSummaryDtoFromJson(json);
}

/// Period Stats DTO
@freezed
class PeriodStatsDto with _$PeriodStatsDto {
  const factory PeriodStatsDto({
    @JsonKey(name: 'total_shifts') @Default(0) int totalShifts,
    @JsonKey(name: 'late_count') @Default(0) int lateCount,
    @JsonKey(name: 'overtime_count') @Default(0) int overtimeCount,
    @JsonKey(name: 'overtime_amount_sum') @Default(0) num overtimeAmountSum,
    @JsonKey(name: 'problem_count') @Default(0) int problemCount,
    @JsonKey(name: 'problem_solved_count') @Default(0) int problemSolvedCount,
  }) = _PeriodStatsDto;

  factory PeriodStatsDto.fromJson(Map<String, dynamic> json) =>
      _$PeriodStatsDtoFromJson(json);
}

/// Understaffed Shifts DTO
@freezed
class UnderstaffedShiftsDto with _$UnderstaffedShiftsDto {
  const factory UnderstaffedShiftsDto({
    @JsonKey(name: 'today') @Default(0) int today,
    @JsonKey(name: 'yesterday') @Default(0) int yesterday,
    @JsonKey(name: 'this_month') @Default(0) int thisMonth,
    @JsonKey(name: 'last_month') @Default(0) int lastMonth,
    @JsonKey(name: 'two_months_ago') @Default(0) int twoMonthsAgo,
  }) = _UnderstaffedShiftsDto;

  factory UnderstaffedShiftsDto.fromJson(Map<String, dynamic> json) =>
      _$UnderstaffedShiftsDtoFromJson(json);
}

/// Employee Reliability DTO
@freezed
class EmployeeReliabilityDto with _$EmployeeReliabilityDto {
  const factory EmployeeReliabilityDto({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'user_name') required String userName,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'total_applications') @Default(0) int totalApplications,
    @JsonKey(name: 'approved_shifts') @Default(0) int approvedShifts,
    @JsonKey(name: 'completed_shifts') @Default(0) int completedShifts,
    @JsonKey(name: 'late_count') @Default(0) int lateCount,
    @JsonKey(name: 'late_rate') @Default(0) num lateRate,
    @JsonKey(name: 'on_time_rate') @Default(0) num onTimeRate,
    @JsonKey(name: 'avg_late_minutes') @Default(0) num avgLateMinutes,
    @JsonKey(name: 'reliability') @Default(0) num reliability,
    @JsonKey(name: 'final_score') @Default(0) num finalScore,
  }) = _EmployeeReliabilityDto;

  factory EmployeeReliabilityDto.fromJson(Map<String, dynamic> json) =>
      _$EmployeeReliabilityDtoFromJson(json);
}
