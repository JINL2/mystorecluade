import 'employee_info.dart';
import 'manager_memo.dart';
import 'shift.dart';
import 'tag.dart';

/// Shift Card Entity
///
/// Represents a comprehensive view of a shift assignment with all relevant
/// information including employee, shift details, approval status, and tags.
/// v3: Uses shiftDate (actual work date from start_time_utc) instead of requestDate
/// v4: Adds isReportedSolved (bool?), managerMemos (List<ManagerMemo>)
class ShiftCard {
  /// The shift request ID
  final String shiftRequestId;

  /// Employee information
  final EmployeeInfo employee;

  /// Shift information
  final Shift shift;

  /// The actual work date (yyyy-MM-dd format, from start_time_utc)
  /// v3: Renamed from requestDate to shiftDate
  final String shiftDate;

  /// Whether the shift is approved
  final bool isApproved;

  /// Whether there's a problem with this shift
  final bool hasProblem;

  /// Whether the problem has been solved
  final bool isProblemSolved;

  /// Whether the employee was late
  final bool isLate;

  /// Late duration in minutes
  final int lateMinute;

  /// Whether the employee worked overtime
  final bool isOverTime;

  /// Overtime duration in minutes
  final int overTimeMinute;

  /// Paid hours for this shift
  final double paidHour;

  /// Whether this shift has been reported
  final bool isReported;

  /// Bonus amount (if any)
  final double? bonusAmount;

  /// Reason for bonus (if any)
  final String? bonusReason;

  /// Confirmed start time (manager-confirmed start time)
  final DateTime? confirmedStartTime;

  /// Confirmed end time (manager-confirmed end time)
  final DateTime? confirmedEndTime;

  /// Actual start time (employee's actual check-in time from device)
  final DateTime? actualStartTime;

  /// Actual end time (employee's actual check-out time from device)
  final DateTime? actualEndTime;

  /// Check-in location validity
  final bool? isValidCheckinLocation;

  /// Check-in distance from store in meters
  final double? checkinDistanceFromStore;

  /// Check-out location validity
  final bool? isValidCheckoutLocation;

  /// Check-out distance from store in meters
  final double? checkoutDistanceFromStore;

  /// Salary type ('hourly' or 'monthly')
  final String? salaryType;

  /// Salary amount (hourly rate or monthly salary)
  final String? salaryAmount;

  /// Base pay for this shift
  final String? basePay;

  /// Total pay with bonus
  final String? totalPayWithBonus;

  /// Raw time strings from RPC (for display without conversion)
  final String? actualStartRaw;
  final String? actualEndRaw;
  final String? confirmedStartRaw;
  final String? confirmedEndRaw;

  /// List of tags associated with this shift card
  final List<Tag> tags;

  /// Problem type (e.g., "late", "early_checkout", etc.)
  final String? problemType;

  /// Report reason if this shift was reported
  final String? reportReason;

  /// v4: Whether the report has been resolved
  final bool? isReportedSolved;

  /// v4: Manager memos for this shift
  final List<ManagerMemo> managerMemos;

  /// Shift start time from RPC ("2025-12-05 14:00" format)
  /// Used for consecutive shift detection
  final String? shiftStartTime;

  /// Shift end time from RPC ("2025-12-05 14:00" format)
  /// Used for consecutive shift detection
  final String? shiftEndTime;

  /// When the request was created
  final DateTime createdAt;

  /// When the request was approved (if approved)
  final DateTime? approvedAt;

  const ShiftCard({
    required this.shiftRequestId,
    required this.employee,
    required this.shift,
    required this.shiftDate,
    required this.isApproved,
    required this.hasProblem,
    this.isProblemSolved = false,
    this.isLate = false,
    this.lateMinute = 0,
    this.isOverTime = false,
    this.overTimeMinute = 0,
    this.paidHour = 0.0,
    this.isReported = false,
    this.bonusAmount,
    this.bonusReason,
    this.confirmedStartTime,
    this.confirmedEndTime,
    this.actualStartTime,
    this.actualEndTime,
    this.isValidCheckinLocation,
    this.checkinDistanceFromStore,
    this.isValidCheckoutLocation,
    this.checkoutDistanceFromStore,
    this.salaryType,
    this.salaryAmount,
    this.basePay,
    this.totalPayWithBonus,
    this.actualStartRaw,
    this.actualEndRaw,
    this.confirmedStartRaw,
    this.confirmedEndRaw,
    this.tags = const [],
    this.problemType,
    this.reportReason,
    this.isReportedSolved,
    this.managerMemos = const [],
    this.shiftStartTime,
    this.shiftEndTime,
    required this.createdAt,
    this.approvedAt,
  });

  /// Check if shift is pending approval
  bool get isPending => !isApproved;

