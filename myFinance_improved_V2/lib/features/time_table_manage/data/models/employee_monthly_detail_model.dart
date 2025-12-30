import '../../domain/entities/employee_monthly_detail.dart';

/// Data Model: Employee Monthly Detail Model
///
/// DTO for parsing the JSON response from get_employee_monthly_detail_log RPC.
class EmployeeMonthlyDetailModel extends EmployeeMonthlyDetail {
  const EmployeeMonthlyDetailModel({
    required super.success,
    super.user,
    required super.period,
    required super.shifts,
    required super.auditLogs,
    required super.summary,
    super.salary,
  });

  /// Create model from JSON (Supabase RPC response)
  factory EmployeeMonthlyDetailModel.fromJson(Map<String, dynamic> json) {
    return EmployeeMonthlyDetailModel(
      success: json['success'] as bool? ?? false,
      user: json['user'] != null
          ? EmployeeMonthlyUserModel.fromJson(
              json['user'] as Map<String, dynamic>)
          : null,
      period: EmployeeMonthlyPeriodModel.fromJson(
          json['period'] as Map<String, dynamic>),
      shifts: (json['shifts'] as List<dynamic>? ?? [])
          .map((e) =>
              EmployeeShiftRecordModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      auditLogs: (json['audit_logs'] as List<dynamic>? ?? [])
          .map((e) => EmployeeAuditLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: EmployeeMonthlySummaryModel.fromJson(
          json['summary'] as Map<String, dynamic>? ?? {}),
      salary: json['salary'] != null
          ? EmployeeSalaryInfoModel.fromJson(
              json['salary'] as Map<String, dynamic>)
          : null,
    );
  }

  /// Create empty model for error cases
  factory EmployeeMonthlyDetailModel.empty(String yearMonth) {
    final now = DateTime.now();
    return EmployeeMonthlyDetailModel(
      success: false,
      period: EmployeeMonthlyPeriod(
        yearMonth: yearMonth,
        startDate: DateTime(now.year, now.month, 1),
        endDate: DateTime(now.year, now.month + 1, 0),
        timezone: 'Asia/Ho_Chi_Minh',
      ),
      shifts: const [],
      auditLogs: const [],
      summary: const EmployeeMonthlySummary(),
    );
  }
}

// ============================================================================
// User Model
// ============================================================================

class EmployeeMonthlyUserModel extends EmployeeMonthlyUser {
  const EmployeeMonthlyUserModel({
    required super.userId,
    required super.fullName,
    super.email,
    super.profileImage,
  });

  factory EmployeeMonthlyUserModel.fromJson(Map<String, dynamic> json) {
    return EmployeeMonthlyUserModel(
      userId: json['user_id'] as String? ?? '',
      fullName: json['full_name'] as String? ?? 'Unknown',
      email: json['email'] as String?,
      profileImage: json['profile_image'] as String?,
    );
  }
}

// ============================================================================
// Period Model
// ============================================================================

class EmployeeMonthlyPeriodModel extends EmployeeMonthlyPeriod {
  const EmployeeMonthlyPeriodModel({
    required super.yearMonth,
    required super.startDate,
    required super.endDate,
    required super.timezone,
  });

  factory EmployeeMonthlyPeriodModel.fromJson(Map<String, dynamic> json) {
    return EmployeeMonthlyPeriodModel(
      yearMonth: json['year_month'] as String? ?? '',
      startDate: _parseDate(json['start_date']),
      endDate: _parseDate(json['end_date']),
      timezone: json['timezone'] as String? ?? 'Asia/Ho_Chi_Minh',
    );
  }

  static DateTime _parseDate(dynamic value) {
    if (value == null) return DateTime.now();
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString()) ?? DateTime.now();
  }
}

// ============================================================================
// Shift Record Model
// ============================================================================

class EmployeeShiftRecordModel extends EmployeeShiftRecord {
  const EmployeeShiftRecordModel({
    required super.shiftRequestId,
    required super.shiftId,
    required super.storeId,
    super.storeName,
    super.shiftName,
    super.requestDate,
    super.workDate,
    super.dayOfMonth,
    super.scheduledStart,
    super.scheduledEnd,
    super.actualStart,
    super.actualEnd,
    super.confirmStart,
    super.confirmEnd,
    super.isApproved,
    super.isLate,
    super.isOvertime,
    super.isProblem,
    super.isProblemSolved,
    super.isReported,
    super.isReportedSolved,
    super.problemType,
    super.reportReason,
    super.bonusAmount,
    super.overtimeAmount,
    super.lateDeductAmount,
    super.workedHours,
    super.issueType,
    super.noticeTag,
    super.managerMemo,
    super.createdAt,
    super.updatedAt,
  });

