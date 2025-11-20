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

  /// Convert local time (HH:mm) to UTC time (HH:mm:ss) for database storage
  ///
  /// Input: "13:00" (local time), requestDate: "2025-11-07"
  /// Output: "06:00:00" (UTC time with seconds)
  static String convertLocalToUtc(String localTime, String requestDate) {
    if (localTime.isEmpty || localTime == '--:--') {
      throw ArgumentError('Invalid local time: $localTime');
    }

    try {
      // Parse local time
      final parts = localTime.split(':');
      if (parts.length < 2) {
        throw ArgumentError('Invalid time format: $localTime');
      }

      final hour = int.parse(parts[0]);
      final minute = int.parse(parts[1]);

      // Validate time values
      if (hour < 0 || hour > 23 || minute < 0 || minute > 59) {
        throw ArgumentError('Invalid time values: $localTime');
      }

      // Create local DateTime
      final localDateTime = DateTime.parse('$requestDate $localTime:00');

      // Convert to UTC
      final utcDateTime = localDateTime.toUtc();

      // Return HH:mm:ss format
      return '${utcDateTime.hour.toString().padLeft(2, '0')}:${utcDateTime.minute.toString().padLeft(2, '0')}:${utcDateTime.second.toString().padLeft(2, '0')}';
    } catch (e) {
      throw ArgumentError('Failed to convert time: $e');
    }
  }

  /// Validate and format time string to HH:mm format
  ///
  /// Input: "13:00", "13:00:00", "2025-11-07T13:00:00"
  /// Output: "13:00" (HH:mm format)
  static String? validateAndFormatTime(String? timeStr) {
    if (timeStr == null || timeStr == '--:--' || timeStr.isEmpty) {
      return null;
    }

    try {
      // If already in HH:mm format, validate and return
      if (RegExp(r'^\d{2}:\d{2}$').hasMatch(timeStr)) {
        final parts = timeStr.split(':');
        final hour = int.parse(parts[0]);
        final minute = int.parse(parts[1]);

        // Validate time values
        if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
          return timeStr;
        }
      }

      // Try to extract time from datetime string
      if (timeStr.contains('T') || timeStr.contains(' ')) {
        final parts = timeStr.split(RegExp(r'[T ]'));
        if (parts.length > 1) {
          final timePart = parts[1];
          final timeComponents = timePart.split(':');
          if (timeComponents.length >= 2) {
            final hour = int.tryParse(timeComponents[0]) ?? -1;
            final minute = int.tryParse(timeComponents[1]) ?? -1;
            if (hour >= 0 && hour <= 23 && minute >= 0 && minute <= 59) {
              return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
            }
          }
        }
      }

      return null;
    } catch (e) {
      return null;
    }
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
