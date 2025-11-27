import '../../../../../../core/utils/datetime_utils.dart';

/// Formatting helper functions for attendance UI
class FormatHelpers {
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
  ///
  /// IMPORTANT: RPC (user_shift_cards_v3) already converts times to local timezone
  /// using: to_char(time_column AT TIME ZONE p_timezone, 'HH24:MI')
  /// So NO additional UTC conversion is needed here - just format the time string
  static String formatTime(dynamic time, {String? requestDate}) {
    if (time == null || time.toString().isEmpty) {
      return '--:--';
    }

    final timeStr = time.toString();

    try {
      // Full datetime string with 'T' or space (e.g., "2025-10-27T14:56:00Z")
      // This case is for raw UTC timestamps that need conversion
      if (timeStr.contains('T') || (timeStr.contains(' ') && timeStr.length > 10)) {
        DateTime dateTime;

        if (timeStr.contains(' ') && !timeStr.contains('T')) {
          final isoFormat = '${timeStr.replaceFirst(' ', 'T')}Z';
          dateTime = DateTimeUtils.toLocal(isoFormat);
        } else {
          dateTime = DateTimeUtils.toLocal(timeStr);
        }

        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // Time string (HH:mm:ss or HH:mm) from RPC to_char()
      // RPC already converted to local time, so just format and return as-is
      if (timeStr.contains(':') && !timeStr.contains(' ') && timeStr.length <= 10) {
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

  /// Format shift time string (already in local time from RPC)
  /// Input: "09:30 ~ 15:30" (local time from RPC)
  /// Output: "09:30 ~ 15:30" (formatted, no conversion needed)
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
}
