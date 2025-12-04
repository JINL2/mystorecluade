import '../../../domain/entities/reliability_score.dart';
import 'reliability_score_dto.dart';

/// Extension to map ReliabilityScoreDto → Domain Entity
extension ReliabilityScoreDtoMapper on ReliabilityScoreDto {
  /// Convert DTO to Domain Entity
  ReliabilityScore toEntity() {
    return ReliabilityScore(
      companyId: companyId,
      periodStart: periodStart,
      periodEnd: periodEnd,
      shiftSummary: shiftSummary.toEntity(),
      understaffedShifts: understaffedShifts.toEntity(),
      employees: employees.map((e) => e.toEntity()).toList(),
    );
  }
}

/// Extension to map ShiftSummaryDto → Domain Entity
extension ShiftSummaryDtoMapper on ShiftSummaryDto {
  ShiftSummary toEntity() {
    return ShiftSummary(
      today: today.toEntity(),
      yesterday: yesterday.toEntity(),
      thisMonth: thisMonth.toEntity(),
      lastMonth: lastMonth.toEntity(),
      twoMonthsAgo: twoMonthsAgo.toEntity(),
    );
  }
}

/// Extension to map PeriodStatsDto → Domain Entity
extension PeriodStatsDtoMapper on PeriodStatsDto {
  PeriodStats toEntity() {
    return PeriodStats(
      totalShifts: totalShifts,
      lateCount: lateCount,
      overtimeCount: overtimeCount,
      overtimeAmountSum: overtimeAmountSum.toDouble(),
      problemCount: problemCount,
      problemSolvedCount: problemSolvedCount,
    );
  }
}

/// Extension to map UnderstaffedShiftsDto → Domain Entity
extension UnderstaffedShiftsDtoMapper on UnderstaffedShiftsDto {
  UnderstaffedShifts toEntity() {
    return UnderstaffedShifts(
      today: today,
      yesterday: yesterday,
      thisMonth: thisMonth,
      lastMonth: lastMonth,
      twoMonthsAgo: twoMonthsAgo,
    );
  }
}

/// Extension to map EmployeeReliabilityDto → Domain Entity
extension EmployeeReliabilityDtoMapper on EmployeeReliabilityDto {
  EmployeeReliability toEntity() {
    return EmployeeReliability(
      userId: userId,
      userName: userName,
      profileImage: profileImage,
      totalApplications: totalApplications,
      approvedShifts: approvedShifts,
      completedShifts: completedShifts,
      lateCount: lateCount,
      lateRate: lateRate.toDouble(),
      onTimeRate: onTimeRate.toDouble(),
      avgLateMinutes: avgLateMinutes.toDouble(),
      reliability: reliability.toDouble(),
      finalScore: finalScore.toDouble(),
    );
  }
}
