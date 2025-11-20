import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';

/// Status helper functions for attendance UI
class StatusHelpers {
  /// Get color for main status
  static Color getStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.success; // Green
      case 'finished':
        return TossColors.primary; // Blue
      case 'scheduled':
        return TossColors.warning; // Orange
      case 'off_duty':
      default:
        return TossColors.gray400; // Gray
    }
  }

  /// Get text for main status
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

  /// Get color for activity status
  static Color getActivityStatusColor(String status) {
    switch (status) {
      case 'working':
        return TossColors.primary;
      case 'completed':
        return TossColors.success;
      case 'approved':
        return TossColors.success.withOpacity(0.7);
      case 'pending':
        return TossColors.warning;
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
  static String getWorkStatusFromCard(Map<String, dynamic> card) {
    final isApproved =
        card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
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
  static Color getWorkStatusColorFromCard(Map<String, dynamic> card) {
    final isApproved =
        card['is_approved'] ?? card['approval_status'] == 'approved' ?? false;
    final actualStart = card['confirm_start_time'] ?? card['actual_start_time'];
    final actualEnd = card['confirm_end_time'] ?? card['actual_end_time'];

    if (isApproved != true) {
      return TossColors.warning;
    }

    if (actualStart != null && actualEnd == null) {
      return TossColors.primary; // Blue - working
    } else if (actualStart != null && actualEnd != null) {
      return TossColors.success; // Green - completed
    } else {
      return TossColors.success.withOpacity(0.7); // Light green - approved
    }
  }
}
