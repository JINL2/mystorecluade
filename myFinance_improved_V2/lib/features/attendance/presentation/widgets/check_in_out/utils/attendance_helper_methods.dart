import 'package:flutter/material.dart';

import '../../../../../../core/utils/datetime_utils.dart';
import '../../../../../../shared/themes/toss_colors.dart';

/// Helper methods for attendance-related operations
class AttendanceHelpers {
  /// Format time from various formats to HH:mm
  /// Handles UTC to local time conversion
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

  /// Get color for activity status
  static Color getActivityStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.primary; // Blue for currently working
      case 'completed':
        return TossColors.success; // Green for completed shift
      case 'approved':
        return TossColors.success.withOpacity(0.7); // Lighter green for approved but not started
      case 'pending':
        return TossColors.warning; // Orange for pending approval
      default:
        return TossColors.gray400;
    }
  }

  /// Get text for activity status
  static String getActivityStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'completed':
        return 'Completed';
      case 'approved':
        return 'Approved';
      case 'pending':
        return 'Pending';
      default:
        return 'Unknown';
    }
  }

  /// Get work status text from card data
  ///
  /// ⚠️ DEPRECATED: This method contains business logic and should not be in Presentation layer
  /// TODO: Migrate to use ShiftCard.workStatus getter from Domain layer instead
  ///
  /// Clean Architecture violation: Business logic should be in Domain layer, not Presentation helpers
  @Deprecated('Use ShiftCard.workStatus getter instead. This will be removed in future version.')
  static String getWorkStatusFromCard(Map<String, dynamic> card) {
    final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
    final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
    final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];

    if (isApproved != true) {
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

  /// Get work status color from card data
  ///
  /// ⚠️ DEPRECATED: This method contains UI business logic and should use Domain entities
  /// TODO: Create a proper color mapping based on ShiftCard.workStatus
  ///
  /// Clean Architecture violation: Status determination should use Domain layer logic
  @Deprecated('Use ShiftCard.workStatus with separate color mapping. This will be removed in future version.')
  static Color getWorkStatusColorFromCard(Map<String, dynamic> card) {
    final isApproved = card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
    final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
    final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];

    if (isApproved != true) {
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

  /// Format number with comma separators
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
}
