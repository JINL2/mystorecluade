// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_salary_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlySalaryReportImpl _$$MonthlySalaryReportImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlySalaryReportImpl(
      reportMonth: json['report_month'] as String,
      generatedAt: json['generated_at'] as String?,
      currencySymbol: json['currency_symbol'] as String? ?? '₫',
      currencyCode: json['currency_code'] as String? ?? 'VND',
      summary: SalarySummary.fromJson(json['summary'] as Map<String, dynamic>),
      employees: (json['employees'] as List<dynamic>?)
              ?.map((e) => SalaryEmployee.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      managerQuality: json['manager_quality'] == null
          ? null
          : ManagerQuality.fromJson(
              json['manager_quality'] as Map<String, dynamic>),
      notices: (json['notices'] as List<dynamic>?)
              ?.map((e) => SalaryNotice.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      aiInsights:
          SalaryInsights.fromJson(json['ai_insights'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$MonthlySalaryReportImplToJson(
        _$MonthlySalaryReportImpl instance) =>
    <String, dynamic>{
      'report_month': instance.reportMonth,
      'generated_at': instance.generatedAt,
      'currency_symbol': instance.currencySymbol,
      'currency_code': instance.currencyCode,
      'summary': instance.summary,
      'employees': instance.employees,
      'manager_quality': instance.managerQuality,
      'notices': instance.notices,
      'ai_insights': instance.aiInsights,
    };

_$SalarySummaryImpl _$$SalarySummaryImplFromJson(Map<String, dynamic> json) =>
    _$SalarySummaryImpl(
      totalPayment: (json['total_payment'] as num?)?.toDouble() ?? 0,
      totalPaymentFormatted: json['total_payment_formatted'] as String? ?? '',
      totalBase: (json['total_base'] as num?)?.toDouble() ?? 0,
      totalBonus: (json['total_bonus'] as num?)?.toDouble() ?? 0,
      totalEmployees: (json['total_employees'] as num?)?.toInt() ?? 0,
      employeesWithWarnings:
          (json['employees_with_warnings'] as num?)?.toInt() ?? 0,
      totalWarnings: (json['total_warnings'] as num?)?.toInt() ?? 0,
      totalWarningAmount:
          (json['total_warning_amount'] as num?)?.toDouble() ?? 0,
      totalWarningAmountFormatted:
          json['total_warning_amount_formatted'] as String? ?? '',
      payrollStatus: json['payroll_status'] as String? ?? 'normal',
    );

Map<String, dynamic> _$$SalarySummaryImplToJson(_$SalarySummaryImpl instance) =>
    <String, dynamic>{
      'total_payment': instance.totalPayment,
      'total_payment_formatted': instance.totalPaymentFormatted,
      'total_base': instance.totalBase,
      'total_bonus': instance.totalBonus,
      'total_employees': instance.totalEmployees,
      'employees_with_warnings': instance.employeesWithWarnings,
      'total_warnings': instance.totalWarnings,
      'total_warning_amount': instance.totalWarningAmount,
      'total_warning_amount_formatted': instance.totalWarningAmountFormatted,
      'payroll_status': instance.payrollStatus,
    };

_$SalaryEmployeeImpl _$$SalaryEmployeeImplFromJson(Map<String, dynamic> json) =>
    _$SalaryEmployeeImpl(
      employeeName: json['employee_name'] as String? ?? '',
      isManager: json['is_manager'] as bool? ?? false,
      salary: EmployeeSalary.fromJson(json['salary'] as Map<String, dynamic>),
      bankInfo: json['bank_info'] == null
          ? null
          : BankInfo.fromJson(json['bank_info'] as Map<String, dynamic>),
      hasWarnings: json['has_warnings'] as bool? ?? false,
      warningCount: (json['warning_count'] as num?)?.toInt() ?? 0,
      warningTotal: (json['warning_total'] as num?)?.toDouble() ?? 0,
      warningTotalFormatted: json['warning_total_formatted'] as String? ?? '',
      warnings: (json['warnings'] as List<dynamic>?)
              ?.map((e) => SalaryWarning.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SalaryEmployeeImplToJson(
        _$SalaryEmployeeImpl instance) =>
    <String, dynamic>{
      'employee_name': instance.employeeName,
      'is_manager': instance.isManager,
      'salary': instance.salary,
      'bank_info': instance.bankInfo,
      'has_warnings': instance.hasWarnings,
      'warning_count': instance.warningCount,
      'warning_total': instance.warningTotal,
      'warning_total_formatted': instance.warningTotalFormatted,
      'warnings': instance.warnings,
    };

_$EmployeeSalaryImpl _$$EmployeeSalaryImplFromJson(Map<String, dynamic> json) =>
    _$EmployeeSalaryImpl(
      totalPayment: (json['total_payment'] as num?)?.toDouble() ?? 0,
      totalPaymentFormatted: json['total_payment_formatted'] as String? ?? '',
      basePayment: (json['base_payment'] as num?)?.toDouble() ?? 0,
      bonus: (json['bonus'] as num?)?.toDouble() ?? 0,
      totalHours: (json['total_hours'] as num?)?.toDouble() ?? 0,
      shiftCount: (json['shift_count'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$EmployeeSalaryImplToJson(
        _$EmployeeSalaryImpl instance) =>
    <String, dynamic>{
      'total_payment': instance.totalPayment,
      'total_payment_formatted': instance.totalPaymentFormatted,
      'base_payment': instance.basePayment,
      'bonus': instance.bonus,
      'total_hours': instance.totalHours,
      'shift_count': instance.shiftCount,
    };

_$BankInfoImpl _$$BankInfoImplFromJson(Map<String, dynamic> json) =>
    _$BankInfoImpl(
      bankName: json['bank_name'] as String?,
      accountNumber: json['account_number'] as String?,
    );

Map<String, dynamic> _$$BankInfoImplToJson(_$BankInfoImpl instance) =>
    <String, dynamic>{
      'bank_name': instance.bankName,
      'account_number': instance.accountNumber,
    };

_$SalaryWarningImpl _$$SalaryWarningImplFromJson(Map<String, dynamic> json) =>
    _$SalaryWarningImpl(
      date: json['date'] as String? ?? '',
      message: json['message'] as String? ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      amountFormatted: json['amount_formatted'] as String? ?? '',
      approvedBy: json['approved_by'] as String? ?? '',
      selfApproved: json['self_approved'] as bool? ?? false,
    );

Map<String, dynamic> _$$SalaryWarningImplToJson(_$SalaryWarningImpl instance) =>
    <String, dynamic>{
      'date': instance.date,
      'message': instance.message,
      'amount': instance.amount,
      'amount_formatted': instance.amountFormatted,
      'approved_by': instance.approvedBy,
      'self_approved': instance.selfApproved,
    };

_$SalaryInsightsImpl _$$SalaryInsightsImplFromJson(Map<String, dynamic> json) =>
    _$SalaryInsightsImpl(
      summary: json['summary'] as String? ?? '',
      attentionRequired: (json['attention_required'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      recommendations: (json['recommendations'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$SalaryInsightsImplToJson(
        _$SalaryInsightsImpl instance) =>
    <String, dynamic>{
      'summary': instance.summary,
      'attention_required': instance.attentionRequired,
      'recommendations': instance.recommendations,
    };

_$ManagerQualityImpl _$$ManagerQualityImplFromJson(Map<String, dynamic> json) =>
    _$ManagerQualityImpl(
      totalManagers: (json['total_managers'] as num?)?.toInt() ?? 0,
      managersWithIssues: (json['managers_with_issues'] as num?)?.toInt() ?? 0,
      selfApprovalCount: (json['self_approval_count'] as num?)?.toInt() ?? 0,
      qualityScore: (json['quality_score'] as num?)?.toDouble() ?? 0,
      qualityStatus: json['quality_status'] as String? ?? 'good',
      qualityMessage: json['quality_message'] as String? ?? '',
    );

Map<String, dynamic> _$$ManagerQualityImplToJson(
        _$ManagerQualityImpl instance) =>
    <String, dynamic>{
      'total_managers': instance.totalManagers,
      'managers_with_issues': instance.managersWithIssues,
      'self_approval_count': instance.selfApprovalCount,
      'quality_score': instance.qualityScore,
      'quality_status': instance.qualityStatus,
      'quality_message': instance.qualityMessage,
    };

_$SalaryNoticeImpl _$$SalaryNoticeImplFromJson(Map<String, dynamic> json) =>
    _$SalaryNoticeImpl(
      type: json['type'] as String? ?? 'info',
      title: json['title'] as String? ?? '',
      message: json['message'] as String? ?? '',
      employeeName: json['employee_name'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      amountFormatted: json['amount_formatted'] as String?,
    );

Map<String, dynamic> _$$SalaryNoticeImplToJson(_$SalaryNoticeImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'title': instance.title,
      'message': instance.message,
      'employee_name': instance.employeeName,
      'amount': instance.amount,
      'amount_formatted': instance.amountFormatted,
    };
