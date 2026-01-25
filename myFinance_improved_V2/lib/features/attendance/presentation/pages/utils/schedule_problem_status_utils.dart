import 'package:intl/intl.dart';
import 'package:myfinance_improved/shared/widgets/organisms/calendars/month_dates_picker.dart';

import '../../../domain/entities/shift_card.dart';
import 'schedule_date_utils.dart';

/// Schedule Problem Status Utilities
///
/// Utility class for building problem status maps and counting problems
/// from shift cards. Used by MyScheduleTab for week/month calendar indicators.
class ScheduleProblemStatusUtils {
  ScheduleProblemStatusUtils._();

  /// Build problem status map from shift cards
  /// Maps date string "yyyy-MM-dd" to ProblemStatus
  ///
  /// Status priority (highest to lowest):
  /// 1. unsolvedProblem (red) - Has problems, not reported, not solved
  /// 2. unsolvedReport (orange) - Reported but not solved yet
  /// 3. solved (green) - All problems resolved
  /// 4. hasShift (blue) - Has shift, no problems
  static Map<String, ProblemStatus> buildProblemStatusMap(
    List<ShiftCard> shiftCards,
  ) {
    final Map<String, ProblemStatus> statusMap = {};

    for (final card in shiftCards) {
      if (!card.isApproved) continue;

      // Parse shift date from shiftStartTime
      final startDateTime =
          ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) continue;

      final dateKey = DateFormat('yyyy-MM-dd').format(startDateTime);
      final pd = card.problemDetails;

      // Determine status for this shift
      // Logic flow:
      // 1. is_solved = true -> Green (all problems resolved)
      // 2. has_reported = true && is_solved = false -> Orange (reported, waiting)
      // 3. problem_count > 0 && is_solved = false -> Red (unsolved problem)
      // 4. No problems -> Blue (just has shift)
      ProblemStatus shiftStatus;
      if (pd != null && pd.isSolved && pd.problemCount > 0) {
        // All problems solved -> Green
        shiftStatus = ProblemStatus.solved;
      } else if (pd != null && pd.hasReported && !pd.isSolved) {
        // Reported but not solved yet -> Orange (waiting for manager review)
        shiftStatus = ProblemStatus.unsolvedReport;
      } else if (pd != null && pd.problemCount > 0 && !pd.isSolved) {
        // Has unsolved problems (not reported) -> Red
        shiftStatus = ProblemStatus.unsolvedProblem;
      } else {
        // Has shift, no problems -> Blue
        shiftStatus = ProblemStatus.hasShift;
      }

      // Keep highest priority status for the date
      final existing = statusMap[dateKey];
      if (existing == null) {
        statusMap[dateKey] = shiftStatus;
      } else {
        // Compare priority
        final priorityOrder = [
          ProblemStatus.unsolvedProblem, // highest
          ProblemStatus.unsolvedReport,
          ProblemStatus.solved,
          ProblemStatus.hasShift, // lowest
        ];
        final existingPriority = priorityOrder.indexOf(existing);
        final newPriority = priorityOrder.indexOf(shiftStatus);
        if (newPriority < existingPriority) {
          statusMap[dateKey] = shiftStatus;
        }
      }
    }

    return statusMap;
  }

  /// Count unsolved problems (red status) from shift cards
  /// These are shifts with problems that haven't been reported or solved
  static int countUnsolvedProblems(List<ShiftCard> shiftCards) {
    int count = 0;
    for (final card in shiftCards) {
      if (!card.isApproved) continue;
      final pd = card.problemDetails;
      // Count shifts with unsolved problems (not reported, not solved)
      if (pd != null && pd.problemCount > 0 && !pd.isSolved && !pd.hasReported) {
        count++;
      }
    }
    return count;
  }

  /// Get problem status color for a given status
  /// Returns the appropriate color for UI display
  static ProblemStatusInfo getStatusInfo(ProblemStatus status) {
    switch (status) {
      case ProblemStatus.none:
        return const ProblemStatusInfo(
          label: 'No Shift',
          priority: 4,
        );
      case ProblemStatus.unsolvedProblem:
        return const ProblemStatusInfo(
          label: 'Unsolved Problem',
          priority: 0,
        );
      case ProblemStatus.unsolvedReport:
        return const ProblemStatusInfo(
          label: 'Reported (Pending)',
          priority: 1,
        );
      case ProblemStatus.solved:
        return const ProblemStatusInfo(
          label: 'Solved',
          priority: 2,
        );
      case ProblemStatus.hasShift:
        return const ProblemStatusInfo(
          label: 'Has Shift',
          priority: 3,
        );
    }
  }
}

/// Problem status info for UI display
class ProblemStatusInfo {
  final String label;
  final int priority;

  const ProblemStatusInfo({
    required this.label,
    required this.priority,
  });
}
