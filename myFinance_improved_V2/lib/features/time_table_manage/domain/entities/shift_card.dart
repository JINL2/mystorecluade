import 'employee_info.dart';
import 'manager_memo.dart';
import 'problem_details.dart';
import 'shift.dart';
import 'tag.dart';

/// Shift Card Entity
///
/// Represents a comprehensive view of a shift assignment with all relevant
/// information including employee, shift details, approval status, and tags.
///
/// v6: BREAKING CHANGE - Removed legacy problem fields.
/// All problem-related data MUST come from [problemDetails] (problem_details_v2).
/// This ensures single source of truth across all pages (Overview, Schedule, Problems, Stats).
///
/// Removed fields (use problemDetails instead):
/// - hasProblem → problemDetails?.problemCount > 0
/// - isProblemSolved → problemDetails?.isSolved
/// - isLate → problemDetails?.problems.any((p) => p.type == 'late')
/// - lateMinute → problemDetails?.problems.firstWhere((p) => p.type == 'late')?.actualMinutes
/// - isOverTime → problemDetails?.problems.any((p) => p.type == 'overtime')
/// - overTimeMinute → problemDetails?.problems.firstWhere((p) => p.type == 'overtime')?.actualMinutes
/// - isReported → problemDetails?.problems.any((p) => p.type == 'reported')
/// - problemType → problemDetails?.problems.map((p) => p.type)
/// - reportReason → problemDetails?.problems.firstWhere((p) => p.type == 'reported')?.reason
/// - isReportedSolved → problemDetails?.problems.firstWhere((p) => p.type == 'reported')?.isSolved
class ShiftCard {
  /// The shift request ID
  final String shiftRequestId;

  /// Employee information
  final EmployeeInfo employee;

  /// Shift information
  final Shift shift;

  /// The actual work date (yyyy-MM-dd format, from start_time_utc)
  final String shiftDate;

  /// Whether the shift is approved
  final bool isApproved;

  /// Paid hours for this shift
  final double paidHour;

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

  /// Manager memos for this shift
  final List<ManagerMemo> managerMemos;

  /// v5: Detailed problem information - SINGLE SOURCE OF TRUTH for all problem data
  /// All pages (Overview, Schedule, Problems, Stats) MUST use this field only.
  final ProblemDetails? problemDetails;

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
    this.paidHour = 0.0,
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
    this.managerMemos = const [],
    this.problemDetails,
    this.shiftStartTime,
    this.shiftEndTime,
    required this.createdAt,
    this.approvedAt,
  });

  // ═══════════════════════════════════════════════════════════════════════════
  // COMPUTED PROPERTIES FROM problemDetails (convenience getters)
  // These replace the removed legacy fields
  // ═══════════════════════════════════════════════════════════════════════════

  /// Check if shift has any problems (from problemDetails)
  bool get hasProblem => problemDetails != null && problemDetails!.problemCount > 0;

  /// Check if all problems are solved (from problemDetails)
  bool get isProblemSolved => problemDetails?.isSolved ?? true;

  /// Check if employee was late (from problemDetails)
  bool get isLate => problemDetails?.problems.any((p) => p.type == 'late' && !p.isSolved) ?? false;

  /// Late duration in minutes (from problemDetails)
  int get lateMinute {
    if (problemDetails == null) return 0;
    final minutes = problemDetails!.problems
        .where((p) => p.type == 'late')
        .map((p) => p.actualMinutes ?? 0);
    return minutes.isEmpty ? 0 : minutes.reduce((a, b) => a > b ? a : b);
  }

  /// Check if employee worked overtime (from problemDetails)
  bool get isOverTime => problemDetails?.problems.any((p) => p.type == 'overtime' && !p.isSolved) ?? false;

  /// Overtime duration in minutes (from problemDetails)
  int get overTimeMinute {
    if (problemDetails == null) return 0;
    final minutes = problemDetails!.problems
        .where((p) => p.type == 'overtime')
        .map((p) => p.actualMinutes ?? 0);
    return minutes.isEmpty ? 0 : minutes.reduce((a, b) => a > b ? a : b);
  }

  /// Check if this shift has been reported (from problemDetails)
  bool get isReported => problemDetails?.problems.any((p) => p.type == 'reported' && !p.isSolved) ?? false;

  /// Report reason if this shift was reported (from problemDetails)
  String? get reportReason => problemDetails?.problems
      .where((p) => p.type == 'reported')
      .map((p) => p.reason)
      .firstOrNull;

  /// Whether the report has been resolved (from problemDetails)
  bool? get isReportedSolved => problemDetails?.problems
      .where((p) => p.type == 'reported')
      .map((p) => p.isSolved)
      .firstOrNull;

  /// Problem types as list (from problemDetails)
  List<String> get problemTypes => problemDetails?.problems
      .where((p) => !p.isSolved)
      .map((p) => p.type)
      .toList() ?? [];

  // ═══════════════════════════════════════════════════════════════════════════
  // OTHER COMPUTED PROPERTIES
  // ═══════════════════════════════════════════════════════════════════════════

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
    double? paidHour,
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
    List<ManagerMemo>? managerMemos,
    ProblemDetails? problemDetails,
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
      paidHour: paidHour ?? this.paidHour,
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
      managerMemos: managerMemos ?? this.managerMemos,
      problemDetails: problemDetails ?? this.problemDetails,
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
