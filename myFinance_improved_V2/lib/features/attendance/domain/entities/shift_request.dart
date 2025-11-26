import 'attendance_location.dart';

/// Shift Request Entity - matches shift_requests table
class ShiftRequest {
  // Core fields
  final String shiftRequestId;
  final String userId;
  final String shiftId;
  final String storeId;
  final String requestDate;

  // Approval
  final bool? isApproved;
  final String? approvedBy;

  // Time fields
  final DateTime? startTime;
  final DateTime? endTime;
  final DateTime? actualStartTime;
  final DateTime? actualEndTime;
  final DateTime? confirmStartTime;
  final DateTime? confirmEndTime;

  // Status flags
  final bool? isLate;
  final bool? isExtratime;

  // Location
  final AttendanceLocation? checkinLocation;
  final double? checkinDistanceFromStore;
  final bool? isValidCheckinLocation;
  final AttendanceLocation? checkoutLocation;
  final double? checkoutDistanceFromStore;
  final bool? isValidCheckoutLocation;

  // Financial
  final double? overtimeAmount;
  final double? lateDeducutAmount;
  final double? bonusAmount;

  // Problem reporting
  final bool? isReported;
  final DateTime? reportTime;
  final String? problemType;
  final bool? isProblem;
  final bool isProblemSolved;
  final String? reportReason;

  // Metadata
  final Map<String, dynamic>? noticeTag;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ShiftRequest({
    required this.shiftRequestId,
    required this.userId,
    required this.shiftId,
    required this.storeId,
    required this.requestDate,
    this.isApproved,
    this.approvedBy,
    this.startTime,
    this.endTime,
    this.actualStartTime,
    this.actualEndTime,
    this.confirmStartTime,
    this.confirmEndTime,
    this.isLate,
    this.isExtratime,
    this.checkinLocation,
    this.checkinDistanceFromStore,
    this.isValidCheckinLocation,
    this.checkoutLocation,
    this.checkoutDistanceFromStore,
    this.isValidCheckoutLocation,
    this.overtimeAmount,
    this.lateDeducutAmount,
    this.bonusAmount,
    this.isReported,
    this.reportTime,
    this.problemType,
    this.isProblem,
    this.isProblemSolved = false,
    this.reportReason,
    this.noticeTag,
    this.createdAt,
    this.updatedAt,
  });

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

  /// Convert to JSON (for backward compatibility with Map-based code)
  Map<String, dynamic> toJson() {
    return {
      'shift_request_id': shiftRequestId,
      'user_id': userId,
      'shift_id': shiftId,
      'store_id': storeId,
      'request_date': requestDate,
      'is_approved': isApproved,
      'approved_by': approvedBy,
      'start_time': startTime?.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'actual_start_time': actualStartTime?.toIso8601String(),
      'actual_end_time': actualEndTime?.toIso8601String(),
      'confirm_start_time': confirmStartTime?.toIso8601String(),
      'confirm_end_time': confirmEndTime?.toIso8601String(),
      'is_late': isLate,
      'is_extratime': isExtratime,
      'checkin_location': checkinLocation?.toPostGIS(),
      'checkin_distance_from_store': checkinDistanceFromStore,
      'is_valid_checkin_location': isValidCheckinLocation,
      'checkout_location': checkoutLocation?.toPostGIS(),
      'checkout_distance_from_store': checkoutDistanceFromStore,
      'is_valid_checkout_location': isValidCheckoutLocation,
      'overtime_amount': overtimeAmount,
      'late_deducut_amount': lateDeducutAmount,
      'bonus_amount': bonusAmount,
      'is_reported': isReported,
      'report_time': reportTime?.toIso8601String(),
      'problem_type': problemType,
      'is_problem': isProblem,
      'is_problem_solved': isProblemSolved,
      'report_reason': reportReason,
      'notice_tag': noticeTag,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }

  /// Create from JSON
  factory ShiftRequest.fromJson(Map<String, dynamic> json) {
    return ShiftRequest(
      shiftRequestId: (json['shift_request_id'] as String?) ?? '',
      userId: (json['user_id'] as String?) ?? '',
      shiftId: (json['shift_id'] as String?) ?? '',
      storeId: (json['store_id'] as String?) ?? '',
      requestDate: (json['request_date'] as String?) ?? '',
      isApproved: json['is_approved'] as bool?,
      approvedBy: json['approved_by'] as String?,
      startTime: json['start_time'] != null ? DateTime.parse(json['start_time'] as String) : null,
      endTime: json['end_time'] != null ? DateTime.parse(json['end_time'] as String) : null,
      actualStartTime: json['actual_start_time'] != null ? DateTime.parse(json['actual_start_time'] as String) : null,
      actualEndTime: json['actual_end_time'] != null ? DateTime.parse(json['actual_end_time'] as String) : null,
      confirmStartTime: json['confirm_start_time'] != null ? DateTime.parse(json['confirm_start_time'] as String) : null,
      confirmEndTime: json['confirm_end_time'] != null ? DateTime.parse(json['confirm_end_time'] as String) : null,
      isLate: json['is_late'] as bool?,
      isExtratime: json['is_extratime'] as bool?,
      checkinLocation: json['checkin_location'] != null ? AttendanceLocation.fromPostGIS(json['checkin_location'] as String) : null,
      checkinDistanceFromStore: (json['checkin_distance_from_store'] as num?)?.toDouble(),
      isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
      checkoutLocation: json['checkout_location'] != null ? AttendanceLocation.fromPostGIS(json['checkout_location'] as String) : null,
      checkoutDistanceFromStore: (json['checkout_distance_from_store'] as num?)?.toDouble(),
      isValidCheckoutLocation: json['is_valid_checkout_location'] as bool?,
      overtimeAmount: (json['overtime_amount'] as num?)?.toDouble(),
      lateDeducutAmount: (json['late_deducut_amount'] as num?)?.toDouble(),
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble(),
      isReported: json['is_reported'] as bool?,
      reportTime: json['report_time'] != null ? DateTime.parse(json['report_time'] as String) : null,
      problemType: json['problem_type'] as String?,
      isProblem: json['is_problem'] as bool?,
      isProblemSolved: json['is_problem_solved'] as bool? ?? false,
      reportReason: json['report_reason'] as String?,
      noticeTag: json['notice_tag'] as Map<String, dynamic>?,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at'] as String) : null,
      updatedAt: json['updated_at'] != null ? DateTime.parse(json['updated_at'] as String) : null,
    );
  }

  @override
  String toString() => 'ShiftRequest(id: $shiftRequestId, date: $requestDate, approved: $isApproved)';
}
