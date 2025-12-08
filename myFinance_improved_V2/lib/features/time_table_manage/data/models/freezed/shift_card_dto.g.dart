// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_card_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftCardDtoImpl _$$ShiftCardDtoImplFromJson(Map<String, dynamic> json) =>
    _$ShiftCardDtoImpl(
      shiftDate: json['shift_date'] as String? ?? '',
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      userId: json['user_id'] as String? ?? '',
      userName: json['user_name'] as String? ?? '',
      profileImage: json['profile_image'] as String?,
      shiftName: json['shift_name'] as String?,
      shiftTime:
          const ShiftTimeConverter().fromJson(json['shift_time'] as String?),
      shiftStartTime: json['shift_start_time'] as String?,
      shiftEndTime: json['shift_end_time'] as String?,
      isApproved: json['is_approved'] as bool? ?? false,
      isProblem: json['is_problem'] as bool? ?? false,
      isProblemSolved: json['is_problem_solved'] as bool? ?? false,
      isLate: json['is_late'] as bool? ?? false,
      lateMinute: (json['late_minute'] as num?)?.toInt() ?? 0,
      isOverTime: json['is_over_time'] as bool? ?? false,
      overTimeMinute: (json['over_time_minute'] as num?)?.toInt() ?? 0,
      paidHour: (json['paid_hour'] as num?)?.toDouble() ?? 0.0,
      salaryType: json['salary_type'] as String?,
      salaryAmount: json['salary_amount'] as String?,
      basePay: json['base_pay'] as String?,
      totalPayWithBonus: json['total_pay_with_bonus'] as String?,
      bonusAmount: (json['bonus_amount'] as num?)?.toDouble() ?? 0.0,
      actualStart: json['actual_start'] as String?,
      actualEnd: json['actual_end'] as String?,
      confirmStartTime: json['confirm_start_time'] as String?,
      confirmEndTime: json['confirm_end_time'] as String?,
      noticeTags: (json['notice_tag'] as List<dynamic>?)
              ?.map((e) => TagDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      problemType: json['problem_type'] as String?,
      isReported: json['is_reported'] as bool? ?? false,
      reportReason: json['report_reason'] as String?,
      isValidCheckinLocation: json['is_valid_checkin_location'] as bool?,
      checkinDistanceFromStore:
          (json['checkin_distance_from_store'] as num?)?.toDouble() ?? 0.0,
      isValidCheckoutLocation: json['is_valid_checkout_location'] as bool?,
      checkoutDistanceFromStore:
          (json['checkout_distance_from_store'] as num?)?.toDouble() ?? 0.0,
      storeName: json['store_name'] as String?,
    );

Map<String, dynamic> _$$ShiftCardDtoImplToJson(_$ShiftCardDtoImpl instance) =>
    <String, dynamic>{
      'shift_date': instance.shiftDate,
      'shift_request_id': instance.shiftRequestId,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'profile_image': instance.profileImage,
      'shift_name': instance.shiftName,
      'shift_time': const ShiftTimeConverter().toJson(instance.shiftTime),
      'shift_start_time': instance.shiftStartTime,
      'shift_end_time': instance.shiftEndTime,
      'is_approved': instance.isApproved,
      'is_problem': instance.isProblem,
      'is_problem_solved': instance.isProblemSolved,
      'is_late': instance.isLate,
      'late_minute': instance.lateMinute,
      'is_over_time': instance.isOverTime,
      'over_time_minute': instance.overTimeMinute,
      'paid_hour': instance.paidHour,
      'salary_type': instance.salaryType,
      'salary_amount': instance.salaryAmount,
      'base_pay': instance.basePay,
      'total_pay_with_bonus': instance.totalPayWithBonus,
      'bonus_amount': instance.bonusAmount,
      'actual_start': instance.actualStart,
      'actual_end': instance.actualEnd,
      'confirm_start_time': instance.confirmStartTime,
      'confirm_end_time': instance.confirmEndTime,
      'notice_tag': instance.noticeTags,
      'problem_type': instance.problemType,
      'is_reported': instance.isReported,
      'report_reason': instance.reportReason,
      'is_valid_checkin_location': instance.isValidCheckinLocation,
      'checkin_distance_from_store': instance.checkinDistanceFromStore,
      'is_valid_checkout_location': instance.isValidCheckoutLocation,
      'checkout_distance_from_store': instance.checkoutDistanceFromStore,
      'store_name': instance.storeName,
    };

_$TagDtoImpl _$$TagDtoImplFromJson(Map<String, dynamic> json) => _$TagDtoImpl(
      id: json['id'] as String?,
      type: json['type'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] as String?,
      createdBy: json['created_by'] as String?,
      createdByName: json['created_by_name'] as String?,
    );

Map<String, dynamic> _$$TagDtoImplToJson(_$TagDtoImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'content': instance.content,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
      'created_by_name': instance.createdByName,
    };
