import 'package:flutter/material.dart';
import '../../../../../../shared/themes/toss_colors.dart';
import '../../../../domain/usecases/get_shift_work_status.dart';
import '../../../../domain/value_objects/shift_status.dart';

/// Helper class for attendance status colors and text
///
/// ✅ Clean Architecture: This is a pure UI helper that maps Domain concepts to UI elements.
/// Business logic has been extracted to Domain UseCase: GetShiftWorkStatus
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
  ///
  /// ✅ Clean Architecture: Business logic delegated to Domain UseCase
  /// This method now only handles UI mapping (Domain Status → UI Color)
  static Color getWorkStatusColorFromCard(Map<String, dynamic> card) {
    // Use Domain UseCase to determine status (business logic)
    final getShiftWorkStatus = GetShiftWorkStatus();
    final status = getShiftWorkStatus.fromMap(card);

    // Pure UI mapping: Status → Color
    return getWorkStatusColorFromStatus(status);
  }

  /// Get work status color from ShiftStatus enum
  ///
  /// Pure UI mapping without business logic
  static Color getWorkStatusColorFromStatus(ShiftStatus status) {
    switch (status) {
      case ShiftStatus.working:
        return TossColors.primary; // Blue for working
      case ShiftStatus.finished:
        return TossColors.success; // Green for completed
      case ShiftStatus.scheduled:
        return TossColors.success.withOpacity(0.7); // Lighter green for approved/pending
      case ShiftStatus.offDuty:
        return TossColors.gray400; // Gray for off duty
    }
  }
}
