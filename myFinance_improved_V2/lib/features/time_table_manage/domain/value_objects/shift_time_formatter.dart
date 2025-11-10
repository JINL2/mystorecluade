import 'package:flutter/material.dart';

import '../../../../../core/utils/datetime_utils.dart';

/// Shift Time Formatter
///
/// Utility class for formatting shift times from UTC to local timezone.
class ShiftTimeFormatter {
  /// Convert time string from UTC to local time
  ///
  /// Input: "14:56", "14:56:00" (UTC), or "2025-11-07T18:40:00.000" (ISO8601)
  /// Output: "21:56" (Local time, e.g., Vietnam = UTC+7) - time only, no date
  static String formatTime(String? time, String? requestDate) {
    if (time == null || time.isEmpty || time == '--:--') {
      return time ?? '--:--';
    }

    try {
      DateTime dateTime;

      // Check if it's already an ISO8601 format (contains 'T' or full date)
      if (time.contains('T') || time.contains(' ') && time.length > 10) {
        // Parse directly as ISO8601
        dateTime = DateTime.parse(time);
      } else if (requestDate != null) {
        // Combine date + time and treat as UTC
        final utcTimestamp = '${requestDate}T$time${time.contains(':') && time.split(':').length == 2 ? ':00' : ''}Z';
        dateTime = DateTimeUtils.toLocal(utcTimestamp);
      } else {
        return time;
      }

      // Return time only (HH:mm) - no date
      return DateTimeUtils.formatTimeOnly(dateTime);
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

  /// Convert time string from UTC to local time with seconds
  ///
  /// Input: "14:56:30", "14:56:30.123" (UTC), or "2025-11-07T18:40:30.000" (ISO8601)
  /// Output: "21:56:30" (Local time with seconds)
  static String formatTimeWithSeconds(String? time, String? requestDate) {
    if (time == null || time.isEmpty || time == '--:--') {
      return time ?? '--:--';
    }

    try {
      DateTime dateTime;

      // Check if it's already an ISO8601 format (contains 'T' or full date)
      if (time.contains('T') || time.contains(' ') && time.length > 10) {
        // Parse directly as ISO8601
        dateTime = DateTime.parse(time);
      } else if (requestDate != null) {
        // Combine date + time and treat as UTC
        final utcTimestamp = '${requestDate}T${time}Z';
        dateTime = DateTimeUtils.toLocal(utcTimestamp);
      } else {
        return time;
      }

      // Return time with seconds (HH:mm:ss)
      return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      return time;
    }
  }
}
