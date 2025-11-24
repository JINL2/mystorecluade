/// Store Salary Entity
///
/// Represents salary information for a specific store.
class StoreSalary {
  final String storeId;
  final String storeName;
  final String estimatedSalary;

  const StoreSalary({
    required this.storeId,
    required this.storeName,
    required this.estimatedSalary,
  });

  Map<String, dynamic> toMap() {
    return {
      'store_id': storeId,
      'store_name': storeName,
      'estimated_salary': estimatedSalary,
    };
  }
}

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
  final List<StoreSalary> salaryStores;

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
    required this.salaryStores,
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
      salaryStores: const [],
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

  /// Convert to Map for backward compatibility with old code
  Map<String, dynamic> toMap() {
    return {
      'request_month': requestMonth,
      'actual_work_days': actualWorkDays,
      'actual_work_hours': actualWorkHours,
      'estimated_salary': estimatedSalary,
      'currency_symbol': currencySymbol,
      'salary_amount': salaryAmount,
      'salary_type': salaryType,
      'late_deduction_total': lateDeductionTotal,
      'overtime_total': overtimeTotal,
      'salary_stores': salaryStores.map((store) => store.toMap()).toList(),
    };
  }

  @override
  String toString() => 'ShiftOverview(month: $requestMonth, days: $actualWorkDays, hours: $actualWorkHours)';
}
