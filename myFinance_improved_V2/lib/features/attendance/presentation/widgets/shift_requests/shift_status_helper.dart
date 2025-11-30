import 'package:intl/intl.dart';

import '../../../domain/entities/monthly_shift_status.dart';
import '../../../domain/entities/shift_metadata.dart';
import '../../widgets/shift_signup/shift_signup_card.dart';

/// Helper class for shift status determination
class ShiftStatusHelper {
  final List<MonthlyShiftStatus>? monthlyShiftStatus;
  final String currentUserId;

  ShiftStatusHelper({
    required this.monthlyShiftStatus,
    required this.currentUserId,
  });

  /// Get DailyShift data for selected date and shift
  DailyShift? getDailyShiftData(String shiftId, DateTime selectedDate) {
    if (monthlyShiftStatus == null) return null;

    final dateStr = DateFormat('yyyy-MM-dd').format(selectedDate);
    for (final dayStatus in monthlyShiftStatus!) {
      if (dayStatus.requestDate == dateStr) {
        for (final shift in dayStatus.shifts) {
          if (shift.shiftId == shiftId) {
            return shift;
          }
        }
      }
    }
    return null;
  }

  /// Determine shift status based on real data
  ShiftSignupStatus getShiftStatus(ShiftMetadata shift, DateTime selectedDate) {
    final dailyShift = getDailyShiftData(shift.shiftId, selectedDate);

    if (dailyShift == null) {
      // No data for this shift on selected date - available
      return ShiftSignupStatus.available;
    }

    // Check if user is in approved employees
    final isApproved = dailyShift.approvedEmployees.any((e) => e.userId == currentUserId);
    if (isApproved) {
      return ShiftSignupStatus.assigned;
    }

    // Check if user is in pending employees
    final isPending = dailyShift.pendingEmployees.any((e) => e.userId == currentUserId);
    if (isPending) {
      return ShiftSignupStatus.applied;
    }

    // Check if shift is full (no available slots)
    if (!dailyShift.hasAvailableSlots) {
      return ShiftSignupStatus.waitlist;
    }

    return ShiftSignupStatus.available;
  }

  /// Check if user applied to this shift (pending status)
  bool getUserApplied(ShiftMetadata shift, DateTime selectedDate) {
    final dailyShift = getDailyShiftData(shift.shiftId, selectedDate);

    if (dailyShift == null) return false;

    return dailyShift.pendingEmployees.any((e) => e.userId == currentUserId);
  }

  /// Format time range from "HH:mm:ss" to "HH:mm - HH:mm"
  /// RPC returns local time, no conversion needed
  static String formatTimeRange(String startTime, String endTime) {
    try {
      // Extract HH:mm from "HH:mm:ss" format
      final start = startTime.length >= 5 ? startTime.substring(0, 5) : startTime;
      final end = endTime.length >= 5 ? endTime.substring(0, 5) : endTime;
      return '$start - $end';
    } catch (_) {
      return '$startTime - $endTime';
    }
  }
}
