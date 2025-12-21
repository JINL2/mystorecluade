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
    // Condition: chain's last shift hasn't ended yet (end_time > now)
    // No date comparison needed - just check if end_time is in the future
    final shouldCheckout = chainLastEndTime != null && chainLastEndTime.isAfter(now);

    return ChainDetectionResult(
      inProgressShift: inProgressShift,
      chainStartTime: chainStartTime,
      chainLastEndTime: chainLastEndTime,
      chainShifts: chainShifts,
      shouldCheckout: shouldCheckout,
    );
  }

  /// Find the shift with end_time closest to current time from chain
  /// Used for both UI display and QR scan checkout
  ///
  /// No date filtering - just finds the shift with end_time closest to now.
  /// This correctly handles night shifts that cross midnight (e.g., 20:00-02:00).
  static ShiftCard? findClosestCheckoutShift(
    ChainDetectionResult chain, {
    DateTime? currentTime,
  }) {
    if (!chain.hasChain || !chain.shouldCheckout) return null;
    if (chain.chainShifts.isEmpty) return null;

    final now = currentTime ?? DateTime.now();

    // Sort by distance to now (closest end_time first)
    // No date filtering needed - chain detection already validated the shifts
    final sorted = [...chain.chainShifts]..sort((a, b) {
      final aEnd = parseShiftDateTime(a.shiftEndTime);
      final bEnd = parseShiftDateTime(b.shiftEndTime);
      if (aEnd == null || bEnd == null) return 0;
      return aEnd.difference(now).abs().compareTo(bEnd.difference(now).abs());
    });

    return sorted.first;
  }

  /// Find the shift with start_time closest to current time for check-in
  ///
  /// Search range: past 24 hours ~ future
  /// This prevents checking into shifts from days ago that were forgotten.
  static ShiftCard? findClosestCheckinShift(
    List<ShiftCard> shiftCards, {
    DateTime? currentTime,
  }) {
    final now = currentTime ?? DateTime.now();
    final past24Hours = now.subtract(const Duration(hours: 24));

    // Filter: approved, not checked in, start_time within past 24 hours or future
    final checkinCandidates = shiftCards.where((c) {
      if (!c.isApproved || c.isCheckedIn) return false;

      final shiftStartTime = parseShiftDateTime(c.shiftStartTime);
      if (shiftStartTime == null) return false;

      // Only include shifts starting within past 24 hours or in the future
      return !shiftStartTime.isBefore(past24Hours);
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
