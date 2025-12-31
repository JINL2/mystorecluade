import 'problem_details.dart';

/// Problem types for attendance tracking
enum ProblemType {
  noCheckout,
  noCheckin,
  overtime,
  late,
  understaffed,
  reported, // Staff reported an issue
  earlyLeave, // Left before shift end
}

/// Model for attendance problem
class AttendanceProblem {
  final String id;
  /// @deprecated Use [types] instead. Kept for backward compatibility.
  final ProblemType type;
  /// List of problem types for this shift (e.g., [late, noCheckout])
  final List<ProblemType> types;
  final String name; // Staff name or "Evening Shift"
  final DateTime date;
  final String shiftName; // "Morning", "Afternoon", "Night"
  final String? timeRange; // For shift problems (e.g., "18:00 - 22:00")
  final String? avatarUrl; // For staff problems
  final bool isShiftProblem; // True if understaffed, false if staff problem

  // Staff-specific fields for navigation to detail page
  final String? staffId;
  final String? shiftRequestId; // Required for RPC calls (manager_shift_input_card_v4)
  final String? clockIn;
  final String? clockOut;
  final bool isLate;
  final bool isOvertime;
  final bool isConfirmed;
  final String? actualStart;
  final String? actualEnd;
  final String? confirmStartTime;
  final String? confirmEndTime;
  final bool isReported;
  final String? reportReason;
  final bool isProblemSolved;
  final double bonusAmount;
  final String? salaryType;
  final String? salaryAmount;
  final String? basePay;
  final String? totalPayWithBonus;
  final double paidHour;
  final int lateMinute;
  final int overtimeMinute;
  final DateTime? shiftEndTime;

  // v5: Problem details for passing to StaffTimeRecord
  final ProblemDetails? problemDetails;

  const AttendanceProblem({
    required this.id,
    required this.type,
    this.types = const [],
    required this.name,
    required this.date,
    required this.shiftName,
    this.timeRange,
    this.avatarUrl,
    this.isShiftProblem = false,
    // Staff-specific fields
    this.staffId,
    this.shiftRequestId,
    this.clockIn,
    this.clockOut,
    this.isLate = false,
    this.isOvertime = false,
    this.isConfirmed = false,
    this.actualStart,
    this.actualEnd,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isReported = false,
    this.reportReason,
    this.isProblemSolved = false,
    this.bonusAmount = 0.0,
    this.salaryType,
    this.salaryAmount,
    this.basePay,
    this.totalPayWithBonus,
    this.paidHour = 0.0,
    this.lateMinute = 0,
    this.overtimeMinute = 0,
    this.shiftEndTime,
    this.problemDetails,
  });

  /// Get all problem types (uses types if not empty, otherwise falls back to single type)
  List<ProblemType> get allTypes => types.isNotEmpty ? types : [type];

  /// Check if shift is still in progress (current time < shift end time)
  bool get isInProgress {
    if (shiftEndTime == null) return false;
    final now = DateTime.now().toUtc();
    return now.isBefore(shiftEndTime!);
  }

  /// Get filtered problem types - exclude "in progress" problems
  /// For shifts still in progress:
  /// - Hide noCheckout (shift hasn't ended yet)
  /// - Hide noCheckin (if shift hasn't started, it's not absence yet)
  List<ProblemType> get filteredTypes {
    if (!isInProgress) return allTypes;

    return allTypes.where((type) {
      // Filter out premature problem types for in-progress shifts
      if (type == ProblemType.noCheckout) return false;
      if (type == ProblemType.noCheckin) return false;
      return true;
    }).toList();
  }

  /// Check if this problem should be shown
  /// Returns false if all problem types are filtered out (in-progress shift)
  bool get shouldShow => filteredTypes.isNotEmpty;
}
