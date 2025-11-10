import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/datetime_utils.dart';
import '../../domain/entities/attendance_location.dart';
import '../../domain/entities/shift_request.dart';
import '../mappers/location_mapper.dart';

part 'shift_request_model.freezed.dart';

/// Shift Request Model (DTO)
///
/// Data Transfer Object for ShiftRequest entity.
/// Handles JSON serialization/deserialization with UTC/Local time conversion.
/// Does NOT extend entity - proper separation of concerns.
@freezed
class ShiftRequestModel with _$ShiftRequestModel {
  const ShiftRequestModel._();

  const factory ShiftRequestModel({
    required String shiftRequestId,
    required String userId,
    required String storeId,
    required String requestDate,
    DateTime? scheduledStartTime,
    DateTime? scheduledEndTime,
    DateTime? actualStartTime,
    DateTime? actualEndTime,
    AttendanceLocation? checkinLocation,
    AttendanceLocation? checkoutLocation,
    required String status,
    Map<String, dynamic>? storeShift,
  }) = _ShiftRequestModel;

  /// Create from JSON
  ///
  /// **중요:** DB에서 가져온 UTC 시간을 로컬 시간으로 자동 변환합니다.
  factory ShiftRequestModel.fromJson(Map<String, dynamic> json) {
    return ShiftRequestModel(
      shiftRequestId: json['shift_request_id'] as String,
      userId: json['user_id'] as String,
      storeId: json['store_id'] as String,
      requestDate: json['request_date'] as String,
      // Convert UTC to local time using DateTimeUtils
      scheduledStartTime: json['scheduled_start_time'] != null
          ? DateTimeUtils.toLocal(json['scheduled_start_time'] as String)
          : null,
      scheduledEndTime: json['scheduled_end_time'] != null
          ? DateTimeUtils.toLocal(json['scheduled_end_time'] as String)
          : null,
      actualStartTime: json['actual_start_time'] != null
          ? DateTimeUtils.toLocal(json['actual_start_time'] as String)
          : null,
      actualEndTime: json['actual_end_time'] != null
          ? DateTimeUtils.toLocal(json['actual_end_time'] as String)
          : null,
      checkinLocation: LocationParser.fromPostGISPoint(json['checkin_location']),
      checkoutLocation: LocationParser.fromPostGISPoint(json['checkout_location']),
      status: json['status'] as String? ?? 'pending',
      storeShift: json['store_shifts'] as Map<String, dynamic>?,
    );
  }

  /// Convert to JSON
  ///
  /// **중요:** 로컬 시간을 UTC로 변환하여 DB에 저장합니다.
  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'user_id': userId,
      'store_id': storeId,
      'request_date': requestDate,
      // Convert local time to UTC using DateTimeUtils
      'scheduled_start_time': scheduledStartTime != null
          ? DateTimeUtils.toUtc(scheduledStartTime!)
          : null,
      'scheduled_end_time': scheduledEndTime != null
          ? DateTimeUtils.toUtc(scheduledEndTime!)
          : null,
      'actual_start_time': actualStartTime != null
          ? DateTimeUtils.toUtc(actualStartTime!)
          : null,
      'actual_end_time': actualEndTime != null
          ? DateTimeUtils.toUtc(actualEndTime!)
          : null,
      'checkin_location': checkinLocation?.toPostGISPoint(),
      'checkout_location': checkoutLocation?.toPostGISPoint(),
      'status': status,
      'store_shifts': storeShift,
    };
  }

  /// Convert Model to Entity (Mapper pattern)
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
