// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftCardImpl _$$ShiftCardImplFromJson(Map<String, dynamic> json) =>
    _$ShiftCardImpl(
      shiftRequestId: json['shift_request_id'] as String,
      employee: EmployeeInfo.fromJson(json['employee'] as Map<String, dynamic>),
      shift: Shift.fromJson(json['shift'] as Map<String, dynamic>),
      requestDate: json['request_date'] as String,
      isApproved: json['is_approved'] as bool,
      hasProblem: json['is_problem'] as bool,
      isProblemSolved: json['is_problem_solved'] as bool? ?? false,
      isLate: json['is_late'] as bool? ?? false,
      lateMinute: (json['late_minute'] as num?)?.toInt() ?? 0,
      isOverTime: json['is_over_time'] as bool? ?? false,
      overTimeMinute: (json['over_time_minute'] as num?)?.toInt() ?? 0,
      paidHour: (json['paid_hour'] as num?)?.toDouble() ?? 0.0,
      isReported: json['is_reported'] as bool? ?? false,
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble(),
      bonusReason: json['bonus_reason'] as String?,
      confirmedStartTime: json['confirm_start_time'] == null
          ? null
          : DateTime.parse(json['confirm_start_time'] as String),
      confirmedEndTime: json['confirm_end_time'] == null
          ? null
          : DateTime.parse(json['confirm_end_time'] as String),
      actualStartTime: json['actual_start'] == null
          ? null
          : DateTime.parse(json['actual_start'] as String),
      actualEndTime: json['actual_end'] == null
          ? null
          : DateTime.parse(json['actual_end'] as String),
      isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
      checkinDistanceFromStore:
          (json['checkin_distance_from_store'] as num?)?.toDouble(),
      isValidCheckoutLocation: json['is_valid_checkout_location'] as bool?,
      checkoutDistanceFromStore:
          (json['checkout_distance_from_store'] as num?)?.toDouble(),
      salaryType: json['salary_type'] as String?,
      salaryAmount: json['salary_amount'] as String?,
      tags: (json['notice_tag'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      problemType: json['problem_type'] as String?,
      reportReason: json['report_reason'] as String?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.parse(json['created_at'] as String),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
    );

Map<String, dynamic> _$$ShiftCardImplToJson(_$ShiftCardImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'employee': instance.employee,
      'shift': instance.shift,
      'request_date': instance.requestDate,
      'is_approved': instance.isApproved,
      'is_problem': instance.hasProblem,
      'is_problem_solved': instance.isProblemSolved,
      'is_late': instance.isLate,
      'late_minute': instance.lateMinute,
      'is_over_time': instance.isOverTime,
      'over_time_minute': instance.overTimeMinute,
      'paid_hour': instance.paidHour,
      'is_reported': instance.isReported,
      'bonus_amount': instance.bonusAmount,
      'bonus_reason': instance.bonusReason,
      'confirm_start_time': instance.confirmedStartTime?.toIso8601String(),
      'confirm_end_time': instance.confirmedEndTime?.toIso8601String(),
      'actual_start': instance.actualStartTime?.toIso8601String(),
      'actual_end': instance.actualEndTime?.toIso8601String(),
      'is_valid_checkin_location': instance.isValidCheckinLocation,
      'checkin_distance_from_store': instance.checkinDistanceFromStore,
      'is_valid_checkout_location': instance.isValidCheckoutLocation,
      'checkout_distance_from_store': instance.checkoutDistanceFromStore,
      'salary_type': instance.salaryType,
      'salary_amount': instance.salaryAmount,
      'notice_tag': instance.tags,
      'problem_type': instance.problemType,
      'report_reason': instance.reportReason,
      'created_at': instance.createdAt?.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
    };
