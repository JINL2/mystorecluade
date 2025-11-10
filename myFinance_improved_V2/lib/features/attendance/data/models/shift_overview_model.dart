import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/entities/shift_overview.dart';

part 'shift_overview_model.freezed.dart';

/// Shift Overview Model (DTO)
///
/// Data Transfer Object for ShiftOverview entity.
/// Handles JSON serialization/deserialization.
/// Does NOT extend entity - proper separation of concerns.
@freezed
class ShiftOverviewModel with _$ShiftOverviewModel {
  const ShiftOverviewModel._();

  const factory ShiftOverviewModel({
    required String requestMonth,
    required int actualWorkDays,
    required double actualWorkHours,
    required String estimatedSalary,
    required String currencySymbol,
    required double salaryAmount,
    required String salaryType,
    required int lateDeductionTotal,
    required int overtimeTotal,
  }) = _ShiftOverviewModel;

  /// Create from JSON
  factory ShiftOverviewModel.fromJson(Map<String, dynamic> json) {
    return ShiftOverviewModel(
      requestMonth: json['request_month'] as String? ?? '',
      actualWorkDays: json['actual_work_days'] as int? ?? 0,
      actualWorkHours: (json['actual_work_hours'] as num?)?.toDouble() ?? 0.0,
      estimatedSalary: json['estimated_salary']?.toString() ?? '0',
      currencySymbol: json['currency_symbol'] as String? ?? '₩',
      salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0.0,
      salaryType: json['salary_type'] as String? ?? 'hourly',
      lateDeductionTotal: json['late_deduction_total'] as int? ?? 0,
      overtimeTotal: json['overtime_total'] as int? ?? 0,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
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
    };
  }

  /// Convert Model to Entity (Mapper pattern)
  ShiftOverview toEntity() {
    return ShiftOverview(
      requestMonth: requestMonth,
      actualWorkDays: actualWorkDays,
      actualWorkHours: actualWorkHours,
      estimatedSalary: estimatedSalary,
      currencySymbol: currencySymbol,
      salaryAmount: salaryAmount,
      salaryType: salaryType,
      lateDeductionTotal: lateDeductionTotal,
      overtimeTotal: overtimeTotal,
    );
  }

  /// Create empty model
  static ShiftOverviewModel empty(String month) {
    return ShiftOverviewModel(
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
}
