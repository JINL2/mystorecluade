import '../../../../../../core/utils/datetime_utils.dart';

/// Utility class for attendance-related formatting functions
class AttendanceFormatters {
  /// Format a number with thousand separators
  ///
  /// Examples:
  /// - 1000 -> "1,000"
  /// - "5000" -> "5,000"
  /// - null -> "0"
  static String formatNumber(dynamic value) {
    if (value == null) return '0';
    if (value is String) {
      // Remove any existing commas and try to parse
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
  /// Handles:
  /// - ISO8601: "2025-10-27T14:56:00Z"
  /// - PostgreSQL: "2025-10-27 14:56:00"
  /// - Time string: "14:56:00" or "14:56"
  ///
  /// Converts UTC to local time when requestDate is provided
  static String formatTime(dynamic time, {String? requestDate}) {
    if (time == null || time.toString().isEmpty) {
      return '--:--';
    }

    final timeStr = time.toString();

    try {
      // If it's a datetime string (UTC from DB - need to convert to local time)
      // Handles both ISO8601 (2025-10-27T14:56:00Z) and PostgreSQL format (2025-10-27 14:56:00)
      if (timeStr.contains('T') || (timeStr.contains(' ') && timeStr.length > 10)) {
        DateTime dateTime;

        // PostgreSQL "timestamp without time zone" format: "2025-10-27 14:56:00"
        // We treat this as UTC and convert to local time
        if (timeStr.contains(' ') && !timeStr.contains('T')) {
          // Parse as UTC by adding 'Z' suffix
          final isoFormat = '${timeStr.replaceFirst(' ', 'T')}Z';
          dateTime = DateTimeUtils.toLocal(isoFormat);
        } else {
          // ISO8601 format with 'T'
          dateTime = DateTimeUtils.toLocal(timeStr);
        }

        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
      }

      // If it's just time string (HH:mm:ss or HH:mm) from RPC to_char()
      // We need to combine with request_date to convert from UTC to local time
      if (timeStr.contains(':') && !timeStr.contains(' ') && timeStr.length <= 10) {
        if (requestDate != null && requestDate.isNotEmpty) {
          // Combine date + time and treat as UTC
          final utcTimestamp = '${requestDate}T${timeStr}Z';
          try {
            final dateTime = DateTimeUtils.toLocal(utcTimestamp);
            return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
          } catch (e) {
            // If parsing fails, return time as-is
            final parts = timeStr.split(':');
            if (parts.length >= 2) {
              return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
            }
          }
        }

        // No request_date provided, return time as-is
        final parts = timeStr.split(':');
        if (parts.length >= 2) {
          return '${parts[0].padLeft(2, '0')}:${parts[1].padLeft(2, '0')}';
        }
      }

      return timeStr;
    } catch (e) {
      // If all parsing fails, try to extract HH:mm from the string
      if (timeStr.length >= 5) {
        return timeStr.substring(0, 5);
      }
      return '--:--';
    }
  }

  /// Convert shift time string from UTC to local time
  ///
  /// Input: "14:56 ~ 17:56" (UTC), requestDate: "2025-10-27"
  /// Output: "21:56 ~ 00:56" (Local time, Vietnam = UTC+7)
  static String formatShiftTime(String? shiftTime, {String? requestDate}) {
    if (shiftTime == null || shiftTime.isEmpty) {
      return '--:-- ~ --:--';
    }

    try {
      // Parse shift time format: "14:56 ~ 17:56"
      final parts = shiftTime.split('~').map((e) => e.trim()).toList();
      if (parts.length != 2) {
        return shiftTime; // Return as-is if format is unexpected
      }

      final startTime = parts[0].trim();
      final endTime = parts[1].trim();

      // Convert each time using formatTime with requestDate
      final localStartTime = formatTime(startTime, requestDate: requestDate);
      final localEndTime = formatTime(endTime, requestDate: requestDate);

      return '$localStartTime ~ $localEndTime';
    } catch (e) {
      return shiftTime; // Return original if conversion fails
    }
  }

  /// Get short weekday name (Mon, Tue, etc.)
  static String getWeekdayShort(int weekday) {
    const weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return weekdays[weekday - 1];
  }

  /// Get full weekday name (Monday, Tuesday, etc.)
  static String getWeekdayFull(int weekday) {
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    return weekdays[weekday - 1];
  }

  /// Get month name
  static String getMonthName(int month) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return months[month - 1];
  }

  /// Get status display text
  static String getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'rejected':
        return 'Rejected';
      case 'cancelled':
        return 'Cancelled';
      case 'checked_in':
        return 'Checked In';
      case 'checked_out':
        return 'Completed';
      case 'no_show':
        return 'No Show';
      case 'issue_reported':
        return 'Issue Reported';
      default:
        return status;
    }
  }

  /// Get activity status display text
  static String getActivityStatusText(String status) {
    switch (status) {
      case 'requested':
        return 'Shift Requested';
      case 'approved':
        return 'Shift Approved';
      case 'checked_in':
        return 'Checked In';
      case 'checked_out':
        return 'Checked Out';
      case 'completed':
        return 'Shift Completed';
      default:
        return status;
    }
  }

  /// Get work status from card data
  static String getWorkStatusFromCard(Map<String, dynamic> card) {
    final status = card['approval_status']?.toString() ?? 'pending';
    final checkInTime = card['check_in_time'];
    final checkOutTime = card['check_out_time'];

    if (checkOutTime != null) {
      return 'completed';
    } else if (checkInTime != null) {
      return 'working';
    } else if (status == 'approved') {
      return 'scheduled';
    } else if (status == 'pending') {
      return 'pending';
    } else {
      return status;
    }
  }
}
