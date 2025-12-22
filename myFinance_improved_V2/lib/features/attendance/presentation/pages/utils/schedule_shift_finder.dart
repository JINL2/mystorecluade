import '../../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../../domain/entities/shift_card.dart';
import 'schedule_date_utils.dart';

/// Result of findCurrentShift with chain info
class CurrentShiftResult {
  final ShiftCard? shift;
  final bool isPartOfInProgressChain;

  const CurrentShiftResult({
    this.shift,
    this.isPartOfInProgressChain = false,
  });
}

/// Shift search and status determination logic for schedule views
class ScheduleShiftFinder {
  ScheduleShiftFinder._();

  /// Find the most relevant current shift (unified logic for UI and QR scan)
  ///
  /// Uses unified chain detection from [ScheduleDateUtils].
  ///
  /// Priority:
  /// 1. In-progress continuous chain → return shift with end_time closest to now
  /// 2. Today's shifts: completed (most recent) → not-started (earliest)
  /// 3. Next upcoming shift (future date)
  ///
  /// [excludeCompleted]: true for QR scan (skip already completed shifts)
  ///
  /// Returns [CurrentShiftResult] with shift and chain status
  static CurrentShiftResult findCurrentShiftWithChainInfo(
    List<ShiftCard> shiftCards, {
    bool excludeCompleted = false,
  }) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // PRIORITY 1: In-progress shift (checked in but not checked out)
    // This has highest priority - always show the shift user is currently working on
    final chain = ScheduleDateUtils.detectContinuousChain(shiftCards, currentTime: now);

    if (chain.hasChain) {
      // If shouldCheckout is true, find the best shift in the chain for checkout
      if (chain.shouldCheckout) {
        final checkoutShift = ScheduleDateUtils.findClosestCheckoutShift(chain, currentTime: now);
        if (checkoutShift != null) {
          // Chain shift: might not have isCheckedIn=true itself
          final isChainShift = checkoutShift.shiftRequestId != chain.inProgressShift?.shiftRequestId;
          return CurrentShiftResult(
            shift: checkoutShift,
            isPartOfInProgressChain: isChainShift,
          );
        }
      }
      // Always return in-progress shift if it exists (even if shouldCheckout is false)
      if (chain.inProgressShift != null) {
        return CurrentShiftResult(shift: chain.inProgressShift);
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
      // Shift date is determined by start_time only (not end_time)
      // e.g., Night shift 23:00-03:00 on Dec 21 is a "Dec 21 shift"
      final isToday = ScheduleDateUtils.isSameDay(startDate, today);

      if (isToday) {
        if (excludeCompleted && card.isCheckedIn && card.isCheckedOut) continue;
        if (card.isCheckedIn && !card.isCheckedOut) continue; // Handled above
        todayShifts.add(card);
      } else if (!card.isCheckedIn && startDate.isAfter(today)) {
        if (nextUpcoming == null || startTime.isBefore(nextUpcomingStart!)) {
          nextUpcoming = card;
          nextUpcomingStart = startTime;
        }
      }
    }

    // Find best today shift by TIME DISTANCE to now
    // Compare: completed's end_time vs not-started's start_time
    // Show whichever is closest to current time
    if (todayShifts.isNotEmpty) {
      ShiftCard? notStarted;
      DateTime? notStartedStartTime;
      ShiftCard? completed;
      DateTime? completedEndTime;

      for (final card in todayShifts) {
        final startTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime)!;
        final endTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime)!;

        if (!card.isCheckedIn) {
          // Not-started shift: use start_time for distance calculation
          if (!now.isAfter(endTime)) {
            if (notStarted == null) {
              notStarted = card;
              notStartedStartTime = startTime;
            } else {
              // Pick the one with start_time closest to now
              final existingDistance = (notStartedStartTime!.difference(now)).abs();
              final newDistance = (startTime.difference(now)).abs();
              if (newDistance < existingDistance) {
                notStarted = card;
                notStartedStartTime = startTime;
              }
            }
          }
        } else if (card.isCheckedIn && card.isCheckedOut) {
          // Completed shift: use end_time for distance calculation
          if (completed == null) {
            completed = card;
            completedEndTime = endTime;
          } else {
            // Pick the one with end_time closest to now (most recent)
            final existingDistance = (completedEndTime!.difference(now)).abs();
            final newDistance = (endTime.difference(now)).abs();
            if (newDistance < existingDistance) {
              completed = card;
              completedEndTime = endTime;
            }
          }
        }
      }

      // Compare time distances: completed's end_time vs notStarted's start_time
      if (notStarted != null && completed != null) {
        final notStartedDistance = (notStartedStartTime!.difference(now)).abs();
        final completedDistance = (completedEndTime!.difference(now)).abs();

        // Return the shift closest to current time
        if (notStartedDistance <= completedDistance) {
          return CurrentShiftResult(shift: notStarted);
        } else {
          return CurrentShiftResult(shift: completed);
        }
      }

      // Only one type exists
      if (notStarted != null) return CurrentShiftResult(shift: notStarted);
      if (completed != null) return CurrentShiftResult(shift: completed);
    }

    // PRIORITY 3: Next upcoming shift
    if (nextUpcoming != null) return CurrentShiftResult(shift: nextUpcoming);

    return const CurrentShiftResult();
  }

  /// Backward-compatible version that returns just the shift
  static ShiftCard? findCurrentShift(
    List<ShiftCard> shiftCards, {
    bool excludeCompleted = false,
  }) {
    return findCurrentShiftWithChainInfo(shiftCards, excludeCompleted: excludeCompleted).shift;
  }

  /// Find today's shift from the shift cards list
  /// @deprecated Use findCurrentShift() instead for unified logic
  /// - Only returns approved shifts
  /// - Shift date is determined by start_time only (not end_time)
  /// - When multiple shifts match today, returns the one closest to current time
  static ShiftCard? findTodayShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // First filter: collect all shifts that start today
    // Shift date = start_time date (e.g., Night 23:00-03:00 on Dec 21 = Dec 21 shift)
    final todayShifts = <ShiftCard>[];

    for (final card in shiftCards) {
      // Only consider approved shifts
      if (!card.isApproved) continue;

      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      final endDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftEndTime);

      if (startDateTime == null || endDateTime == null) continue;

      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      // Shift date is determined by start_time only
      if (ScheduleDateUtils.isSameDay(startDate, today)) {
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
  /// - Shift date is determined by start_time only (not end_time)
  static ShiftCard? findClosestUpcomingShift(List<ShiftCard> shiftCards) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    ShiftCard? closestShift;
    DateTime? closestDateTime;

    for (final card in shiftCards) {
      // Only consider approved shifts that haven't started
      if (!card.isApproved || card.actualStartTime != null) continue;

      final startDateTime = ScheduleDateUtils.parseShiftDateTime(card.shiftStartTime);
      if (startDateTime == null) continue;

      final startDate = DateTime(startDateTime.year, startDateTime.month, startDateTime.day);

      // Skip today's shifts - this function only finds FUTURE shifts
      // Shift date = start_time date
      if (ScheduleDateUtils.isSameDay(startDate, today)) {
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
