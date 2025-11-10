import 'package:freezed_annotation/freezed_annotation.dart';

import 'shift.dart';
import 'shift_request.dart';

part 'daily_shift_data.freezed.dart';
part 'daily_shift_data.g.dart';

/// Daily Shift Data Entity
///
/// Represents all shifts and their requests for a specific date.
@freezed
class DailyShiftData with _$DailyShiftData {
  const DailyShiftData._();

  const factory DailyShiftData({
    /// Date in yyyy-MM-dd format
    required String date,
    @JsonKey(defaultValue: <ShiftWithRequests>[])
    required List<ShiftWithRequests> shifts,
  }) = _DailyShiftData;

  /// Create from JSON
  factory DailyShiftData.fromJson(Map<String, dynamic> json) =>
      _$DailyShiftDataFromJson(json);

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
    return shifts.isNotEmpty &&
        shifts.every((shift) => shift.shift.isFullyStaffed);
  }
}

/// Shift with Requests
///
/// Combines a shift with its pending and approved requests.
@freezed
class ShiftWithRequests with _$ShiftWithRequests {
  const ShiftWithRequests._();

  const factory ShiftWithRequests({
    required Shift shift,
    @JsonKey(name: 'pending_requests', defaultValue: <ShiftRequest>[])
    required List<ShiftRequest> pendingRequests,
    @JsonKey(name: 'approved_requests', defaultValue: <ShiftRequest>[])
    required List<ShiftRequest> approvedRequests,
  }) = _ShiftWithRequests;

  /// Create from JSON
  factory ShiftWithRequests.fromJson(Map<String, dynamic> json) =>
      _$ShiftWithRequestsFromJson(json);

  /// Get total requests (pending + approved)
  int get totalRequests => pendingRequests.length + approvedRequests.length;

  /// Check if shift has pending requests
  bool get hasPendingRequests => pendingRequests.isNotEmpty;

  /// Check if shift is under-staffed with pending requests
  bool get isUnderStaffedWithPending {
    return shift.isUnderStaffed && hasPendingRequests;
  }
}
