import 'package:freezed_annotation/freezed_annotation.dart';

part 'user_shift_stats.freezed.dart';

/// User Shift Stats Entity - Statistics for attendance and salary
@freezed
class UserShiftStats with _$UserShiftStats {
  const UserShiftStats._();

  const factory UserShiftStats({
    required SalaryInfo salaryInfo,
    required PeriodStats today,
    required PeriodStats thisWeek,
    required PeriodStats thisMonth,
    required PeriodStats lastMonth,
    required PeriodStats thisYear,
    required WeeklyPayments weeklyPayments,
    required ReliabilityScore reliabilityScore,
  }) = _UserShiftStats;
}

/// Salary information
@freezed
class SalaryInfo with _$SalaryInfo {
  const SalaryInfo._();

  const factory SalaryInfo({
    required String salaryType,
    required double salaryAmount,
    required String currencyCode,
    required String currencySymbol,
  }) = _SalaryInfo;

  /// Calculate overtime bonus based on overtime minutes
  ///
  /// Returns formatted string with currency symbol (e.g., "+₩15,000")
  /// Returns empty string if no overtime or invalid salary
  String calculateOvertimeBonus(int overtimeMinutes) {
    if (overtimeMinutes <= 0 || salaryAmount <= 0) {
      return '';
    }

    // Calculate overtime bonus (overtime minutes * hourly rate / 60)
    final overtimeHours = overtimeMinutes / 60.0;
    final bonus = (overtimeHours * salaryAmount).round();

    if (bonus <= 0) {
      return '';
    }

    // Format with thousand separators
    final formattedBonus = bonus.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );

    return '+$currencySymbol$formattedBonus';
  }

  /// Format amount with currency symbol
  String formatCurrency(double amount) {
    final formattedAmount = amount.round().toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]},',
    );
    return '$currencySymbol$formattedAmount';
  }
}

/// Period statistics (today, this_week, this_month, etc.)
@freezed
class PeriodStats with _$PeriodStats {
  const PeriodStats._();

  const factory PeriodStats({
    required double onTimeRate,
    required int completeShifts,
    required double totalConfirmedHours,
    required double basePay,
    required double bonusPay,
    required double totalPayment,
    required double previousTotalPayment,
    required double changePercentage,
  }) = _PeriodStats;

  /// Format hours to "XXh XXm" format
  String get formattedHours {
    final absHours = totalConfirmedHours.abs();
    final hours = absHours.floor();
    final minutes = ((absHours - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }

  /// Check if change is positive
  bool get isPositiveChange => changePercentage >= 0;

  /// Format change percentage with sign
  String get formattedChangePercentage {
    final sign = changePercentage >= 0 ? '+' : '';
    return '$sign${changePercentage.toStringAsFixed(1)}%';
  }
}

/// Weekly payments for trend chart
@freezed
class WeeklyPayments with _$WeeklyPayments {
  const WeeklyPayments._();

  const factory WeeklyPayments({
    required double w1,
    required double w2,
    required double w3,
    required double w4,
    required double w5,
  }) = _WeeklyPayments;

  /// Convert to list for chart (oldest to newest: w5, w4, w3, w2, w1)
  List<double> toChartList() => [w5, w4, w3, w2, w1];
}

/// Reliability score from v_employee_statistics_score
@freezed
class ReliabilityScore with _$ReliabilityScore {
  const ReliabilityScore._();

  const factory ReliabilityScore({
    required int completedShifts,
    required double onTimeRate,
    required double finalScore,
    Map<String, dynamic>? scoreBreakdown,
  }) = _ReliabilityScore;
}
