import 'package:freezed_annotation/freezed_annotation.dart';

import 'attendance_location.dart';

part 'shift_request.freezed.dart';

/// Shift Request Entity - Pure business object
///
/// Represents a shift request with all business logic.
/// Does NOT contain JSON serialization - that's handled by ShiftRequestModel in Data layer.
@freezed
class ShiftRequest with _$ShiftRequest {
  const ShiftRequest._();

  const factory ShiftRequest({
    // Core fields
    required String shiftRequestId,
    required String userId,
    required String shiftId,
    required String storeId,
    required String requestDate,

    // Approval
    bool? isApproved,
    String? approvedBy,

    // Time fields
    DateTime? startTime,
    DateTime? endTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    DateTime? confirmStartTime,
    DateTime? confirmEndTime,

    // Status flags
    bool? isLate,
    bool? isExtratime,

    // Location
    AttendanceLocation? checkinLocation,
    double? checkinDistanceFromStore,
    bool? isValidCheckinLocation,
    AttendanceLocation? checkoutLocation,
    double? checkoutDistanceFromStore,
    bool? isValidCheckoutLocation,

    // Financial
    double? overtimeAmount,
    double? lateDeducutAmount,
    double? bonusAmount,

    // Problem reporting
    bool? isReported,
    DateTime? reportTime,
    String? problemType,
    bool? isProblem,
    @Default(false) bool isProblemSolved,
    String? reportReason,

    // Metadata
    Map<String, dynamic>? noticeTag,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _ShiftRequest;

  // ========================================
  // Business Logic Methods
  // ========================================

  /// Check if user has checked in
  bool get isCheckedIn => actualStartTime != null || confirmStartTime != null;

  /// Check if user has checked out
  bool get isCheckedOut => actualEndTime != null || confirmEndTime != null;

  /// Check if shift is currently active
  bool get isActive => isCheckedIn && !isCheckedOut;

  /// Get actual or confirmed start time
  DateTime? get effectiveStartTime => confirmStartTime ?? actualStartTime;

  /// Get actual or confirmed end time
  DateTime? get effectiveEndTime => confirmEndTime ?? actualEndTime;

  /// Calculate worked hours
  double get workedHours {
    final start = effectiveStartTime;
    final end = effectiveEndTime;
    if (start == null || end == null) return 0.0;
    final duration = end.difference(start);
    return duration.inMinutes / 60.0;
  }

  /// Check if shift has location issues
  bool get hasLocationIssues =>
      (isValidCheckinLocation == false) ||
      (isValidCheckoutLocation == false) ||
      (checkinDistanceFromStore != null && checkinDistanceFromStore! > 100) ||
      (checkoutDistanceFromStore != null && checkoutDistanceFromStore! > 100);

  /// Get shift status string
  String get statusString {
    if (!isCheckedIn) return 'Not Started';
    if (!isCheckedOut) return 'In Progress';
    if (isProblem == true && !isProblemSolved) return 'Has Issues';
    return 'Completed';
  }
}
