/// Domain Entity: Employee Monthly Detail
///
/// Contains all data for an employee's monthly detail page:
/// - User info
/// - Shifts (Attendance History)
/// - Audit logs (Recent Activity)
/// - Summary statistics
/// - Salary info

// ============================================================================
// Main Entity
// ============================================================================

class EmployeeMonthlyDetail {
  final bool success;
  final EmployeeMonthlyUser? user;
  final EmployeeMonthlyPeriod period;
  final List<EmployeeShiftRecord> shifts;
  final List<EmployeeAuditLog> auditLogs;
  final EmployeeMonthlySummary summary;
  final EmployeeSalaryInfo? salary;

  const EmployeeMonthlyDetail({
    required this.success,
    this.user,
    required this.period,
    required this.shifts,
    required this.auditLogs,
    required this.summary,
    this.salary,
  });

  /// Get shifts filtered by status
  List<EmployeeShiftRecord> getShiftsByFilter(ShiftFilterType filter) {
    switch (filter) {
      case ShiftFilterType.unresolved:
        return shifts
            .where((s) => s.isProblem && !s.isProblemSolved)
            .toList();
      case ShiftFilterType.resolved:
        return shifts.where((s) => s.isProblemSolved).toList();
      case ShiftFilterType.all:
        // Only show approved shifts
        return shifts.where((s) => s.isApproved).toList();
    }
  }
}

enum ShiftFilterType { unresolved, resolved, all }

// ============================================================================
// User Info
// ============================================================================

class EmployeeMonthlyUser {
  final String userId;
  final String fullName;
  final String? email;
  final String? profileImage;

  const EmployeeMonthlyUser({
    required this.userId,
    required this.fullName,
    this.email,
    this.profileImage,
  });
}

// ============================================================================
// Period Info
// ============================================================================

class EmployeeMonthlyPeriod {
  final String yearMonth;
  final DateTime startDate;
  final DateTime endDate;
  final String timezone;

  const EmployeeMonthlyPeriod({
    required this.yearMonth,
    required this.startDate,
    required this.endDate,
    required this.timezone,
  });

  String get displayRange {
    final monthName = _getMonthName(startDate.month);
    return '$monthName/${startDate.day} to $monthName/${endDate.day}';
  }

  String _getMonthName(int month) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[month - 1];
  }
}

// ============================================================================
// Shift Record (for Attendance History)
// ============================================================================

class EmployeeShiftRecord {
  final String shiftRequestId;
  final String shiftId;
  final String storeId;
  final String? storeName;
  final String? shiftName;

  // Date info
  final DateTime? requestDate;
  final DateTime? workDate;
  final int? dayOfMonth;

  // Scheduled times
  final String? scheduledStart;
  final String? scheduledEnd;

  // Actual times
  final String? actualStart;
  final String? actualEnd;

  // Confirmed times
  final String? confirmStart;
  final String? confirmEnd;

  // Status flags
  final bool isApproved;
  final bool isLate;
  final bool isOvertime;
  final bool isProblem;
  final bool isProblemSolved;
  final bool isReported;
  final bool isReportedSolved;

  // Problem details
  final String? problemType;
  final String? reportReason;

  // Financial
  final double bonusAmount;
  final double overtimeAmount;
  final double lateDeductAmount;

  // Calculated
  final double? workedHours;
  final ShiftIssueType? issueType;

  // Tags and memos
  final dynamic noticeTag;
  final dynamic managerMemo;

  // Timestamps
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const EmployeeShiftRecord({
    required this.shiftRequestId,
    required this.shiftId,
    required this.storeId,
    this.storeName,
    this.shiftName,
    this.requestDate,
    this.workDate,
    this.dayOfMonth,
    this.scheduledStart,
    this.scheduledEnd,
    this.actualStart,
    this.actualEnd,
    this.confirmStart,
    this.confirmEnd,
    this.isApproved = false,
    this.isLate = false,
    this.isOvertime = false,
    this.isProblem = false,
    this.isProblemSolved = false,
    this.isReported = false,
    this.isReportedSolved = false,
    this.problemType,
    this.reportReason,
    this.bonusAmount = 0,
    this.overtimeAmount = 0,
    this.lateDeductAmount = 0,
    this.workedHours,
    this.issueType,
    this.noticeTag,
    this.managerMemo,
    this.createdAt,
    this.updatedAt,
  });

  /// Get display time for clock in (actual or confirmed)
  String get displayClockIn {
    return actualStart ?? confirmStart ?? '--:--';
  }

  /// Get display time for clock out (actual or confirmed)
  String get displayClockOut {
    return actualEnd ?? confirmEnd ?? '--:--';
  }

  /// Check if needs confirmation
  bool get needsConfirm => !isApproved;

  /// Check if has missing check-in
  bool get hasMissingCheckIn => actualStart == null && actualEnd != null;

  /// Check if has missing check-out
  bool get hasMissingCheckOut => actualStart != null && actualEnd == null;
}

enum ShiftIssueType {
  noCheckIn,
  noCheckOut,
  late,
  overtime,
  earlyCheckOut,
}

extension ShiftIssueTypeExtension on ShiftIssueType {
  String get label {
    switch (this) {
      case ShiftIssueType.noCheckIn:
        return 'No check-in';
      case ShiftIssueType.noCheckOut:
        return 'No check-out';
      case ShiftIssueType.late:
        return 'Late';
      case ShiftIssueType.overtime:
        return 'OT';
      case ShiftIssueType.earlyCheckOut:
        return 'Early check-out';
    }
  }

