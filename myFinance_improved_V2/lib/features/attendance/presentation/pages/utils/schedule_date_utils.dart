import 'package:flutter/material.dart';

import '../../../domain/entities/shift_card.dart';

/// Result of continuous chain detection
class ChainDetectionResult {
  /// The in-progress shift that started the chain (has isCheckedIn=true)
  final ShiftCard? inProgressShift;

  /// When the chain started (first shift's start_time)
  final DateTime? chainStartTime;

  /// When the chain ends (last shift's end_time)
  final DateTime? chainLastEndTime;

  /// All shifts in the chain, sorted by start time
  final List<ShiftCard> chainShifts;

  /// Whether we should be in checkout mode (chain ends today or later)
  final bool shouldCheckout;

  const ChainDetectionResult({
    this.inProgressShift,
    this.chainStartTime,
    this.chainLastEndTime,
    this.chainShifts = const [],
    this.shouldCheckout = false,
  });

  /// No chain found
  static const ChainDetectionResult empty = ChainDetectionResult();

  /// Check if a valid chain was found
  bool get hasChain => inProgressShift != null && chainShifts.isNotEmpty;
}

/// Shared DateTime utilities for schedule views
class ScheduleDateUtils {
  ScheduleDateUtils._();

  // ============================================================
  // CORE PARSING UTILITIES
  // ============================================================

