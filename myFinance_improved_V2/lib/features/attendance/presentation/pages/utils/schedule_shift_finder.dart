import '../../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../../domain/entities/shift_card.dart';
import 'schedule_date_utils.dart';

/// Shift search and status determination logic for schedule views
class ScheduleShiftFinder {
  ScheduleShiftFinder._();

  /// Find the most relevant current shift (unified logic for UI and QR scan)
  ///
  /// Priority (NO DATE FILTERING for in-progress!):
  /// 1. In-progress shift (checked in but not out) - ANY DATE (for night shifts!)
  /// 2. Today's shifts: not-started → completed
  /// 3. Next upcoming shift (future date)
  ///
  /// [excludeCompleted]: true for QR scan (skip already completed shifts)
  static ShiftCard? findCurrentShift(
    List<ShiftCard> shiftCards, {
    bool excludeCompleted = false,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // PRIORITY 1: Find ANY in-progress shift (NO DATE FILTER!)
    // This handles night shifts: started yesterday 23:00, checkout today 03:00
    for (final card in shiftCards) {
      if (!card.isApproved) continue;
      if (card.isCheckedIn && !card.isCheckedOut) {
        return card;
      }
    }

    // PRIORITY 2: Today's shifts (not-started or completed)
    final todayShifts = <ShiftCard>[];
    ShiftCard? nextUpcoming;
    DateTime? nextUpcomingStart;

    for (final card in shiftCards) {
      if (!card.isApproved) continue;

      final startTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      final endTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime);
      if (startTime == null || endTime == null) continue;

      final startDate = DateTime(startTime.year, startTime.month, startTime.day);
      final endDate = DateTime(endTime.year, endTime.month, endTime.day);

      // Check if shift is TODAY (start or end date matches today - for night shifts)
      final isToday = startDate == today || endDate == today;

      if (isToday) {
        // Skip completed shifts for QR scan
        if (excludeCompleted && card.isCheckedIn && card.isCheckedOut) continue;
        // Skip in-progress (already handled above)
        if (card.isCheckedIn && !card.isCheckedOut) continue;
        todayShifts.add(card);
      } else if (!card.isCheckedIn && startDate.isAfter(today)) {
        // Future shift - track closest upcoming
        if (nextUpcoming == null || startTime.isBefore(nextUpcomingStart!)) {
          nextUpcoming = card;
          nextUpcomingStart = startTime;
        }
      }
    }

    // Find best today shift
    // Priority: completed (most recent) → not-started (earliest)
    // Reason: After checkout, user wants to see completed shift, not next shift
    if (todayShifts.isNotEmpty) {
      ShiftCard? notStarted;
      ShiftCard? completed;
      DateTime? completedStartTime;

      for (final card in todayShifts) {
        final startTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime)!;
        final endTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime)!;

        if (!card.isCheckedIn) {
          // Not checked in yet - pick the earliest one (not ended)
          if (!now.isAfter(endTime)) {
            if (notStarted == null) {
              notStarted = card;
            } else {
              final existingStart = ScheduleDateUtils.parseShiftDateTime(notStarted.shiftStartTime)!;
              if (startTime.isBefore(existingStart)) {
                notStarted = card;
              }
            }
          }
        } else if (card.isCheckedIn && card.isCheckedOut) {
          // Completed - pick the most recent one
          if (completed == null || startTime.isAfter(completedStartTime!)) {
            completed = card;
            completedStartTime = startTime;
          }
        }
      }

