import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';

/// Status helper functions for attendance UI
///
/// CLEAN ARCHITECTURE COMPLIANCE:
/// This class contains ONLY UI presentation logic (colors, text formatting).
/// Business logic for determining status is in Domain layer (ShiftCard.workStatus).
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
        return TossColors.success.withValues(alpha: 0.7);
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
}

/// Color mapper for ShiftCard work status
///
/// Maps work status from Domain entity to UI colors.
/// This is pure UI logic - no business rules.
class ShiftCardColorMapper {
  /// Get color based on work status string from ShiftCard.workStatus
  static Color forWorkStatus(String workStatus) {
    switch (workStatus) {
      case 'Working':
        return TossColors.primary; // Blue for working
      case 'Completed':
        return TossColors.success; // Green for completed
      case 'Approved':
        return TossColors.success.withValues(alpha: 0.7); // Lighter green for approved
      case 'Pending Approval':
        return TossColors.warning; // Orange for pending
      default:
        return TossColors.gray400; // Gray for unknown
    }
  }
}