  /// Parse shift datetime from ISO format string
  /// Supports: "2025-06-01T14:00:00" or "2025-06-01 14:00:00"
  static DateTime? parseShiftDateTime(String? dateTimeStr) {
    if (dateTimeStr == null || dateTimeStr.isEmpty) return null;
    try {
      if (dateTimeStr.contains('T')) {
        return DateTime.parse(dateTimeStr);
      }
      if (dateTimeStr.contains(' ')) {
        return DateTime.parse(dateTimeStr.replaceFirst(' ', 'T'));
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  /// Extract date-only from shift time string (e.g., "2025-12-20T08:00:00")
  static DateTime? parseShiftDate(String? shiftTime) {
    final dateTime = parseShiftDateTime(shiftTime);
    if (dateTime == null) return null;
    return DateTime(dateTime.year, dateTime.month, dateTime.day);
  }

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // ============================================================
  // CONTINUOUS CHAIN DETECTION (UNIFIED LOGIC)
  // ============================================================

  /// Detect continuous shift chain from in-progress shift
  ///
  /// For continuous shifts (08:00~13:00, 13:00~19:00, 19:00~02:00):
  /// - Only FIRST shift has isCheckedIn=true
  /// - Chain detection traces forward to find all connected shifts
  /// - Uses 1-minute tolerance for time matching
  ///
  /// Returns [ChainDetectionResult] with chain info and checkout determination
  static ChainDetectionResult detectContinuousChain(
    List<ShiftCard> shiftCards, {
    DateTime? currentTime,
  }) {
    if (shiftCards.isEmpty) return ChainDetectionResult.empty;

    final now = currentTime ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Step 1: Find in-progress shift (checked in but not out)
    ShiftCard? inProgressShift;
    for (final card in shiftCards) {
      if (card.isApproved && card.isCheckedIn && !card.isCheckedOut) {
        inProgressShift = card;
        break;
      }
    }

    if (inProgressShift == null) return ChainDetectionResult.empty;

    final chainStartTime = parseShiftDateTime(inProgressShift.shiftStartTime);
    if (chainStartTime == null) return ChainDetectionResult.empty;

    // Step 2: Sort and filter candidates for chain
    final sortedShifts = shiftCards
        .where((c) => c.isApproved && !c.isCheckedOut)
        .toList()
      ..sort((a, b) {
        final aStart = parseShiftDateTime(a.shiftStartTime);
        final bStart = parseShiftDateTime(b.shiftStartTime);
        if (aStart == null || bStart == null) return 0;
        return aStart.compareTo(bStart);
      });

    // Step 3: Trace the chain forward from in-progress shift
    final chainShifts = <ShiftCard>[inProgressShift];
    DateTime? currentEndTime = parseShiftDateTime(inProgressShift.shiftEndTime);
    DateTime? chainLastEndTime = currentEndTime;

    for (final c in sortedShifts) {
      if (c.shiftRequestId == inProgressShift.shiftRequestId) continue;

      final shiftStart = parseShiftDateTime(c.shiftStartTime);
      final shiftEnd = parseShiftDateTime(c.shiftEndTime);
      if (shiftStart == null || shiftEnd == null) continue;

      // Check if this shift continues the chain (start_time = previous end_time)
      // Allow 1 minute tolerance for edge cases
      if (currentEndTime != null) {
        final diff = shiftStart.difference(currentEndTime).abs();
        if (diff.inMinutes <= 1) {
          chainShifts.add(c);
          currentEndTime = shiftEnd;
          chainLastEndTime = shiftEnd;
        }
      }
    }

    // Step 4: Determine if we should be in CHECKOUT mode
    // Condition: inProgressShift exists (checked in but not out)
    // Time doesn't matter - user should be able to checkout even after shift ended
    final shouldCheckout = inProgressShift != null;

    return ChainDetectionResult(
      inProgressShift: inProgressShift,
      chainStartTime: chainStartTime,
      chainLastEndTime: chainLastEndTime,
      chainShifts: chainShifts,
      shouldCheckout: shouldCheckout,
    );
  }

  /// Find the correct shift for checkout from chain
  /// Used for both UI display and QR scan checkout
  ///
  /// Logic: Find the earliest shift that hasn't ended yet (end_time > now)
  /// If all shifts ended, return the last shift (allows late checkout)
  ///
  /// Example: 08:00~13:00, 13:00~19:00, 19:00~02:00 chain
  /// - At 10:00 → Morning (end 13:00 > 10:00)
  /// - At 15:00 → Afternoon (Morning ended, Afternoon end 19:00 > 15:00)
  /// - At 21:00 → Night (Morning/Afternoon ended, Night end 02:00 > 21:00)
  /// - At 01:00 → Night (end 02:00 > 01:00)
  /// - At 02:30 → Night (all ended, fallback to last) ✅ Late checkout works!
  static ShiftCard? findClosestCheckoutShift(
    ChainDetectionResult chain, {
    DateTime? currentTime,
  }) {
    if (!chain.hasChain || !chain.shouldCheckout) return null;
    if (chain.chainShifts.isEmpty) return null;

    final now = currentTime ?? DateTime.now();

    // Sort shifts by start_time (chronological order)
    final sorted = [...chain.chainShifts]..sort((a, b) {
      final aStart = parseShiftDateTime(a.shiftStartTime);
      final bStart = parseShiftDateTime(b.shiftStartTime);
      if (aStart == null || bStart == null) return 0;
      return aStart.compareTo(bStart);
    });

    // Find the earliest shift that hasn't ended yet (end_time > now)
    for (final shift in sorted) {
      final endTime = parseShiftDateTime(shift.shiftEndTime);
      if (endTime == null) continue;

      if (endTime.isAfter(now)) {
        return shift;
      }
    }

    // Fallback: return the last shift in chain (all ended - for display purposes)
    return sorted.last;
  }

  /// Find the shift with start_time closest to current time for check-in
  ///
  /// CRITICAL: Uses midpoint logic for night shift transitions!
  ///
  /// Problem: At 01:04 on Dec 23, the Dec 22 Night shift (20:00~01:00) has ended,
  /// but the Dec 23 Night shift (20:00~01:00) shouldn't allow check-in yet.
  ///
  /// Solution: Calculate midpoint between previous shift's end and next shift's start.
  /// - Before midpoint: Still in checkout mode for previous shift
  /// - After midpoint: Can check into next shift
  ///
  /// Example:
  /// - Dec 22 Night ends: 01:00 (Dec 23)
  /// - Dec 23 Morning starts: 10:00
  /// - Midpoint: (01:00 + 10:00) / 2 = 05:30
  /// - At 03:00 → Dec 22 Night (checkout mode)
  /// - At 06:00 → Dec 23 Morning (checkin mode)
  ///
  /// Edge case: No next shift → Default grace period of 3 hours after end_time
  static ShiftCard? findClosestCheckinShift(
    List<ShiftCard> shiftCards, {
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Step 1: Find if there's an in-progress shift that should still be shown
    // (checked in but not out, or recently ended)
    final inProgressOrRecentShift = _findInProgressOrRecentShift(shiftCards, now);
    if (inProgressOrRecentShift != null) {
      // User should checkout this shift, not check into a new one
      return null;
    }

    // Step 2: Filter check-in candidates
    // - Approved, not checked in
    // - Start time is today OR within valid check-in window
    final checkinCandidates = shiftCards.where((c) {
      if (!c.isApproved || c.isCheckedIn) return false;

      final shiftStartTime = parseShiftDateTime(c.shiftStartTime);
      if (shiftStartTime == null) return false;

      final shiftDate = DateTime(shiftStartTime.year, shiftStartTime.month, shiftStartTime.day);

      // Allow check-in for TODAY's shifts
      if (isSameDay(shiftDate, today)) return true;

      // Also allow if we're past the midpoint and this is the next upcoming shift
      // This handles the case where it's 06:00 and the next shift starts at 10:00
      return false;
    }).toList();

    if (checkinCandidates.isEmpty) return null;

    // Sort by distance from current time to start_time (closest first)
    checkinCandidates.sort((a, b) {
      final aStart = parseShiftDateTime(a.shiftStartTime);
      final bStart = parseShiftDateTime(b.shiftStartTime);
      if (aStart == null || bStart == null) return 0;
      return aStart.difference(now).abs().compareTo(bStart.difference(now).abs());
    });

    return checkinCandidates.first;
  }

  /// Find in-progress shift OR recently ended shift that should still show checkout
  ///
  /// Returns the shift if:
  /// 1. Shift is in-progress (checked in, not out)
  /// 2. Shift ended but we're before the midpoint to next shift
  ///
  /// Returns null if user can proceed to check into a new shift
  static ShiftCard? _findInProgressOrRecentShift(
    List<ShiftCard> shiftCards,
    DateTime now,
  ) {
    // First priority: Find in-progress shift (checked in but not out)
    for (final card in shiftCards) {
      if (card.isApproved && card.isCheckedIn && !card.isCheckedOut) {
        return card;
      }
    }

    // Second priority: Find recently ended shift (before midpoint)
    // This handles the case where night shift ended at 01:00 and it's now 03:00
    final recentlyEndedShift = _findRecentlyEndedShiftBeforeMidpoint(shiftCards, now);
    if (recentlyEndedShift != null) {
      return recentlyEndedShift;
    }

    return null;
  }

  /// Find a shift that ended recently but user should still checkout
  /// (We're before the midpoint to the next shift)
  ///
  /// Grace period: 3 hours after end_time if no next shift
  static ShiftCard? _findRecentlyEndedShiftBeforeMidpoint(
    List<ShiftCard> shiftCards,
    DateTime now,
  ) {
    const defaultGraceHours = 3;

    // Find completed shifts that ended within the last 12 hours
    // (reasonable window for checking)
    final recentlyCompleted = <ShiftCard>[];
    for (final card in shiftCards) {
      if (!card.isApproved) continue;
      // Only consider shifts that have check-in but no check-out
      // (actual_end_time is null means no checkout yet)
      if (!card.isCheckedIn || card.isCheckedOut) continue;

      final endTime = parseShiftDateTime(card.shiftEndTime);
      if (endTime == null) continue;

      // Check if shift ended within last 12 hours
      final hoursSinceEnd = now.difference(endTime).inHours;
      if (hoursSinceEnd >= 0 && hoursSinceEnd <= 12) {
        recentlyCompleted.add(card);
      }
    }

    if (recentlyCompleted.isEmpty) return null;

    // Sort by end_time (most recent first)
    recentlyCompleted.sort((a, b) {
      final aEnd = parseShiftDateTime(a.shiftEndTime);
      final bEnd = parseShiftDateTime(b.shiftEndTime);
      if (aEnd == null || bEnd == null) return 0;
      return bEnd.compareTo(aEnd); // Descending
    });

    final mostRecentShift = recentlyCompleted.first;
    final mostRecentEndTime = parseShiftDateTime(mostRecentShift.shiftEndTime)!;

    // Find the next upcoming shift (not checked in, start_time > mostRecentEndTime)
    ShiftCard? nextShift;
    DateTime? nextShiftStart;
    for (final card in shiftCards) {
      if (!card.isApproved || card.isCheckedIn) continue;

      final startTime = parseShiftDateTime(card.shiftStartTime);
      if (startTime == null || !startTime.isAfter(mostRecentEndTime)) continue;

      if (nextShift == null || startTime.isBefore(nextShiftStart!)) {
        nextShift = card;
        nextShiftStart = startTime;
      }
    }

    // Calculate midpoint
    DateTime midpoint;
    if (nextShiftStart != null) {
      // Midpoint = (previous_end + next_start) / 2
      final totalMinutes = nextShiftStart.difference(mostRecentEndTime).inMinutes;
      midpoint = mostRecentEndTime.add(Duration(minutes: totalMinutes ~/ 2));
    } else {
      // No next shift: use default grace period
      midpoint = mostRecentEndTime.add(const Duration(hours: defaultGraceHours));
    }

    // If we're before midpoint, return the recently ended shift (checkout mode)
    if (now.isBefore(midpoint)) {
      return mostRecentShift;
    }

    // We're past midpoint, user can check into next shift
    return null;
  }

  /// Get week range (Monday to Sunday) for a given date
  static DateTimeRange getWeekRange(DateTime date) {
    final weekday = date.weekday; // 1=Mon, 7=Sun
    final monday = date.subtract(Duration(days: weekday - 1));
    final sunday = monday.add(const Duration(days: 6));
    return DateTimeRange(
      start: DateTime(monday.year, monday.month, monday.day),
      end: DateTime(sunday.year, sunday.month, sunday.day, 23, 59, 59),
    );
  }

  /// Format time from 24h to 12h format
  /// Input: "14:00" -> Output: "2:00 PM"
  static String formatTime(String time24) {
    try {
      final parts = time24.split(':');
      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);
      final period = hour >= 12 ? 'PM' : 'AM';
      final hour12 = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
      return '$hour12:${minute.toString().padLeft(2, '0')} $period';
    } catch (e) {
      return time24;
    }
  }

  /// Format time range from shiftStartTime and shiftEndTime
  /// Input: "2025-06-01T14:00:00", "2025-06-01T18:00:00"
  /// Output: "2:00 PM - 6:00 PM"
  static String formatTimeRangeFromDateTime(String shiftStartTime, String shiftEndTime) {
    try {
      final startDateTime = parseShiftDateTime(shiftStartTime);
      final endDateTime = parseShiftDateTime(shiftEndTime);
      if (startDateTime == null || endDateTime == null) return '--:-- - --:--';

      final startTimeStr = '${startDateTime.hour.toString().padLeft(2, '0')}:${startDateTime.minute.toString().padLeft(2, '0')}';
      final endTimeStr = '${endDateTime.hour.toString().padLeft(2, '0')}:${endDateTime.minute.toString().padLeft(2, '0')}';

      final formattedStart = formatTime(startTimeStr);
      final formattedEnd = formatTime(endTimeStr);
      return '$formattedStart - $formattedEnd';
    } catch (e) {
      return '--:-- - --:--';
    }
  }

  /// Extract shift type from shiftStartTime based on hour
  /// Morning: before 12, Afternoon: 12-17, Evening: after 17
  static String extractShiftTypeFromDateTime(String shiftStartTime) {
    try {
      final startDateTime = parseShiftDateTime(shiftStartTime);
      if (startDateTime == null) return 'Shift';

      final startHour = startDateTime.hour;
      if (startHour < 12) return 'Morning';
      if (startHour < 17) return 'Afternoon';
      return 'Evening';
    } catch (e) {
      return 'Shift';
    }
  }

  /// Format date to "Tue, 18 Jun 2025" format
  static String formatDateFull(DateTime date) {
    const weekDays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
    ];

    final weekDay = weekDays[date.weekday - 1];
    final month = months[date.month - 1];
    return '$weekDay, ${date.day} $month ${date.year}';
  }

  /// Format date from shiftStartTime string
  static String formatDateFromShiftTime(String shiftStartTime) {
    final date = parseShiftDateTime(shiftStartTime);
    if (date == null) return 'Unknown date';
    return formatDateFull(date);
  }
}
