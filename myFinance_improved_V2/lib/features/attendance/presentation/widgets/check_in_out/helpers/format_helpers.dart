import 'package:flutter/material.dart';

import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../../../shared/themes/toss_colors.dart';

/// Formatting helper functions for attendance UI
class FormatHelpers {
  /// Get work status text from card data
  static String getWorkStatusFromCard(Map<String, dynamic> cardData) {
    final isApproved = cardData['is_approved'] as bool? ?? false;
    final actualStart = cardData['actual_start_time'];
    final actualEnd = cardData['actual_end_time'];
    final isLate = cardData['is_late'] as bool? ?? false;

    if (!isApproved) {
      return 'Pending';
    }

    if (actualStart == null && actualEnd == null) {
      return 'Not Started';
    }

    if (actualStart != null && actualEnd == null) {
      return isLate ? 'Working (Late)' : 'Working';
    }

    if (actualStart != null && actualEnd != null) {
      return isLate ? 'Completed (Late)' : 'Completed';
    }

    return 'Unknown';
  }

  /// Get work status color from card data
  static Color getWorkStatusColorFromCard(Map<String, dynamic> cardData) {
    final isApproved = cardData['is_approved'] as bool? ?? false;
    final actualStart = cardData['actual_start_time'];
    final actualEnd = cardData['actual_end_time'];
    final isLate = cardData['is_late'] as bool? ?? false;

    if (!isApproved) {
      return TossColors.warning;
    }

    if (actualStart == null && actualEnd == null) {
      return TossColors.gray500;
    }

    if (actualStart != null && actualEnd == null) {
      return isLate ? TossColors.warning : TossColors.info;
    }

    if (actualStart != null && actualEnd != null) {
      return isLate ? TossColors.warning : TossColors.success;
    }

    return TossColors.gray500;
  }

  /// Format number with thousand separators
  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      final cleanValue = value.replaceAll(',', '');
      final parsed = int.tryParse(cleanValue);
      if (parsed != null) {
        return parsed.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]},',
        );
      }
      return value;
    }
    if (value is num) {
      return value.toInt().toString().replaceAllMapped(
        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
        (Match m) => '${m[1]},',
      );
    }
    return value.toString();
  }

  /// Format time from various formats to HH:mm
  /// Handles UTC to local time conversion
  static String formatTime(dynamic time, {String? requestDate}) {
    if (time == null || time.toString().isEmpty) {
      return '--:--';
    }

    final timeStr = time.toString();

    try {
      // Datetime string (UTC from DB - convert to local)
      if (timeStr.contains('T') || (timeStr.contains(' ') && timeStr.length > 10)) {
        DateTime dateTime;

        // PostgreSQL format: "2025-10-27 14:56:00"
        if (timeStr.contains(' ') && !timeStr.contains('T')) {
          final isoFormat = '${timeStr.replaceFirst(' ', 'T')}Z';
          dateTime = DateTimeUtils.toLocal(isoFormat);
        } else {
          dateTime = DateTimeUtils.toLocal(timeStr);
        }

        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // Time string (HH:mm:ss or HH:mm) from RPC
      if (timeStr.contains(':') && !timeStr.contains(' ') && timeStr.length <= 10) {
        if (requestDate != null && requestDate.isNotEmpty) {
          final utcTimestamp = '${requestDate}T${timeStr}Z';
          try {
            final dateTime = DateTimeUtils.toLocal(utcTimestamp);
            return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
          } catch (e) {
            final parts = timeStr.split(':');
            if (parts.length >= 2) {
              return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
            }
          }
        }

        // No request_date, return as-is
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }

      return timeStr;
    } catch (e) {
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }
      return '--:--';
    }
  }

  /// Format shift time range from UTC to local
  /// Input: "14:56 ~ 17:56" (UTC)
  /// Output: "21:56 ~ 00:56" (Local)
  static String formatShiftTime(String? shiftTime, {String? requestDate}) {
    if (shiftTime == null || shiftTime.isEmpty) {
      return '--:-- ~ --:--';
    }

    try {
      final parts = shiftTime.split('~').map((e) => e.trim()).toList();
      if (parts.length != 2) {
        return shiftTime;
      }

      final startTime = parts[0].trim();
      final endTime = parts[1].trim();

      final localStartTime = formatTime(startTime, requestDate: requestDate);
      final localEndTime = formatTime(endTime, requestDate: requestDate);

      return '$localStartTime ~ $localEndTime';
    } catch (e) {
      return shiftTime;
    }
  }

  /// Get full weekday name
  static String getWeekdayFull(int weekday) {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[weekday - 1];
  }

  /// Get short weekday name
  static String getWeekdayShort(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  /// Get month name from month number (1-12)
  static String getMonthName(int month) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    if (month < 1 || month > 12) return '';
    return months[month - 1];
  }

  /// Format date with weekday name
  /// e.g., "Mon, Dec 15 2025"
  static String formatDateWithDay(DateTime date) {
    final weekday = getWeekdayShort(date.weekday);
    final month = getMonthName(date.month);
    return '$weekday, ${month.substring(0, 3)} ${date.day} ${date.year}';
  }
}
