// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftCardImpl _$$ShiftCardImplFromJson(Map<String, dynamic> json) =>
    _$ShiftCardImpl(
      requestDate: json['request_date'] as String,
      shiftRequestId: json['shift_request_id'] as String,
      shiftTime: json['shift_time'] as String,
      storeName: json['store_name'] as String,
      scheduledHours: (json['scheduled_hours'] as num).toDouble(),
      isApproved: json['is_approved'] as bool,
      actualStartTime: json['actual_start_time'] as String?,
      actualEndTime: json['actual_end_time'] as String?,
      confirmStartTime: json['confirm_start_time'] as String?,
      confirmEndTime: json['confirm_end_time'] as String?,
      paidHours: (json['paid_hours'] as num).toDouble(),
      isLate: json['is_late'] as bool,
      lateMinutes: json['late_minutes'] as num,
      lateDeducutAmount: (json['late_deducut_amount'] as num).toDouble(),
      isExtratime: json['is_extratime'] as bool,
      overtimeMinutes: json['overtime_minutes'] as num,
      basePay: json['base_pay'] as String,
      bonusAmount: (json['bonus_amount'] as num).toDouble(),
      totalPayWithBonus: json['total_pay_with_bonus'] as String,
      salaryType: json['salary_type'] as String,
      salaryAmount: json['salary_amount'] as String,
      isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
      checkinDistanceFromStore:
          (json['checkin_distance_from_store'] as num?)?.toDouble(),
      checkoutDistanceFromStore:
          (json['checkout_distance_from_store'] as num?)?.toDouble(),
      isReported: json['is_reported'] as bool,
      isProblem: json['is_problem'] as bool,
      isProblemSolved: json['is_problem_solved'] as bool,
    );

Map<String, dynamic> _$$ShiftCardImplToJson(_$ShiftCardImpl instance) =>
    <String, dynamic>{
      'request_date': instance.requestDate,
      'shift_request_id': instance.shiftRequestId,
      'shift_time': instance.shiftTime,
      'store_name': instance.storeName,
      'scheduled_hours': instance.scheduledHours,
      'is_approved': instance.isApproved,
      'actual_start_time': instance.actualStartTime,
      'actual_end_time': instance.actualEndTime,
      'confirm_start_time': instance.confirmStartTime,
      'confirm_end_time': instance.confirmEndTime,
      'paid_hours': instance.paidHours,
      'is_late': instance.isLate,
      'late_minutes': instance.lateMinutes,
      'late_deducut_amount': instance.lateDeducutAmount,
      'is_extratime': instance.isExtratime,
      'overtime_minutes': instance.overtimeMinutes,
      'base_pay': instance.basePay,
      'bonus_amount': instance.bonusAmount,
      'total_pay_with_bonus': instance.totalPayWithBonus,
      'salary_type': instance.salaryType,
      'salary_amount': instance.salaryAmount,
      'is_valid_checkin_location': instance.isValidCheckinLocation,
      'checkin_distance_from_store': instance.checkinDistanceFromStore,
      'checkout_distance_from_store': instance.checkoutDistanceFromStore,
      'is_reported': instance.isReported,
      'is_problem': instance.isProblem,
      'is_problem_solved': instance.isProblemSolved,
    };
