import 'package:flutter/material.dart';

import '../../../../../core/utils/datetime_utils.dart';

/// Shift Time Formatter
///
/// Utility class for formatting shift times from UTC to local timezone.
class ShiftTimeFormatter {
  /// Convert time string from UTC to local time
  ///
  /// Input: "14:56" or "14:56:00" (UTC), requestDate: "2025-10-27"
  /// Output: "21:56" (Local time, e.g., Vietnam = UTC+7)
  static String formatTime(String? time, String? requestDate) {
    if (time == null || time.isEmpty || time == '--:--' || requestDate == null) {
      return time ?? '--:--';
    }

    try {
      // Combine date + time and treat as UTC
      final utcTimestamp = '${requestDate}T$time${time.contains(':') && time.split(':').length == 2 ? ':00' : ''}Z';
      final dateTime = DateTimeUtils.toLocal(utcTimestamp);
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }

  /// Convert shift time string from UTC to local time
  ///
  /// Input: "14:56-17:56" or "14:56 ~ 17:56" (UTC), requestDate: "2025-10-27"
  /// Output: "21:56-00:56" (Local time, e.g., Vietnam = UTC+7)
  static String formatShiftTime(String? shiftTime, String? requestDate) {
    if (shiftTime == null || shiftTime.isEmpty || shiftTime == '--:--' || shiftTime == 'N/A' || requestDate == null) {
      return shiftTime ?? 'N/A';
    }

    try {
      // Parse shift time format: "14:56-17:56" or "14:56 ~ 17:56"
      final separator = shiftTime.contains('~') ? '~' : '-';
      final parts = shiftTime.split(separator).map((e) => e.trim()).toList();

      if (parts.length != 2) {
        return shiftTime;
      }

      final startTime = parts[0].trim();
      final endTime = parts[1].trim();

      // Convert each time from UTC to local
      final localStartTime = formatTime(startTime, requestDate);
      final localEndTime = formatTime(endTime, requestDate);

      return '$localStartTime$separator$localEndTime';
    } catch (e) {
      return shiftTime;
    }
  }

  /// Format TimeOfDay to HH:mm string
  static String formatTimeOfDay(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
