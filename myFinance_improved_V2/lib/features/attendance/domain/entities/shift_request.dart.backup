import 'attendance_location.dart';

/// Shift Request Entity
///
/// Represents a user's shift request with check-in/check-out details.
class ShiftRequest {
  final String shiftRequestId;
  final String userId;
  final String storeId;
  final String requestDate;
  final DateTime? scheduledStartTime;
  final DateTime? scheduledEndTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final AttendanceLocation? checkinLocation;
  final AttendanceLocation? checkoutLocation;
  final String status;
  final Map<String, dynamic>? storeShift;

  const ShiftRequest({
    required this.shiftRequestId,
    required this.userId,
    required this.storeId,
    required this.requestDate,
    this.scheduledStartTime,
    this.scheduledEndTime,
    this.actualStartTime,
    this.actualEndTime,
    this.checkinLocation,
    this.checkoutLocation,
    required this.status,
    this.storeShift,
  });

  /// Check if user has checked in
  bool get isCheckedIn => actualStartTime != null;

  /// Check if user has checked out
  bool get isCheckedOut => actualEndTime != null;

  /// Check if shift is currently active
  bool get isActive => isCheckedIn && !isCheckedOut;

  /// Calculate worked hours
  double get workedHours {
    if (actualStartTime == null || actualEndTime == null) return 0.0;
    final duration = actualEndTime!.difference(actualStartTime!);
    return duration.inMinutes / 60.0;
  }

  /// Copy with method for immutability
  ShiftRequest copyWith({
    String? shiftRequestId,
    String? userId,
    String? storeId,
    String? requestDate,
    DateTime? scheduledStartTime,
    DateTime? scheduledEndTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    AttendanceLocation? checkinLocation,
    AttendanceLocation? checkoutLocation,
    String? status,
    Map<String, dynamic>? storeShift,
  }) {
    return ShiftRequest(
      shiftRequestId: shiftRequestId ?? this.shiftRequestId,
      userId: userId ?? this.userId,
      storeId: storeId ?? this.storeId,
      requestDate: requestDate ?? this.requestDate,
      scheduledStartTime: scheduledStartTime ?? this.scheduledStartTime,
      scheduledEndTime: scheduledEndTime ?? this.scheduledEndTime,
      actualStartTime: actualStartTime ?? this.actualStartTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      checkinLocation: checkinLocation ?? this.checkinLocation,
      checkoutLocation: checkoutLocation ?? this.checkoutLocation,
      status: status ?? this.status,
      storeShift: storeShift ?? this.storeShift,
    );
  }

  @override
  String toString() => 'ShiftRequest(id: $shiftRequestId, date: $requestDate, status: $status)';
}