      // Priority: completed first (user just checked out), then not-started
      if (completed != null) {
        return completed;
      }
      if (notStarted != null) {
        return notStarted;
      }
    }

    // PRIORITY 3: Next upcoming shift (future date)
    if (nextUpcoming != null) {
      return nextUpcoming;
    }

    return null;
  }

  /// Find today's shift from the shift cards list
  /// @deprecated Use findCurrentShift() instead for unified logic
  /// - Only returns approved shifts
  /// - Handles night shifts: checks if today matches start_date OR end_date
  /// - When multiple shifts match today, returns the one closest to current time
  static ShiftCard? findTodayShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // First filter: collect all shifts that match today (start_date OR end_date)
    final todayShifts = <ShiftCard>[];

    for (final card in shiftCards) {
      // Only consider approved shifts
      if (!card.isApproved) continue;

      // Parse start and end datetime to check both dates (for night shifts)
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      final endDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime);

      if (startDateTime == null || endDateTime == null) continue;

      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      final endDate = DateTime(endDateTime.year, endDateTime.month, endDateTime.day);

      // Check if today matches start_date OR end_date (for night shifts)
      if (ScheduleDateUtils.isSameDay(startDate, today) ||
          ScheduleDateUtils.isSameDay(endDate, today)) {
        todayShifts.add(card);
      }
    }

    if (todayShifts.isEmpty) return null;
    if (todayShifts.length == 1) return todayShifts.first;

    // Second filter: find the shift closest to current time
    // Priority: ongoing shift > upcoming shift > past shift (closest to now)
    ShiftCard? closestShift;
    Duration? closestDuration;

    for (final card in todayShifts) {
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime)!;
      final endDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime)!;

      // Check if currently in progress (now is between start and end)
      if (now.isAfter(startDateTime) && now.isBefore(endDateTime)) {
        // Ongoing shift has highest priority
        // If multiple ongoing shifts, return the one that started most recently
        if (closestShift == null) {
          closestShift = card;
          closestDuration = Duration.zero; // Mark as ongoing
        } else if (closestDuration == Duration.zero) {
          // Both are ongoing, pick the one that started later (more recent)
          final existingStart = ScheduleDateUtils.parseShiftDateTime(closestShift.shiftStartTime)!;
          if (startDateTime.isAfter(existingStart)) {
            closestShift = card;
          }
        }
        continue;
      }

      // Skip if we already have an ongoing shift
      if (closestDuration == Duration.zero) continue;

      // Calculate time distance from now
      Duration distance;
      if (now.isBefore(startDateTime)) {
        // Upcoming shift: distance to start time
        distance = startDateTime.difference(now);
      } else {
        // Past shift: distance from end time
        distance = now.difference(endDateTime);
      }

      if (closestDuration == null || distance < closestDuration) {
        closestDuration = distance;
        closestShift = card;
      }
    }

    return closestShift;
  }

  /// Find the closest upcoming shift from actual data
  /// - Returns the specific ShiftCard (not just date) to handle multiple shifts on same day
  /// - Uses shift_start_time/shift_end_time instead of request_date
  static ShiftCard? findClosestUpcomingShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    ShiftCard? closestShift;
    DateTime? closestDateTime;

    for (final card in shiftCards) {
      // Only consider approved shifts that haven't started
      if (!card.isApproved || card.actualStartTime != null) continue;

      // Parse start and end datetime
      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      final endDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime);
      if (startDateTime == null || endDateTime == null) continue;

      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);
      final endDate = DateTime(endDateTime.year, endDateTime.month, endDateTime.day);

      // Skip if this is today's shift (start_date or end_date matches today)
      // This function only finds FUTURE shifts, not today's
      if (ScheduleDateUtils.isSameDay(startDate, today) ||
          ScheduleDateUtils.isSameDay(endDate, today)) {
        continue;
      }

      // Only consider future shifts (start_date is after today)
      if (startDate.isAfter(today)) {
        if (closestDateTime == null || startDateTime.isBefore(closestDateTime)) {
          closestDateTime = startDateTime;
          closestShift = card;
        }
      }
    }

    return closestShift;
  }

  /// Determine ShiftCardStatus from ShiftCard data
  /// Uses problem_details to determine the primary status
  static ShiftCardStatus determineStatus(ShiftCard card, DateTime cardDate, {bool hasManagerMemo = false}) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final pd = card.problemDetails;

    // Future shift (hasn't come yet)
    if (cardDate.isAfter(today)) {
      return ShiftCardStatus.upcoming;
    }

    // Currently working (checked in but not out)
    if (card.actualStartTime != null && card.actualEndTime == null) {
      return ShiftCardStatus.inProgress;
    }

    // Check problem_details for status (priority order)
    if (pd != null && pd.problemCount > 0) {
      // Reported issue - check if resolved
      if (pd.hasReported) {
        final isResolved = pd.isSolved || hasManagerMemo;
        return isResolved ? ShiftCardStatus.resolved : ShiftCardStatus.reported;
      }

      // Absence
      if (pd.hasAbsence) {
        return ShiftCardStatus.absent;
      }

      // No checkout
      if (pd.hasNoCheckout) {
        return ShiftCardStatus.noCheckout;
      }

      // Early leave
      if (pd.hasEarlyLeave) {
        return ShiftCardStatus.earlyLeave;
      }

      // Late
      if (pd.hasLate) {
        return ShiftCardStatus.late;
      }
    }

    // Past or today's shift with check-in and check-out completed
    if (card.actualStartTime != null && card.actualEndTime != null) {
      return ShiftCardStatus.onTime;
    }

    // Past date but no check-in
    if (cardDate.isBefore(today)) {
      return ShiftCardStatus.undone;
    }

    return ShiftCardStatus.upcoming;
  }

  /// Merge shift cards from two months and remove duplicates
  /// Uses shiftRequestId for deduplication
  static List<ShiftCard> mergeShiftCards(List<ShiftCard> primary, List<ShiftCard> secondary) {
    final seenIds = <String>{};
    final merged = <ShiftCard>[];

    // Add all primary cards
    for (final card in primary) {
      if (!seenIds.contains(card.shiftRequestId)) {
        seenIds.add(card.shiftRequestId);
        merged.add(card);
      }
    }

    // Add secondary cards that aren't duplicates
    for (final card in secondary) {
      if (!seenIds.contains(card.shiftRequestId)) {
        seenIds.add(card.shiftRequestId);
        merged.add(card);
      }
    }

    return merged;
  }
}
