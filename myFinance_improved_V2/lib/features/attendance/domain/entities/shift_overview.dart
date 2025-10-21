/// Shift Overview Entity
///
/// Represents monthly shift statistics for a user.
class ShiftOverview {
  final String requestMonth;
  final int actualWorkDays;
  final double actualWorkHours;
  final String estimatedSalary;
  final String currencySymbol;
  final double salaryAmount;
  final String salaryType;
  final int lateDeductionTotal;
  final int overtimeTotal;

  const ShiftOverview({
    required this.requestMonth,
    required this.actualWorkDays,
    required this.actualWorkHours,
    required this.estimatedSalary,
    required this.currencySymbol,
    required this.salaryAmount,
    required this.salaryType,
    required this.lateDeductionTotal,
    required this.overtimeTotal,
  });

  /// Empty overview with zero values
  static ShiftOverview empty(String month) {
    return ShiftOverview(
      requestMonth: month,
      actualWorkDays: 0,
      actualWorkHours: 0.0,
      estimatedSalary: '0',
      currencySymbol: '₩',
      salaryAmount: 0.0,
      salaryType: 'hourly',
      lateDeductionTotal: 0,
      overtimeTotal: 0,
    );
  }

  /// Check if overview has any work data
  bool get hasWorkData => actualWorkDays > 0 || actualWorkHours > 0;

  /// Format estimated salary with currency symbol
  String get formattedSalary => '$currencySymbol$estimatedSalary';

  /// Average hours per day
  double get averageHoursPerDay {
    if (actualWorkDays == 0) return 0.0;
    return actualWorkHours / actualWorkDays;
  }

  @override
  String toString() => 'ShiftOverview(month: $requestMonth, days: $actualWorkDays, hours: $actualWorkHours)';
}
