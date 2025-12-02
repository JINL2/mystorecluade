import 'package:flutter/material.dart';

/// Shared DateTime utilities for schedule views
class ScheduleDateUtils {
  ScheduleDateUtils._();

  /// Parse shift datetime from ISO format string
  /// Supports: "2025-06-01T14:00:00" or "2025-06-01 14:00:00"
  static DateTime? parseShiftDateTime(String dateTimeStr) {
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

  /// Check if two dates are the same day
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
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
