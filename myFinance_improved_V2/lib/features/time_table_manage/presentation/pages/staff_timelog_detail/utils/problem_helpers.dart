/// Problem detection helpers for staff timelog detail page
///
/// Provides utilities to check problem status for check-in/check-out times.
library;

import '../../../widgets/timesheets/staff_timelog_card.dart';

/// Problem types related to check-in
const checkInProblemTypes = {'late', 'invalid_checkin'};

/// Problem types related to check-out
const checkOutProblemTypes = {
  'overtime',
  'early_leave',
  'no_checkout',
  'absence',
  'location_issue',
};

/// Extension methods for StaffTimeRecord problem detection
extension StaffTimeRecordProblemX on StaffTimeRecord {
  /// Check if there's a check-in related problem
  bool get hasCheckInProblem {
    final pd = problemDetails;
    if (pd == null) return isLate;
    return pd.hasLate || pd.problems.any((p) => p.type == 'invalid_checkin');
  }

  /// Check if there's a check-out related problem
  bool get hasCheckOutProblem {
    final pd = problemDetails;
    if (pd == null) return isOvertime;
    return pd.hasOvertime ||
        pd.hasEarlyLeave ||
        pd.hasNoCheckout ||
        pd.hasAbsence ||
        pd.hasLocationIssue;
  }

  /// Check if check-in problem is unsolved
  bool get hasUnsolvedCheckInProblem {
    final pd = problemDetails;
    if (pd == null) {
      return isLate && !isProblemSolved;
    }
    return pd.problems
        .any((p) => checkInProblemTypes.contains(p.type) && p.isSolved != true);
  }

  /// Check if check-out problem is unsolved
  bool get hasUnsolvedCheckOutProblem {
    final pd = problemDetails;
    if (pd == null) {
      return isOvertime && !isProblemSolved;
    }
    return pd.problems.any(
        (p) => checkOutProblemTypes.contains(p.type) && p.isSolved != true,);
  }

  /// Check if ALL check-in problems were solved by DB
  bool get isCheckInProblemSolved {
    final pd = problemDetails;
    if (pd == null) return isProblemSolved;
    final checkInProblems =
        pd.problems.where((p) => checkInProblemTypes.contains(p.type));
    if (checkInProblems.isEmpty) return false;
    return checkInProblems.every((p) => p.isSolved == true);
  }

  /// Check if ALL check-out problems were solved by DB
  bool get isCheckOutProblemSolved {
    final pd = problemDetails;
    if (pd == null) return isProblemSolved;
    final checkOutProblems =
        pd.problems.where((p) => checkOutProblemTypes.contains(p.type));
    if (checkOutProblems.isEmpty) return false;
    return checkOutProblems.every((p) => p.isSolved == true);
  }

  /// Check if there's an unsolved report
  bool get hasUnsolvedReport {
    final pd = problemDetails;
    if (pd == null) {
      return isReported && isReportedSolved != true;
    }
    return pd.problems.any((p) => p.type == 'reported' && p.isSolved != true);
  }

  /// Check if the shift is still in progress
  bool get isShiftStillInProgress {
    final endTime = shiftEndTime;
    if (endTime == null) return false;
    return DateTime.now().isBefore(endTime);
  }

  /// Check if fully confirmed (all problems solved)
  bool get isFullyConfirmed {
    // If shift is still in progress, don't require confirmation yet
    if (isShiftStillInProgress) return true;

    final pd = problemDetails;

    // If no problemDetails or no problems, fully confirmed
    if (pd == null || pd.problemCount == 0) return true;

    // Check if ALL problems are solved
    return pd.isFullySolved;
  }
}
