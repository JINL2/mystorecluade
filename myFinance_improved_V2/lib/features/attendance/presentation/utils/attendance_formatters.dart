import 'package:flutter/material.dart';
import '../../../../core/utils/datetime_utils.dart';
import '../../../../shared/themes/toss_colors.dart';
import '../../domain/entities/shift_card_data.dart';

/// Utility class for formatting attendance-related data
///
/// Provides consistent formatting across all attendance widgets:
/// - Time formatting with UTC to local conversion
/// - Number formatting with thousand separators
/// - Work status determination and colors
class AttendanceFormatters {
  AttendanceFormatters._(); // Private constructor to prevent instantiation

  /// Format time string with UTC to local time conversion
  ///
  /// Handles multiple input formats:
  /// - ISO8601: "2025-10-27T14:56:00Z"
  /// - PostgreSQL: "2025-10-27 14:56:00"
  /// - Time only: "14:56:00" or "14:56"
  ///
  /// Returns: "HH:MM" format in local time
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
          final isoFormat = timeStr.replaceFirst(' ', 'T') + 'Z';
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

  /// Format number with thousand separators
  ///
  /// Examples:
  /// - 1000 → "1,000"
  /// - 1000000 → "1,000,000"
  /// - "12345" → "12,345"
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

  /// Get work status text from shift card
  ///
  /// Determines status based on approval and check-in/out times:
  /// - "Pending Approval" if not approved
  /// - "Working" if checked in but not out
  /// - "Completed" if checked in and out
  /// - "Approved" if approved but not started
  static String getWorkStatusFromCard(ShiftCardData card) {
    final isApproved = card.isApproved || card.approvalStatus == 'approved';
    final actualStart = card.confirmStartTime ?? card.actualStartTime;
    final actualEnd = card.confirmEndTime ?? card.actualEndTime;

    if (!isApproved) {
      return 'Pending Approval';
    }

    if (actualStart != null && actualEnd == null) {
      return 'Working';
    } else if (actualStart != null && actualEnd != null) {
      return 'Completed';
    } else {
      return 'Approved';
    }
  }

  /// Get work status color from shift card
  ///
  /// Returns appropriate color based on shift status:
  /// - Warning (orange) for pending approval
  /// - Primary (blue) for working
  /// - Success (green) for completed
  /// - Light green for approved but not started
  static Color getWorkStatusColorFromCard(ShiftCardData card) {
    final isApproved = card.isApproved || card.approvalStatus == 'approved';
    final actualStart = card.confirmStartTime ?? card.actualStartTime;
    final actualEnd = card.confirmEndTime ?? card.actualEndTime;

    if (!isApproved) {
      return TossColors.warning;
    }

    if (actualStart != null && actualEnd == null) {
      return TossColors.primary; // Blue for working
    } else if (actualStart != null && actualEnd != null) {
      return TossColors.success; // Green for completed
    } else {
      return TossColors.success.withOpacity(0.7); // Lighter green for approved
    }
  }
}