  static ShiftIssueType? fromString(String? value) {
    switch (value) {
      case 'no_check_in':
        return ShiftIssueType.noCheckIn;
      case 'no_check_out':
        return ShiftIssueType.noCheckOut;
      case 'late':
        return ShiftIssueType.late;
      case 'overtime':
        return ShiftIssueType.overtime;
      case 'early_check_out':
        return ShiftIssueType.earlyCheckOut;
      default:
        return null;
    }
  }
}

// ============================================================================
// Audit Log (for Recent Activity)
// ============================================================================

class EmployeeAuditLog {
  final String auditId;
  final String shiftRequestId;
  final String operation;
  final AuditActionType actionType;
  final List<String>? changedColumns;
  final String? changedBy;
  final String? changedByName;
  final DateTime changedAt;
  final String? reason;
  final String? storeName;
  final DateTime? workDate;

  const EmployeeAuditLog({
    required this.auditId,
    required this.shiftRequestId,
    required this.operation,
    required this.actionType,
    this.changedColumns,
    this.changedBy,
    this.changedByName,
    required this.changedAt,
    this.reason,
    this.storeName,
    this.workDate,
  });

  /// Get relative time string (e.g., "2h ago", "3d ago")
  String get relativeTime {
    final now = DateTime.now();
    final diff = now.difference(changedAt);

    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}

enum AuditActionType {
  scheduleCreated,
  scheduleDeleted,
  approvalChanged,
  checkIn,
  checkOut,
  timeConfirmed,
  problemResolved,
  reportResolved,
  bonusUpdated,
  memoAdded,
  updated,
}

extension AuditActionTypeExtension on AuditActionType {
  String get label {
    switch (this) {
      case AuditActionType.scheduleCreated:
        return 'Schedule Created';
      case AuditActionType.scheduleDeleted:
        return 'Schedule Deleted';
      case AuditActionType.approvalChanged:
        return 'Approval Changed';
      case AuditActionType.checkIn:
        return 'Check In';
      case AuditActionType.checkOut:
        return 'Check Out';
      case AuditActionType.timeConfirmed:
        return 'Time Confirmed';
      case AuditActionType.problemResolved:
        return 'Problem Resolved';
      case AuditActionType.reportResolved:
        return 'Report Resolved';
      case AuditActionType.bonusUpdated:
        return 'Bonus Updated';
      case AuditActionType.memoAdded:
        return 'Memo Added';
      case AuditActionType.updated:
        return 'Updated';
    }
  }

  static AuditActionType fromString(String? value) {
    switch (value) {
      case 'SCHEDULE_CREATED':
        return AuditActionType.scheduleCreated;
      case 'SCHEDULE_DELETED':
        return AuditActionType.scheduleDeleted;
      case 'APPROVAL_CHANGED':
        return AuditActionType.approvalChanged;
      case 'CHECK_IN':
        return AuditActionType.checkIn;
      case 'CHECK_OUT':
        return AuditActionType.checkOut;
      case 'TIME_CONFIRMED':
        return AuditActionType.timeConfirmed;
      case 'PROBLEM_RESOLVED':
        return AuditActionType.problemResolved;
      case 'REPORT_RESOLVED':
        return AuditActionType.reportResolved;
      case 'BONUS_UPDATED':
        return AuditActionType.bonusUpdated;
      case 'MEMO_ADDED':
        return AuditActionType.memoAdded;
      default:
        return AuditActionType.updated;
    }
  }
}

// ============================================================================
// Summary Statistics
// ============================================================================

class EmployeeMonthlySummary {
  final int totalShifts;
  final int unresolvedCount;
  final int resolvedCount;
  final int approvedCount;
  final int pendingApprovalCount;
  final int lateCount;
  final int overtimeCount;
  final int noCheckInCount;
  final int noCheckOutCount;
  final double totalWorkedHours;
  final double totalBonus;
  final double totalOvertimePay;
  final double totalLateDeduction;
  // New fields from RPC (calculated in v_shift_request view)
  final double totalBasePay;
  final double totalPayment;

  const EmployeeMonthlySummary({
    this.totalShifts = 0,
    this.unresolvedCount = 0,
    this.resolvedCount = 0,
    this.approvedCount = 0,
    this.pendingApprovalCount = 0,
    this.lateCount = 0,
    this.overtimeCount = 0,
    this.noCheckInCount = 0,
    this.noCheckOutCount = 0,
    this.totalWorkedHours = 0,
    this.totalBonus = 0,
    this.totalOvertimePay = 0,
    this.totalLateDeduction = 0,
    this.totalBasePay = 0,
    this.totalPayment = 0,
  });

  /// Format worked hours as "XXXh XXm"
  String get formattedWorkedHours {
    final hours = totalWorkedHours.floor();
    final minutes = ((totalWorkedHours - hours) * 60).round();
    return '${hours}h ${minutes}m';
  }
}

// ============================================================================
// Salary Info
// ============================================================================

class EmployeeSalaryInfo {
  final String salaryType; // 'hourly' or 'monthly'
  final double salaryAmount;
  final double bonusAmount;
  final String? currencyCode;
  final String? currencySymbol;

  const EmployeeSalaryInfo({
    required this.salaryType,
    required this.salaryAmount,
    this.bonusAmount = 0,
    this.currencyCode,
    this.currencySymbol,
  });

  bool get isHourly => salaryType == 'hourly';

  /// Calculate base pay from worked hours (for hourly salary)
  double calculateBasePay(double workedHours) {
    if (isHourly) {
      return workedHours * salaryAmount;
    }
    return salaryAmount;
  }
}
