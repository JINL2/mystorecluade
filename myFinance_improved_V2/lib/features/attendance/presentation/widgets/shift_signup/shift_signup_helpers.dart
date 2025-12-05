import 'package:intl/intl.dart';

import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_metadata.dart';
import 'shift_signup_card.dart';

/// ShiftSignupHelpers
///
/// Utility functions for shift signup feature
/// Extracted from shift_signup_tab.dart for better code organization
class ShiftSignupHelpers {
  ShiftSignupHelpers._();

  /// Get month key for caching (yyyy-MM format)
  static String getMonthKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}';
  }

  /// Format week label
  static String getWeekLabel(int weekOffset) {
    if (weekOffset == 0) {
      return 'This week';
    } else if (weekOffset < 0) {
      return 'Previous week';
    } else {
      return 'Next week';
    }
  }

  /// Format date range (e.g., "10 - 16 Jun")
  static String getDateRange(DateTime weekStartDate) {
    final start = weekStartDate;
    final end = weekStartDate.add(const Duration(days: 6));

    final startDay = start.day;
    final endDay = end.day;
    final month = DateFormat.MMM().format(end);

    return '$startDay - $endDay $month';
  }

  /// Format time range and convert from UTC to local time
  static String formatTimeRange(String startTime, String endTime) {
    try {
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      if (startParts.length >= 2 && endParts.length >= 2) {
        final now = DateTime.now();
        final startUtc = DateTime.utc(
          now.year,
          now.month,
          now.day,
          int.parse(startParts[0]),
          int.parse(startParts[1]),
        );
        final endUtc = DateTime.utc(
          now.year,
          now.month,
          now.day,
          int.parse(endParts[0]),
          int.parse(endParts[1]),
        );

        final startLocal = startUtc.toLocal();
        final endLocal = endUtc.toLocal();

        final start =
            '${startLocal.hour.toString().padLeft(2, '0')}:${startLocal.minute.toString().padLeft(2, '0')}';
        final end =
            '${endLocal.hour.toString().padLeft(2, '0')}:${endLocal.minute.toString().padLeft(2, '0')}';

        return '$start - $end';
      }
    } catch (_) {
      // Fallback below
    }

    final start = startTime.substring(0, 5);
    final end = endTime.substring(0, 5);
    return '$start - $end';
  }

  /// Get shift status for a specific date from monthly shift status data
  static MonthlyShiftStatus? getShiftStatusForDate(
    DateTime date,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final monthKey = getMonthKey(date);
    final monthData = cache[monthKey];
    if (monthData == null) return null;

    final dateStr = DateFormat('yyyy-MM-dd').format(date);
    try {
      return monthData.firstWhere((status) => status.requestDate == dateStr);
    } catch (_) {
      return null;
    }
  }

  /// Get dates where user has approved shifts
  static Set<String> getDatesWithUserApproved(
    DateTime weekStartDate,
    String currentUserId,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final result = <String>{};

    for (int i = 0; i < 7; i++) {
      final date = weekStartDate.add(Duration(days: i));
      final status = getShiftStatusForDate(date, cache);
      if (status != null) {
        for (final shift in status.shifts) {
          final hasUserApproved = shift.approvedEmployees.any(
            (emp) => emp.userId == currentUserId,
          );
          if (hasUserApproved) {
            result.add(DateFormat('yyyy-MM-dd').format(date));
            break;
          }
        }
      }
    }

    return result;
  }

  /// Get shift availability map for week dates
  static Set<String> getShiftAvailabilityMap(
    DateTime weekStartDate,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final result = <String>{};

    for (int i = 0; i < 7; i++) {
      final date = weekStartDate.add(Duration(days: i));
      final status = getShiftStatusForDate(date, cache);

      if (status != null && status.shifts.isNotEmpty) {
        bool hasAvailableSlots = false;
        for (final shift in status.shifts) {
          if (shift.hasAvailableSlots) {
            hasAvailableSlots = true;
            break;
          }
        }

        if (hasAvailableSlots || status.shifts.isNotEmpty) {
          result.add(DateFormat('yyyy-MM-dd').format(date));
        }
      }
    }

    return result;
  }

  /// Get shift signup status
  static ShiftSignupStatus getShiftStatus(
    ShiftMetadata shift,
    DateTime selectedDate,
    String currentUserId,
    Set<String> appliedShiftIds,
    Set<String> waitlistedShiftIds,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    // Check local state first (optimistic update)
    if (appliedShiftIds.contains(shift.shiftId)) {
      return ShiftSignupStatus.applied;
    }
    if (waitlistedShiftIds.contains(shift.shiftId)) {
      return ShiftSignupStatus.onWaitlist;
    }

    // Check RPC data
    final dailyShift = _getDailyShiftForMetadata(shift, selectedDate, cache);
    if (dailyShift != null) {
      final isUserApproved = dailyShift.approvedEmployees.any(
        (emp) => emp.userId == currentUserId,
      );
      if (isUserApproved) {
        return ShiftSignupStatus.assigned;
      }

      final isUserPending = dailyShift.pendingEmployees.any(
        (emp) => emp.userId == currentUserId,
      );
      if (isUserPending) {
        return ShiftSignupStatus.applied;
      }

      if (!dailyShift.hasAvailableSlots) {
        return ShiftSignupStatus.waitlist;
      }
    }

    return ShiftSignupStatus.available;
  }

  /// Get daily shift data for a shift metadata
  static DailyShift? _getDailyShiftForMetadata(
    ShiftMetadata shift,
    DateTime selectedDate,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final status = getShiftStatusForDate(selectedDate, cache);
    if (status == null) return null;

    try {
      return status.shifts.firstWhere((s) => s.shiftId == shift.shiftId);
    } catch (_) {
      return null;
    }
  }

  /// Get applied count
  static int getAppliedCount(
    ShiftMetadata shift,
    DateTime selectedDate,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final dailyShift = _getDailyShiftForMetadata(shift, selectedDate, cache);
    if (dailyShift == null) return 0;
    return dailyShift.pendingCount;
  }

  /// Check if user applied
  static bool getUserApplied(
    ShiftMetadata shift,
    DateTime selectedDate,
    String currentUserId,
    Set<String> appliedShiftIds,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    if (appliedShiftIds.contains(shift.shiftId)) {
      return true;
    }

    final dailyShift = _getDailyShiftForMetadata(shift, selectedDate, cache);
    if (dailyShift != null) {
      return dailyShift.pendingEmployees.any((emp) => emp.userId == currentUserId);
    }

    return false;
  }

  /// Get filled slots
  static int getFilledSlots(
    ShiftMetadata shift,
    DateTime selectedDate,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final dailyShift = _getDailyShiftForMetadata(shift, selectedDate, cache);
    if (dailyShift == null) return 0;
    return dailyShift.approvedCount;
  }

  /// Get employee avatars
  static List<String> getEmployeeAvatars(
    ShiftMetadata shift,
    DateTime selectedDate,
    Map<String, List<MonthlyShiftStatus>> cache,
  ) {
    final dailyShift = _getDailyShiftForMetadata(shift, selectedDate, cache);
    if (dailyShift == null) return [];

    final avatars = <String>[];

    for (final emp in dailyShift.approvedEmployees) {
      if (emp.profileImage != null && emp.profileImage!.isNotEmpty) {
        avatars.add(emp.profileImage!);
      }
      if (avatars.length >= 4) break;
    }

    if (avatars.length < 4) {
      for (final emp in dailyShift.pendingEmployees) {
        if (emp.profileImage != null && emp.profileImage!.isNotEmpty) {
          avatars.add(emp.profileImage!);
        }
        if (avatars.length >= 4) break;
      }
    }

    return avatars;
  }
}
