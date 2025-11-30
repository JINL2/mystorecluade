import '../../domain/entities/user_shift_stats.dart';

/// Model for user_shift_stats RPC response
class UserShiftStatsModel {
  final SalaryInfoModel salaryInfo;
  final PeriodStatsModel today;
  final PeriodStatsModel thisWeek;
  final PeriodStatsModel thisMonth;
  final PeriodStatsModel lastMonth;
  final PeriodStatsModel thisYear;
  final WeeklyPaymentsModel weeklyPayments;

  UserShiftStatsModel({
    required this.salaryInfo,
    required this.today,
    required this.thisWeek,
    required this.thisMonth,
    required this.lastMonth,
    required this.thisYear,
    required this.weeklyPayments,
  });

  factory UserShiftStatsModel.fromJson(Map<String, dynamic> json) {
    return UserShiftStatsModel(
      salaryInfo: SalaryInfoModel.fromJson(json['salary_info'] as Map<String, dynamic>),
      today: PeriodStatsModel.fromJson(json['today'] as Map<String, dynamic>),
      thisWeek: PeriodStatsModel.fromJson(json['this_week'] as Map<String, dynamic>),
      thisMonth: PeriodStatsModel.fromJson(json['this_month'] as Map<String, dynamic>),
      lastMonth: PeriodStatsModel.fromJson(json['last_month'] as Map<String, dynamic>),
      thisYear: PeriodStatsModel.fromJson(json['this_year'] as Map<String, dynamic>),
      weeklyPayments: WeeklyPaymentsModel.fromJson(json['weekly_payments'] as Map<String, dynamic>),
    );
  }

  UserShiftStats toEntity() {
    return UserShiftStats(
      salaryInfo: salaryInfo.toEntity(),
      today: today.toEntity(),
      thisWeek: thisWeek.toEntity(),
      thisMonth: thisMonth.toEntity(),
      lastMonth: lastMonth.toEntity(),
      thisYear: thisYear.toEntity(),
      weeklyPayments: weeklyPayments.toEntity(),
    );
  }
}

class SalaryInfoModel {
  final String salaryType;
  final double salaryAmount;
  final String currencyCode;
  final String currencySymbol;

  SalaryInfoModel({
    required this.salaryType,
    required this.salaryAmount,
    required this.currencyCode,
    required this.currencySymbol,
  });

  factory SalaryInfoModel.fromJson(Map<String, dynamic> json) {
    return SalaryInfoModel(
      salaryType: json['salary_type'] as String? ?? 'hourly',
      salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0.0,
      currencyCode: json['currency_code'] as String? ?? 'VND',
      currencySymbol: json['currency_symbol'] as String? ?? '₫',
    );
  }

  SalaryInfo toEntity() {
    return SalaryInfo(
      salaryType: salaryType,
      salaryAmount: salaryAmount,
      currencyCode: currencyCode,
      currencySymbol: currencySymbol,
    );
  }
}

class PeriodStatsModel {
  final double onTimeRate;
  final int completeShifts;
  final double totalConfirmedHours;
  final double basePay;
  final double bonusPay;
  final double totalPayment;
  final double previousTotalPayment;
  final double changePercentage;

  PeriodStatsModel({
    required this.onTimeRate,
    required this.completeShifts,
    required this.totalConfirmedHours,
    required this.basePay,
    required this.bonusPay,
    required this.totalPayment,
    required this.previousTotalPayment,
    required this.changePercentage,
  });

  factory PeriodStatsModel.fromJson(Map<String, dynamic> json) {
    return PeriodStatsModel(
      onTimeRate: (json['on_time_rate'] as num?)?.toDouble() ?? 0.0,
      completeShifts: (json['complete_shifts'] as num?)?.toInt() ?? 0,
      totalConfirmedHours: (json['total_confirmed_hours'] as num?)?.toDouble() ?? 0.0,
      basePay: (json['base_pay'] as num?)?.toDouble() ?? 0.0,
      bonusPay: (json['bonus_pay'] as num?)?.toDouble() ?? 0.0,
      totalPayment: (json['total_payment'] as num?)?.toDouble() ?? 0.0,
      previousTotalPayment: (json['previous_total_payment'] as num?)?.toDouble() ?? 0.0,
      changePercentage: (json['change_percentage'] as num?)?.toDouble() ?? 0.0,
    );
  }

  PeriodStats toEntity() {
    return PeriodStats(
      onTimeRate: onTimeRate,
      completeShifts: completeShifts,
      totalConfirmedHours: totalConfirmedHours,
      basePay: basePay,
      bonusPay: bonusPay,
      totalPayment: totalPayment,
      previousTotalPayment: previousTotalPayment,
      changePercentage: changePercentage,
    );
  }
}

class WeeklyPaymentsModel {
  final double w1;
  final double w2;
  final double w3;
  final double w4;
  final double w5;

  WeeklyPaymentsModel({
    required this.w1,
    required this.w2,
    required this.w3,
    required this.w4,
    required this.w5,
  });

  factory WeeklyPaymentsModel.fromJson(Map<String, dynamic> json) {
    return WeeklyPaymentsModel(
      w1: (json['w1'] as num?)?.toDouble() ?? 0.0,
      w2: (json['w2'] as num?)?.toDouble() ?? 0.0,
      w3: (json['w3'] as num?)?.toDouble() ?? 0.0,
      w4: (json['w4'] as num?)?.toDouble() ?? 0.0,
      w5: (json['w5'] as num?)?.toDouble() ?? 0.0,
    );
  }

  WeeklyPayments toEntity() {
    return WeeklyPayments(
      w1: w1,
      w2: w2,
      w3: w3,
      w4: w4,
      w5: w5,
    );
  }
}
