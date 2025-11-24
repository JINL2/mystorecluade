import '../entities/shift_card.dart';
import '../value_objects/shift_status.dart';

/// Use Case for determining the current shift status based on shift cards
/// Business logic for calculating off_duty/scheduled/working/finished status
class DetermineShiftStatus {
  /// Determine shift status for a specific date based on shift cards
  ///
  /// Parameters:
  /// - [shiftCards]: List of shift cards to analyze
  /// - [targetDate]: The date to check status for (defaults to today)
  ///
  /// Returns: [ShiftStatus] representing the current status
  ///
  /// Business Rules:
  /// 1. No shifts for date → off_duty
  /// 2. Has shifts but none approved → scheduled (pending approval)
  /// 3. Approved shift with confirm_start but no confirm_end → working
  /// 4. All approved shifts completed (both start and end) → finished
  /// 5. Approved shifts exist but none started → scheduled
  ShiftStatus call({
    required List<ShiftCard> shiftCards,
    DateTime? targetDate,
  }) {
    final today = targetDate ?? DateTime.now();
    final todayStr = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    // Filter shifts for the target date
    final todayShifts = shiftCards.where((card) => card.requestDate == todayStr).toList();

    // No shifts at all today → off_duty
    if (todayShifts.isEmpty) {
      return ShiftStatus.offDuty;
    }

    // Filter to only APPROVED shifts for status determination
    final approvedShifts = todayShifts.where((shift) => shift.isApproved).toList();

    // Have shifts but none are approved yet → scheduled (pending approval)
    if (approvedShifts.isEmpty) {
      return ShiftStatus.scheduled;
    }

    // Check approved shifts status
    // Check if currently working on any approved shift
    final isCurrentlyWorking = approvedShifts.any((shift) =>
      shift.confirmStartTime != null && shift.confirmEndTime == null,
    );

    if (isCurrentlyWorking) {
      // At least one approved shift is being worked on
      return ShiftStatus.working;
    }

    // Check if all approved shifts are finished
    final allApprovedShiftsFinished = approvedShifts.every((shift) =>
      shift.confirmStartTime != null && shift.confirmEndTime != null,
    );

    // Check if any approved shift has started
    final anyApprovedShiftStarted = approvedShifts.any((shift) =>
      shift.confirmStartTime != null,
    );

    if (allApprovedShiftsFinished && anyApprovedShiftStarted) {
      // All approved shifts are completed
      return ShiftStatus.finished;
    }

    // Have approved shifts but none started yet → scheduled
    return ShiftStatus.scheduled;
  }
}