  factory EmployeeShiftRecordModel.fromJson(Map<String, dynamic> json) {
    return EmployeeShiftRecordModel(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      shiftId: json['shift_id'] as String? ?? '',
      storeId: json['store_id'] as String? ?? '',
      storeName: json['store_name'] as String?,
      shiftName: json['shift_name'] as String?,
      requestDate: _parseDate(json['request_date']),
      workDate: _parseDate(json['work_date']),
      dayOfMonth: (json['day_of_month'] as num?)?.toInt(),
      scheduledStart: json['scheduled_start'] as String?,
      scheduledEnd: json['scheduled_end'] as String?,
      actualStart: json['actual_start'] as String?,
      actualEnd: json['actual_end'] as String?,
      confirmStart: json['confirm_start'] as String?,
      confirmEnd: json['confirm_end'] as String?,
      isApproved: json['is_approved'] as bool? ?? false,
      isLate: json['is_late'] as bool? ?? false,
      isOvertime: json['is_overtime'] as bool? ?? false,
      isProblem: json['is_problem'] as bool? ?? false,
      isProblemSolved: json['is_problem_solved'] as bool? ?? false,
      isReported: json['is_reported'] as bool? ?? false,
      isReportedSolved: json['is_reported_solved'] as bool? ?? false,
      problemType: json['problem_type'] as String?,
      reportReason: json['report_reason'] as String?,
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble() ?? 0,
      overtimeAmount: (json['overtime_amount'] as num?)?.toDouble() ?? 0,
      lateDeductAmount: (json['late_deduct_amount'] as num?)?.toDouble() ?? 0,
      workedHours: (json['worked_hours'] as num?)?.toDouble(),
      issueType: ShiftIssueTypeExtension.fromString(json['issue_type'] as String?),
      noticeTag: json['notice_tag'],
      managerMemo: json['manager_memo'],
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }
}

// ============================================================================
// Audit Log Model
// ============================================================================

class EmployeeAuditLogModel extends EmployeeAuditLog {
  const EmployeeAuditLogModel({
    required super.auditId,
    required super.shiftRequestId,
    required super.operation,
    required super.actionType,
    super.changedColumns,
    super.changedBy,
    super.changedByName,
    required super.changedAt,
    super.reason,
    super.storeName,
    super.workDate,
  });

  factory EmployeeAuditLogModel.fromJson(Map<String, dynamic> json) {
    // Parse changed_columns which comes as List<dynamic> from Supabase
    List<String>? changedColumns;
    if (json['changed_columns'] != null) {
      changedColumns = (json['changed_columns'] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
    }

    return EmployeeAuditLogModel(
      auditId: json['audit_id'] as String? ?? '',
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      operation: json['operation'] as String? ?? 'UPDATE',
      actionType: AuditActionTypeExtension.fromString(
          json['action_type'] as String?),
      changedColumns: changedColumns,
      changedBy: json['changed_by'] as String?,
      changedByName: json['changed_by_name'] as String?,
      changedAt: _parseDateTime(json['changed_at']) ?? DateTime.now(),
      reason: json['reason'] as String?,
      storeName: json['store_name'] as String?,
      workDate: _parseDate(json['work_date']),
    );
  }

  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString())?.toLocal();
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    return DateTime.tryParse(value.toString());
  }
}

// ============================================================================
// Summary Model
// ============================================================================

class EmployeeMonthlySummaryModel extends EmployeeMonthlySummary {
  const EmployeeMonthlySummaryModel({
    super.totalShifts,
    super.unresolvedCount,
    super.resolvedCount,
    super.approvedCount,
    super.pendingApprovalCount,
    super.lateCount,
    super.overtimeCount,
    super.noCheckInCount,
    super.noCheckOutCount,
    super.totalWorkedHours,
    super.totalBonus,
    super.totalOvertimePay,
    super.totalLateDeduction,
    super.totalBasePay,
    super.totalPayment,
  });

  factory EmployeeMonthlySummaryModel.fromJson(Map<String, dynamic> json) {
    return EmployeeMonthlySummaryModel(
      totalShifts: (json['total_shifts'] as num?)?.toInt() ?? 0,
      unresolvedCount: (json['unresolved_count'] as num?)?.toInt() ?? 0,
      resolvedCount: (json['resolved_count'] as num?)?.toInt() ?? 0,
      approvedCount: (json['approved_count'] as num?)?.toInt() ?? 0,
      pendingApprovalCount:
          (json['pending_approval_count'] as num?)?.toInt() ?? 0,
      lateCount: (json['late_count'] as num?)?.toInt() ?? 0,
      overtimeCount: (json['overtime_count'] as num?)?.toInt() ?? 0,
      noCheckInCount: (json['no_check_in_count'] as num?)?.toInt() ?? 0,
      noCheckOutCount: (json['no_check_out_count'] as num?)?.toInt() ?? 0,
      totalWorkedHours: (json['total_worked_hours'] as num?)?.toDouble() ?? 0,
      totalBonus: (json['total_bonus'] as num?)?.toDouble() ?? 0,
      totalOvertimePay: (json['total_overtime_pay'] as num?)?.toDouble() ?? 0,
      totalLateDeduction:
          (json['total_late_deduction'] as num?)?.toDouble() ?? 0,
      // New fields from RPC (calculated in v_shift_request view)
      totalBasePay: (json['total_base_pay'] as num?)?.toDouble() ?? 0,
      totalPayment: (json['total_payment'] as num?)?.toDouble() ?? 0,
    );
  }
}

// ============================================================================
// Salary Info Model
// ============================================================================

class EmployeeSalaryInfoModel extends EmployeeSalaryInfo {
  const EmployeeSalaryInfoModel({
    required super.salaryType,
    required super.salaryAmount,
    super.bonusAmount,
    super.currencyCode,
    super.currencySymbol,
  });

  factory EmployeeSalaryInfoModel.fromJson(Map<String, dynamic> json) {
    return EmployeeSalaryInfoModel(
      salaryType: json['salary_type'] as String? ?? 'hourly',
      salaryAmount: (json['salary_amount'] as num?)?.toDouble() ?? 0,
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble() ?? 0,
      currencyCode: json['currency_code'] as String?,
      currencySymbol: json['currency_symbol'] as String?,
    );
  }
}