  /// Check if shift has bonus
  bool get hasBonus => bonusAmount != null && bonusAmount! > 0;

  /// Check if shift has confirmed times
  bool get hasConfirmedTimes =>
      confirmedStartTime != null && confirmedEndTime != null;

  /// Check if shift has tags
  bool get hasTags => tags.isNotEmpty;

  /// Get number of tags
  int get tagsCount => tags.length;

  /// Get bonus tags
  List<Tag> get bonusTags {
    return tags.where((tag) => tag.isBonus).toList();
  }

  /// Get late tags
  List<Tag> get lateTags {
    return tags.where((tag) => tag.isLate).toList();
  }

  /// Copy with method for immutability
  ShiftCard copyWith({
    String? shiftRequestId,
    EmployeeInfo? employee,
    Shift? shift,
    String? shiftDate,
    bool? isApproved,
    bool? hasProblem,
    bool? isProblemSolved,
    bool? isLate,
    int? lateMinute,
    bool? isOverTime,
    int? overTimeMinute,
    double? paidHour,
    bool? isReported,
    double? bonusAmount,
    String? bonusReason,
    DateTime? confirmedStartTime,
    DateTime? confirmedEndTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    bool? isValidCheckinLocation,
    double? checkinDistanceFromStore,
    bool? isValidCheckoutLocation,
    double? checkoutDistanceFromStore,
    String? salaryType,
    String? salaryAmount,
    String? basePay,
    String? totalPayWithBonus,
    String? actualStartRaw,
    String? actualEndRaw,
    String? confirmedStartRaw,
    String? confirmedEndRaw,
    List<Tag>? tags,
    String? problemType,
    String? reportReason,
    bool? isReportedSolved,
    List<ManagerMemo>? managerMemos,
    String? shiftStartTime,
    String? shiftEndTime,
    DateTime? createdAt,
    DateTime? approvedAt,
  }) {
    return ShiftCard(
      shiftRequestId: shiftRequestId ?? this.shiftRequestId,
      employee: employee ?? this.employee,
      shift: shift ?? this.shift,
      shiftDate: shiftDate ?? this.shiftDate,
      isApproved: isApproved ?? this.isApproved,
      hasProblem: hasProblem ?? this.hasProblem,
      isProblemSolved: isProblemSolved ?? this.isProblemSolved,
      isLate: isLate ?? this.isLate,
      lateMinute: lateMinute ?? this.lateMinute,
      isOverTime: isOverTime ?? this.isOverTime,
      overTimeMinute: overTimeMinute ?? this.overTimeMinute,
      paidHour: paidHour ?? this.paidHour,
      isReported: isReported ?? this.isReported,
      bonusAmount: bonusAmount ?? this.bonusAmount,
      bonusReason: bonusReason ?? this.bonusReason,
      confirmedStartTime: confirmedStartTime ?? this.confirmedStartTime,
      confirmedEndTime: confirmedEndTime ?? this.confirmedEndTime,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      isValidCheckinLocation: isValidCheckinLocation ?? this.isValidCheckinLocation,
      checkinDistanceFromStore: checkinDistanceFromStore ?? this.checkinDistanceFromStore,
      isValidCheckoutLocation: isValidCheckoutLocation ?? this.isValidCheckoutLocation,
      checkoutDistanceFromStore: checkoutDistanceFromStore ?? this.checkoutDistanceFromStore,
      salaryType: salaryType ?? this.salaryType,
      salaryAmount: salaryAmount ?? this.salaryAmount,
      basePay: basePay ?? this.basePay,
      totalPayWithBonus: totalPayWithBonus ?? this.totalPayWithBonus,
      actualStartRaw: actualStartRaw ?? this.actualStartRaw,
      actualEndRaw: actualEndRaw ?? this.actualEndRaw,
      confirmedStartRaw: confirmedStartRaw ?? this.confirmedStartRaw,
      confirmedEndRaw: confirmedEndRaw ?? this.confirmedEndRaw,
      tags: tags ?? this.tags,
      problemType: problemType ?? this.problemType,
      reportReason: reportReason ?? this.reportReason,
      isReportedSolved: isReportedSolved ?? this.isReportedSolved,
      managerMemos: managerMemos ?? this.managerMemos,
      shiftStartTime: shiftStartTime ?? this.shiftStartTime,
      shiftEndTime: shiftEndTime ?? this.shiftEndTime,
      createdAt: createdAt ?? this.createdAt,
      approvedAt: approvedAt ?? this.approvedAt,
    );
  }

  @override
  String toString() {
    return 'ShiftCard(id: $shiftRequestId, employee: ${employee.userName}, date: $shiftDate, approved: $isApproved)';
  }
}
