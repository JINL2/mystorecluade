// lib/features/attendance/domain/entities/shift_card_data.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_card_data.freezed.dart';

/// Domain entity representing a shift card with all relevant data
///
/// This replaces the Map<String, dynamic> used throughout the codebase,
/// providing type safety and eliminating runtime errors.
@freezed
class ShiftCardData with _$ShiftCardData {
  const ShiftCardData._();

  const factory ShiftCardData({
    @JsonKey(name: 'shift_request_id') required String shiftRequestId,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'shift_id') required String shiftId,
    @JsonKey(name: 'request_date') required String requestDate,
    @JsonKey(name: 'request_month') required String requestMonth,
    @JsonKey(name: 'shift_time') required String shiftTime,
    @JsonKey(name: 'shift_start_time') DateTime? shiftStartTime,
    @JsonKey(name: 'shift_end_time') DateTime? shiftEndTime,
    @JsonKey(name: 'actual_start_time') DateTime? actualStartTime,
    @JsonKey(name: 'actual_end_time') DateTime? actualEndTime,
    @JsonKey(name: 'confirm_start_time') DateTime? confirmStartTime,
    @JsonKey(name: 'confirm_end_time') DateTime? confirmEndTime,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'is_reported') @Default(false) bool isReported,
    @JsonKey(name: 'approval_status') String? approvalStatus,
    @JsonKey(name: 'report_reason') String? reportReason,
    @JsonKey(name: 'store_name') String? storeName,
    @JsonKey(name: 'shift_name') String? shiftName,
    @JsonKey(name: 'late_minutes') @Default(0) int lateMinutes,
    @JsonKey(name: 'overtime_minutes') @Default(0) int overtimeMinutes,
    @JsonKey(name: 'worked_minutes') int? workedMinutes,
    @JsonKey(name: 'scheduled_hours') double? scheduledHours,
    @JsonKey(name: 'paid_hours') double? paidHours,
    @JsonKey(name: 'salary_type') String? salaryType,
    @JsonKey(name: 'salary_amount') double? salaryAmount,
    @JsonKey(name: 'base_pay') double? basePay,
    @JsonKey(name: 'bonus_amount') double? bonusAmount,
    @JsonKey(name: 'total_pay_with_bonus') double? totalPayWithBonus,
    @JsonKey(name: 'created_at') DateTime? createdAt,
    @JsonKey(name: 'updated_at') DateTime? updatedAt,
  }) = _ShiftCardData;

  /// Create from JSON with safe defaults
  factory ShiftCardData.fromJson(Map<String, dynamic> json) {
    // Handle alternative field names and provide safe defaults
    final isApprovedValue = json['is_approved'] ??
                           (json['approval_status'] == 'approved') ??
                           false;

    return ShiftCardData(
      shiftRequestId: json['shift_request_id']?.toString() ?? '',
      userId: json['user_id']?.toString() ?? '',
      storeId: json['store_id']?.toString() ?? '',
      shiftId: json['shift_id']?.toString() ?? '',
      requestDate: json['request_date']?.toString() ?? '',
      requestMonth: json['request_month']?.toString() ?? '',
      shiftTime: json['shift_time']?.toString() ?? '--:-- ~ --:--',
      shiftStartTime: _parseDateTime(json['shift_start_time']),
      shiftEndTime: _parseDateTime(json['shift_end_time']),
      actualStartTime: _parseDateTime(json['actual_start_time']),
      actualEndTime: _parseDateTime(json['actual_end_time']),
      confirmStartTime: _parseDateTime(json['confirm_start_time']),
      confirmEndTime: _parseDateTime(json['confirm_end_time']),
      isApproved: isApprovedValue is bool ? isApprovedValue : false,
      isReported: json['is_reported'] is bool ? json['is_reported'] as bool : false,
      approvalStatus: json['approval_status']?.toString(),
      reportReason: json['report_reason']?.toString(),
      storeName: json['store_name']?.toString(),
      shiftName: json['shift_name']?.toString(),
      lateMinutes: _parseInt(json['late_minutes']) ?? 0,
      overtimeMinutes: _parseInt(json['overtime_minutes']) ?? 0,
      workedMinutes: _parseInt(json['worked_minutes']),
      scheduledHours: _parseDouble(json['scheduled_hours']),
      paidHours: _parseDouble(json['paid_hours']),
      salaryType: json['salary_type']?.toString(),
      salaryAmount: _parseDouble(json['salary_amount']),
      basePay: _parseDouble(json['base_pay']),
      bonusAmount: _parseDouble(json['bonus_amount']),
      totalPayWithBonus: _parseDouble(json['total_pay_with_bonus']),
      createdAt: _parseDateTime(json['created_at']),
      updatedAt: _parseDateTime(json['updated_at']),
    );
  }

  /// Calculate work status based on timestamps and approval
  WorkStatus get workStatus {
    if (!isApproved) return WorkStatus.pending;
    if (actualStartTime != null && actualEndTime == null) {
      return WorkStatus.working;
    }
    if (actualStartTime != null && actualEndTime != null) {
      return WorkStatus.completed;
    }
    return WorkStatus.approved;
  }

  /// Check if shift is currently active
  bool get isActive => workStatus == WorkStatus.working;

  /// Check if shift is completed
  bool get isCompleted => workStatus == WorkStatus.completed;

  /// Get worked duration if available
  Duration? get workedDuration {
    if (actualStartTime != null && actualEndTime != null) {
      return actualEndTime!.difference(actualStartTime!);
    }
    return null;
  }

  /// Get overtime duration if available
  Duration? get overtimeDuration {
    if (overtimeMinutes != null && overtimeMinutes! > 0) {
      return Duration(minutes: overtimeMinutes!);
    }
    return null;
  }

  // Helper methods for parsing
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

  static int? _parseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _parseDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }
}

/// Work status enum for type safety
enum WorkStatus {
  pending,   // Not yet approved
  approved,  // Approved but not started
  working,   // Currently working (checked in)
  completed, // Finished working (checked out)
}
