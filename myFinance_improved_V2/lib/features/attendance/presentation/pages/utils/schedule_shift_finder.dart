import '../../../../../shared/widgets/toss/toss_week_shift_card.dart';
import '../../../domain/entities/shift_card.dart';
import 'schedule_date_utils.dart';

/// Shift search and status determination logic for schedule views
class ScheduleShiftFinder {
  ScheduleShiftFinder._();

  /// Find today's shift from the shift cards list
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
  static ShiftCardStatus determineStatus(ShiftCard card, DateTime cardDate) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Future shift (hasn't come yet)
    if (cardDate.isAfter(today)) {
      return ShiftCardStatus.upcoming;
    }

    // Past or today's shift
    if (card.actualStartTime != null && card.actualEndTime != null) {
      // Check-in and check-out completed
      return card.isLate ? ShiftCardStatus.late : ShiftCardStatus.onTime;
    }

    if (card.actualStartTime != null && card.actualEndTime == null) {
      // Currently working (checked in but not out)
      return ShiftCardStatus.inProgress;
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
