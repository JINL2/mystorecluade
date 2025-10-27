import 'shift.dart';
import 'shift_request.dart';

/// Daily Shift Data Entity
///
/// Represents all shifts and their requests for a specific date.
class DailyShiftData {
  final String date; // yyyy-MM-dd
  final List<ShiftWithRequests> shifts;

  const DailyShiftData({
    required this.date,
    required this.shifts,
  });

  /// Check if date has any shifts
  bool get hasShifts => shifts.isNotEmpty;

  /// Get total number of shifts
  int get shiftCount => shifts.length;

  /// Get total pending requests across all shifts
  int get totalPendingRequests {
    return shifts.fold(0, (sum, shift) => sum + shift.pendingRequests.length);
  }

  /// Get total approved requests across all shifts
  int get totalApprovedRequests {
    return shifts.fold(0, (sum, shift) => sum + shift.approvedRequests.length);
  }

  /// Check if any shift has pending requests
  bool get hasPendingRequests => totalPendingRequests > 0;

  /// Check if any shift is under-staffed
  bool get hasUnderStaffedShifts {
    return shifts.any((shift) => shift.shift.isUnderStaffed);
  }

  /// Check if all shifts are fully staffed
  bool get allShiftsFullyStaffed {
    return shifts.isNotEmpty && shifts.every((shift) => shift.shift.isFullyStaffed);
  }

  @override
  String toString() => 'DailyShiftData(date: $date, shifts: $shiftCount)';
}

/// Shift with Requests
///
/// Combines a shift with its pending and approved requests.
class ShiftWithRequests {
  final Shift shift;
  final List<ShiftRequest> pendingRequests;
  final List<ShiftRequest> approvedRequests;

  const ShiftWithRequests({
    required this.shift,
    required this.pendingRequests,
    required this.approvedRequests,
  });

  /// Get total requests (pending + approved)
  int get totalRequests => pendingRequests.length + approvedRequests.length;

  /// Check if shift has pending requests
  bool get hasPendingRequests => pendingRequests.isNotEmpty;

  /// Check if shift is under-staffed with pending requests
  bool get isUnderStaffedWithPending {
    return shift.isUnderStaffed && hasPendingRequests;
  }

  @override
  String toString() => 'ShiftWithRequests(shift: ${shift.shiftId}, pending: ${pendingRequests.length}, approved: ${approvedRequests.length})';
}
