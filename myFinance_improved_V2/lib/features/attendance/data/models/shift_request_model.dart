import '../../domain/entities/shift_request.dart';
import '../../domain/entities/attendance_location.dart';

/// Shift Request Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for ShiftRequest entity.
class ShiftRequestModel extends ShiftRequest {
  const ShiftRequestModel({
    required super.shiftRequestId,
    required super.userId,
    required super.storeId,
    required super.requestDate,
    super.scheduledStartTime,
    super.scheduledEndTime,
    super.actualStartTime,
    super.actualEndTime,
    super.checkinLocation,
    super.checkoutLocation,
    required super.status,
    super.storeShift,
  });

  /// Create from JSON
  factory ShiftRequestModel.fromJson(Map<String, dynamic> json) {
    return ShiftRequestModel(
      shiftRequestId: json['shift_request_id'] as String,
      userId: json['user_id'] as String,
      storeId: json['store_id'] as String,
      requestDate: json['request_date'] as String,
      scheduledStartTime: json['scheduled_start_time'] != null
          ? DateTime.parse(json['scheduled_start_time'] as String)
          : null,
      scheduledEndTime: json['scheduled_end_time'] != null
          ? DateTime.parse(json['scheduled_end_time'] as String)
          : null,
      actualStartTime: json['actual_start_time'] != null
          ? DateTime.parse(json['actual_start_time'] as String)
          : null,
      actualEndTime: json['actual_end_time'] != null
          ? DateTime.parse(json['actual_end_time'] as String)
          : null,
      checkinLocation: _parseLocation(json['checkin_location']),
      checkoutLocation: _parseLocation(json['checkout_location']),
      status: json['status'] as String? ?? 'pending',
      storeShift: json['store_shifts'] as Map<String, dynamic>?,
    );
  }

  /// Parse PostGIS POINT to AttendanceLocation
  static AttendanceLocation? _parseLocation(dynamic locationData) {
    if (locationData == null) return null;

    // Handle PostGIS POINT format: "POINT(lng lat)"
    if (locationData is String) {
      final regex = RegExp(r'POINT\((-?\d+\.?\d*)\s+(-?\d+\.?\d*)\)');
      final match = regex.firstMatch(locationData);
      if (match != null) {
        final lng = double.parse(match.group(1)!);
        final lat = double.parse(match.group(2)!);
        return AttendanceLocation(latitude: lat, longitude: lng);
      }
    }

    return null;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'user_id': userId,
      'store_id': storeId,
      'request_date': requestDate,
      'scheduled_start_time': scheduledStartTime?.toIso8601String(),
      'scheduled_end_time': scheduledEndTime?.toIso8601String(),
      'actual_start_time': actualStartTime?.toIso8601String(),
      'actual_end_time': actualEndTime?.toIso8601String(),
      'checkin_location': checkinLocation?.toPostGISPoint(),
      'checkout_location': checkoutLocation?.toPostGISPoint(),
      'status': status,
      'store_shifts': storeShift,
    };
  }

  /// Convert to entity
  ShiftRequest toEntity() {
    return ShiftRequest(
      shiftRequestId: shiftRequestId,
      userId: userId,
      storeId: storeId,
      requestDate: requestDate,
      scheduledStartTime: scheduledStartTime,
      scheduledEndTime: scheduledEndTime,
      actualStartTime: actualStartTime,
      actualEndTime: actualEndTime,
      checkinLocation: checkinLocation,
      checkoutLocation: checkoutLocation,
      status: status,
      storeShift: storeShift,
    );
  }
}
