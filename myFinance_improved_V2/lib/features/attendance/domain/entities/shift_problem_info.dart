/// ShiftProblemInfo - Problem details for shift card display
///
/// Used by presentation layer to show problem badges.
/// This is a simplified view model derived from domain's ProblemDetails entity.
class ShiftProblemInfo {
  final bool isLate;
  final int lateMinutes;
  final bool isOvertime;
  final int overtimeMinutes;
  final bool hasLocationIssue;
  final int? checkinDistance;
  final bool hasNoCheckout;
  final bool isEarlyLeave;
  final int earlyLeaveMinutes;
  final bool isReported;
  final bool isSolved;
  final int problemCount;

  const ShiftProblemInfo({
    this.isLate = false,
    this.lateMinutes = 0,
    this.isOvertime = false,
    this.overtimeMinutes = 0,
    this.hasLocationIssue = false,
    this.checkinDistance,
    this.hasNoCheckout = false,
    this.isEarlyLeave = false,
    this.earlyLeaveMinutes = 0,
    this.isReported = false,
    this.isSolved = false,
    this.problemCount = 0,
  });

  bool get hasProblem => problemCount > 0;

  /// Create from domain's ProblemDetails entity
  factory ShiftProblemInfo.fromProblemDetails({
    bool? hasLate,
    int? lateMinutes,
    bool? hasOvertime,
    int? overtimeMinutes,
    bool? hasLocationIssue,
    int? checkinDistance,
    bool? hasNoCheckout,
    bool? hasEarlyLeave,
    int? earlyLeaveMinutes,
    bool? hasReported,
    bool? isSolved,
    int? problemCount,
  }) {
    return ShiftProblemInfo(
      isLate: hasLate ?? false,
      lateMinutes: lateMinutes ?? 0,
      isOvertime: hasOvertime ?? false,
      overtimeMinutes: overtimeMinutes ?? 0,
      hasLocationIssue: hasLocationIssue ?? false,
      checkinDistance: checkinDistance,
      hasNoCheckout: hasNoCheckout ?? false,
      isEarlyLeave: hasEarlyLeave ?? false,
      earlyLeaveMinutes: earlyLeaveMinutes ?? 0,
      isReported: hasReported ?? false,
      isSolved: isSolved ?? false,
      problemCount: problemCount ?? 0,
    );
  }
}
