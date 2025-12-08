// lib/features/report_control/presentation/pages/templates/monthly_salary/domain/entities/monthly_salary_report.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_salary_report.freezed.dart';
part 'monthly_salary_report.g.dart';

/// Monthly Salary Report Data
///
/// Main entity for monthly payroll report.
/// Contains summary, employees with salary info, warnings, and AI insights.
@freezed
class MonthlySalaryReport with _$MonthlySalaryReport {
  const factory MonthlySalaryReport({
    /// Report metadata
    @JsonKey(name: 'report_month') required String reportMonth,
    @JsonKey(name: 'generated_at') String? generatedAt,
    @JsonKey(name: 'currency_symbol') @Default('₫') String currencySymbol,
    @JsonKey(name: 'currency_code') @Default('VND') String currencyCode,

    /// Summary stats
    @JsonKey(name: 'summary') required SalarySummary summary,

    /// Employee list with salary and warnings
    @JsonKey(name: 'employees') @Default([]) List<SalaryEmployee> employees,

    /// Manager quality metrics
    @JsonKey(name: 'manager_quality') ManagerQuality? managerQuality,

    /// Important notices
    @JsonKey(name: 'notices') @Default([]) List<SalaryNotice> notices,

    /// AI-generated insights
    @JsonKey(name: 'ai_insights') required SalaryInsights aiInsights,
  }) = _MonthlySalaryReport;

  factory MonthlySalaryReport.fromJson(Map<String, dynamic> json) =>
      _$MonthlySalaryReportFromJson(json);
}

/// Summary stats for salary report
@freezed
class SalarySummary with _$SalarySummary {
  const factory SalarySummary({
    @JsonKey(name: 'total_payment') @Default(0) double totalPayment,
    @JsonKey(name: 'total_payment_formatted') @Default('') String totalPaymentFormatted,
    @JsonKey(name: 'total_base') @Default(0) double totalBase,
    @JsonKey(name: 'total_bonus') @Default(0) double totalBonus,
    @JsonKey(name: 'total_employees') @Default(0) int totalEmployees,
    @JsonKey(name: 'employees_with_warnings') @Default(0) int employeesWithWarnings,
    @JsonKey(name: 'total_warnings') @Default(0) int totalWarnings,
    @JsonKey(name: 'total_warning_amount') @Default(0) double totalWarningAmount,
    @JsonKey(name: 'total_warning_amount_formatted') @Default('') String totalWarningAmountFormatted,
    @JsonKey(name: 'payroll_status') @Default('normal') String payrollStatus, // normal, warning, critical
  }) = _SalarySummary;

  factory SalarySummary.fromJson(Map<String, dynamic> json) =>
      _$SalarySummaryFromJson(json);
}

/// Employee with salary info
@freezed
class SalaryEmployee with _$SalaryEmployee {
  const factory SalaryEmployee({
    @JsonKey(name: 'employee_name') @Default('') String employeeName,
    @JsonKey(name: 'is_manager') @Default(false) bool isManager,
    @JsonKey(name: 'salary') required EmployeeSalary salary,
    @JsonKey(name: 'bank_info') BankInfo? bankInfo,
    @JsonKey(name: 'has_warnings') @Default(false) bool hasWarnings,
    @JsonKey(name: 'warning_count') @Default(0) int warningCount,
    @JsonKey(name: 'warning_total') @Default(0) double warningTotal,
    @JsonKey(name: 'warning_total_formatted') @Default('') String warningTotalFormatted,
    @JsonKey(name: 'warnings') @Default([]) List<SalaryWarning> warnings,
  }) = _SalaryEmployee;

  factory SalaryEmployee.fromJson(Map<String, dynamic> json) =>
      _$SalaryEmployeeFromJson(json);
}

/// Employee salary details
@freezed
class EmployeeSalary with _$EmployeeSalary {
  const factory EmployeeSalary({
    @JsonKey(name: 'total_payment') @Default(0) double totalPayment,
    @JsonKey(name: 'total_payment_formatted') @Default('') String totalPaymentFormatted,
    @JsonKey(name: 'base_payment') @Default(0) double basePayment,
    @JsonKey(name: 'bonus') @Default(0) double bonus,
    @JsonKey(name: 'total_hours') @Default(0) double totalHours,
    @JsonKey(name: 'shift_count') @Default(0) int shiftCount,
  }) = _EmployeeSalary;

  factory EmployeeSalary.fromJson(Map<String, dynamic> json) =>
      _$EmployeeSalaryFromJson(json);
}

/// Bank account info
@freezed
class BankInfo with _$BankInfo {
  const factory BankInfo({
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'account_number') String? accountNumber,
  }) = _BankInfo;

  factory BankInfo.fromJson(Map<String, dynamic> json) =>
      _$BankInfoFromJson(json);
}

/// Salary warning/issue
@freezed
class SalaryWarning with _$SalaryWarning {
  const factory SalaryWarning({
    @JsonKey(name: 'date') @Default('') String date,
    @JsonKey(name: 'message') @Default('') String message,
    @JsonKey(name: 'amount') @Default(0) double amount,
    @JsonKey(name: 'amount_formatted') @Default('') String amountFormatted,
    @JsonKey(name: 'approved_by') @Default('') String approvedBy,
    @JsonKey(name: 'self_approved') @Default(false) bool selfApproved,
  }) = _SalaryWarning;

  factory SalaryWarning.fromJson(Map<String, dynamic> json) =>
      _$SalaryWarningFromJson(json);
}

/// AI-generated insights for salary report
@freezed
class SalaryInsights with _$SalaryInsights {
  const factory SalaryInsights({
    @Default('') String summary,
    @JsonKey(name: 'attention_required') @Default([]) List<String> attentionRequired,
    @Default([]) List<String> recommendations,
  }) = _SalaryInsights;

  factory SalaryInsights.fromJson(Map<String, dynamic> json) =>
      _$SalaryInsightsFromJson(json);
}

/// Manager quality metrics
@freezed
class ManagerQuality with _$ManagerQuality {
  const factory ManagerQuality({
    @JsonKey(name: 'total_managers') @Default(0) int totalManagers,
    @JsonKey(name: 'managers_with_issues') @Default(0) int managersWithIssues,
    @JsonKey(name: 'self_approval_count') @Default(0) int selfApprovalCount,
    @JsonKey(name: 'quality_score') @Default(0) double qualityScore,
    @JsonKey(name: 'quality_status') @Default('good') String qualityStatus, // good, warning, critical
    @JsonKey(name: 'quality_message') @Default('') String qualityMessage,
  }) = _ManagerQuality;

  factory ManagerQuality.fromJson(Map<String, dynamic> json) =>
      _$ManagerQualityFromJson(json);
}

/// Important notice for salary report
@freezed
class SalaryNotice with _$SalaryNotice {
  const factory SalaryNotice({
    @JsonKey(name: 'type') @Default('info') String type, // info, warning, critical
    @JsonKey(name: 'title') @Default('') String title,
    @JsonKey(name: 'message') @Default('') String message,
    @JsonKey(name: 'employee_name') String? employeeName,
    @JsonKey(name: 'amount') double? amount,
    @JsonKey(name: 'amount_formatted') String? amountFormatted,
  }) = _SalaryNotice;

  factory SalaryNotice.fromJson(Map<String, dynamic> json) =>
      _$SalaryNoticeFromJson(json);
}
