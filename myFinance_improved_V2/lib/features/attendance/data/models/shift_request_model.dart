import '../../domain/entities/attendance_location.dart';
import '../../domain/entities/shift_request.dart';

/// Shift Request Model (DTO + Mapper)
///
/// Handles JSON serialization/deserialization for ShiftRequest entity.
/// This separates data concerns from domain logic.
class ShiftRequestModel {
  final ShiftRequest _entity;

  ShiftRequestModel(this._entity);

  /// Create from Entity
  factory ShiftRequestModel.fromEntity(ShiftRequest entity) {
    return ShiftRequestModel(entity);
  }

  /// Convert to Entity
  ShiftRequest toEntity() => _entity;

  /// Create from JSON
  factory ShiftRequestModel.fromJson(Map<String, dynamic> json) {
    return ShiftRequestModel(
      ShiftRequest(
        shiftRequestId: (json['shift_request_id'] as String?) ?? '',
        userId: (json['user_id'] as String?) ?? '',
        shiftId: (json['shift_id'] as String?) ?? '',
        storeId: (json['store_id'] as String?) ?? '',
        requestDate: (json['request_date'] as String?) ?? '',
        isApproved: json['is_approved'] as bool?,
        approvedBy: json['approved_by'] as String?,
        startTime: _parseDateTime(json['start_time']),
        endTime: _parseDateTime(json['end_time']),
        actualStartTime: _parseDateTime(json['actual_start_time']),
        actualEndTime: _parseDateTime(json['actual_end_time']),
        confirmStartTime: _parseDateTime(json['confirm_start_time']),
        confirmEndTime: _parseDateTime(json['confirm_end_time']),
        isLate: json['is_late'] as bool?,
        isExtratime: json['is_extratime'] as bool?,
        checkinLocation: _parseLocation(json['checkin_location']),
        checkinDistanceFromStore:
            (json['checkin_distance_from_store'] as num?)?.toDouble(),
        isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
        checkoutLocation: _parseLocation(json['checkout_location']),
        checkoutDistanceFromStore:
            (json['checkout_distance_from_store'] as num?)?.toDouble(),
        isValidCheckoutLocation: json['is_valid_checkout_location'] as bool?,
        overtimeAmount: (json['overtime_amount'] as num?)?.toDouble(),
        lateDeducutAmount: (json['late_deducut_amount'] as num?)?.toDouble(),
        bonusAmount: (json['bonus_amount'] as num?)?.toDouble(),
        isReported: json['is_reported'] as bool?,
        reportTime: _parseDateTime(json['report_time']),
        problemType: json['problem_type'] as String?,
        isProblem: json['is_problem'] as bool?,
        isProblemSolved: json['is_problem_solved'] as bool? ?? false,
        reportReason: json['report_reason'] as String?,
        noticeTag: json['notice_tag'] as Map<String, dynamic>?,
        createdAt: _parseDateTime(json['created_at']),
        updatedAt: _parseDateTime(json['updated_at']),
      ),
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': _entity.shiftRequestId,
      'user_id': _entity.userId,
      'shift_id': _entity.shiftId,
      'store_id': _entity.storeId,
      'request_date': _entity.requestDate,
      'is_approved': _entity.isApproved,
      'approved_by': _entity.approvedBy,
      'start_time': _entity.startTime?.toIso8601String(),
      'end_time': _entity.endTime?.toIso8601String(),
      'actual_start_time': _entity.actualStartTime?.toIso8601String(),
      'actual_end_time': _entity.actualEndTime?.toIso8601String(),
      'confirm_start_time': _entity.confirmStartTime?.toIso8601String(),
      'confirm_end_time': _entity.confirmEndTime?.toIso8601String(),
      'is_late': _entity.isLate,
      'is_extratime': _entity.isExtratime,
      'checkin_location': _entity.checkinLocation?.toPostGIS(),
      'checkin_distance_from_store': _entity.checkinDistanceFromStore,
      'is_valid_checkin_location': _entity.isValidCheckinLocation,
      'checkout_location': _entity.checkoutLocation?.toPostGIS(),
      'checkout_distance_from_store': _entity.checkoutDistanceFromStore,
      'is_valid_checkout_location': _entity.isValidCheckoutLocation,
      'overtime_amount': _entity.overtimeAmount,
      'late_deducut_amount': _entity.lateDeducutAmount,
      'bonus_amount': _entity.bonusAmount,
      'is_reported': _entity.isReported,
      'report_time': _entity.reportTime?.toIso8601String(),
      'problem_type': _entity.problemType,
      'is_problem': _entity.isProblem,
      'is_problem_solved': _entity.isProblemSolved,
      'report_reason': _entity.reportReason,
      'notice_tag': _entity.noticeTag,
      'created_at': _entity.createdAt?.toIso8601String(),
      'updated_at': _entity.updatedAt?.toIso8601String(),
    };
  }

  // ========================================
  // Private Helper Methods
  // ========================================

  /// Parse DateTime from JSON string
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }

  /// Parse AttendanceLocation from PostGIS string
  static AttendanceLocation? _parseLocation(dynamic value) {
    if (value == null) return null;
    if (value is String) {
      try {
        return AttendanceLocation.fromPostGIS(value);
      } catch (e) {
        return null;
      }
    }
    return null;
  }
}
