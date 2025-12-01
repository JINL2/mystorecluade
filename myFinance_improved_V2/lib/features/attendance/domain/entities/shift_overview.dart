import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_overview.freezed.dart';

/// Store Salary Entity
///
/// Represents salary information for a specific store.
@freezed
class StoreSalary with _$StoreSalary {
  const factory StoreSalary({
    required String storeId,
    required String storeName,
    required String estimatedSalary,
  }) = _StoreSalary;
}

/// Shift Overview Entity - Pure business object
///
/// Represents monthly shift statistics for a user.
/// Does NOT contain JSON serialization - that's handled by ShiftOverviewModel in Data layer.
@freezed
class ShiftOverview with _$ShiftOverview {
  const ShiftOverview._();

  const factory ShiftOverview({
    required String requestMonth,
    required int actualWorkDays,
    required double actualWorkHours,
    required String estimatedSalary,
    required String currencySymbol,
    required double salaryAmount,
    required String salaryType,
    required int lateDeductionTotal,
    required int overtimeTotal,
    required List<StoreSalary> salaryStores,
  }) = _ShiftOverview;

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

  // ========================================
  // Business Logic Methods
  // ========================================

  /// Check if overview has any work data
  bool get hasWorkData => actualWorkDays > 0 || actualWorkHours > 0;

  /// Format estimated salary with currency symbol
  String get formattedSalary => '$currencySymbol$estimatedSalary';

  /// Average hours per day
  double get averageHoursPerDay {
    if (actualWorkDays == 0) return 0.0;
    return actualWorkHours / actualWorkDays;
  }

  /// Check if user is full-time (>= 30 hours/week average)
  bool get isFullTime => averageHoursPerDay * 7 >= 30;

  /// Check if has overtime
  bool get hasOvertime => overtimeTotal > 0;

  /// Check if has late deductions
  bool get hasLateDeductions => lateDeductionTotal > 0;
}
