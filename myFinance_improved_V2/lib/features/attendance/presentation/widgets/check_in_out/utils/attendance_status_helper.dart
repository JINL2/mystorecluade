import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';

/// Helper class for attendance status colors and text
class AttendanceStatusHelper {
  /// Get status color for hero section
  static Color getStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.success; // Green for currently working
      case 'finished':
        return TossColors.primary; // Blue for finished shift
      case 'scheduled':
        return TossColors.warning; // Orange for has shift today
      case 'off_duty':
      default:
        return TossColors.gray400; // Gray for off duty
    }
  }

  /// Get status text for hero section
  static String getStatusText(String status) {
    switch (status) {
      case 'working':
        return 'Working';
      case 'finished':
        return 'Finished';
      case 'scheduled':
        return 'Shift Today';
      case 'off_duty':
      default:
        return 'Off Duty';
    }
  }

  /// Get activity status color for recent activity
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

  /// Get activity status text for recent activity
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

  /// Get work status color from card data
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
}
