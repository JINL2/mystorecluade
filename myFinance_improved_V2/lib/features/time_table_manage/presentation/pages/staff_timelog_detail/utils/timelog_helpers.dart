import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Utility helpers for staff timelog detail page
class TimelogHelpers {
  /// Extract time (HH:mm:ss) from various string formats
  /// Handles:
  /// - ISO 8601: "2025-12-07T14:00:00.000" → "14:00:00"
  /// - Time only: "14:00:00" → "14:00:00"
  /// - Returns null if input is null or invalid
  static String? extractTimeFromString(String? input) {
    if (input == null || input.isEmpty) return null;

    // Check if it's ISO 8601 format (contains 'T')
    if (input.contains('T')) {
      try {
        final dateTime = DateTime.parse(input);
        final hour = dateTime.hour.toString().padLeft(2, '0');
        final minute = dateTime.minute.toString().padLeft(2, '0');
        final second = dateTime.second.toString().padLeft(2, '0');
        return '$hour:$minute:$second';
      } catch (_) {
        return null;
      }
    }

    // Already in time format (HH:mm:ss or HH:mm)
    if (input.contains(':')) {
      return input;
    }

    return null;
  }

  /// Parse time string "HH:MM:SS" to TimeOfDay and seconds
  /// Returns default time (00:00:00) if parsing fails
  static Map<String, dynamic> parseTime(String timeString) {
    try {
      final parts = timeString.split(':');
      if (parts.length < 2) {
        return {'time': const TimeOfDay(hour: 0, minute: 0), 'seconds': 0};
      }
      final hour = int.tryParse(parts[0]) ?? 0;
      final minute = int.tryParse(parts[1]) ?? 0;
      final seconds = parts.length > 2 ? (int.tryParse(parts[2]) ?? 0) : 0;
      return {
        'time': TimeOfDay(hour: hour, minute: minute),
        'seconds': seconds,
      };
    } catch (_) {
      return {'time': const TimeOfDay(hour: 0, minute: 0), 'seconds': 0};
    }
  }

  /// Format currency with Vietnamese dong
  static String formatCurrency(num? amount) {
    if (amount == null) return '--';
    return '${NumberFormat('#,###').format(amount.toInt())}₫';
  }

  /// Format hours to "Xh Ym" string
  static String formatHoursMinutes(double hours) {
    final h = hours.floor();
    final m = ((hours - h) * 60).round();
    return '${h}h ${m}m';
  }

  /// Parse date string and format as "Mon/DD"
  static String formatAsOfDate(String dateString) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    try {
      final date = DateTime.parse(dateString);
      return '${months[date.month - 1]}/${date.day}';
    } catch (_) {
      return dateString;
    }
  }
}
