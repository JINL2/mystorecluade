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
      managerMemos: (json['manager_memo'] as List<dynamic>?)
              ?.map((e) => ManagerMemoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      problemDetails: json['problem_details'] == null
          ? null
          : ProblemDetailsDto.fromJson(
              json['problem_details'] as Map<String, dynamic>),
      checkinDistanceFromStore:
          (json['checkin_distance_from_store'] as num?)?.toDouble() ?? 0.0,
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
      'manager_memo': instance.managerMemos,
      'problem_details': instance.problemDetails,
      'checkin_distance_from_store': instance.checkinDistanceFromStore,
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

_$ManagerMemoDtoImpl _$$ManagerMemoDtoImplFromJson(Map<String, dynamic> json) =>
    _$ManagerMemoDtoImpl(
      type: json['type'] as String?,
      content: json['content'] as String?,
      createdAt: json['created_at'] as String?,
      createdBy: json['created_by'] as String?,
    );

Map<String, dynamic> _$$ManagerMemoDtoImplToJson(
        _$ManagerMemoDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'content': instance.content,
      'created_at': instance.createdAt,
      'created_by': instance.createdBy,
    };

_$ProblemDetailsDtoImpl _$$ProblemDetailsDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ProblemDetailsDtoImpl(
      hasLate: json['has_late'] as bool? ?? false,
      hasOvertime: json['has_overtime'] as bool? ?? false,
      hasReported: json['has_reported'] as bool? ?? false,
      hasNoCheckout: json['has_no_checkout'] as bool? ?? false,
      hasAbsence: json['has_absence'] as bool? ?? false,
      hasEarlyLeave: json['has_early_leave'] as bool? ?? false,
      hasLocationIssue: json['has_location_issue'] as bool? ?? false,
      hasPayrollLate: json['has_payroll_late'] as bool? ?? false,
      hasPayrollOvertime: json['has_payroll_overtime'] as bool? ?? false,
      hasPayrollEarlyLeave: json['has_payroll_early_leave'] as bool? ?? false,
      problemCount: (json['problem_count'] as num?)?.toInt() ?? 0,
      isSolved: json['is_solved'] as bool? ?? false,
      detectedAt: json['detected_at'] as String?,
      problems: (json['problems'] as List<dynamic>?)
              ?.map((e) => ProblemItemDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ProblemDetailsDtoImplToJson(
        _$ProblemDetailsDtoImpl instance) =>
    <String, dynamic>{
      'has_late': instance.hasLate,
      'has_overtime': instance.hasOvertime,
      'has_reported': instance.hasReported,
      'has_no_checkout': instance.hasNoCheckout,
      'has_absence': instance.hasAbsence,
      'has_early_leave': instance.hasEarlyLeave,
      'has_location_issue': instance.hasLocationIssue,
      'has_payroll_late': instance.hasPayrollLate,
      'has_payroll_overtime': instance.hasPayrollOvertime,
      'has_payroll_early_leave': instance.hasPayrollEarlyLeave,
      'problem_count': instance.problemCount,
      'is_solved': instance.isSolved,
      'detected_at': instance.detectedAt,
      'problems': instance.problems,
    };

_$ProblemItemDtoImpl _$$ProblemItemDtoImplFromJson(Map<String, dynamic> json) =>
    _$ProblemItemDtoImpl(
      type: json['type'] as String?,
      actualMinutes: (json['actual_minutes'] as num?)?.toInt(),
      payrollMinutes: (json['payroll_minutes'] as num?)?.toInt(),
      isPayrollAdjusted: json['is_payroll_adjusted'] as bool? ?? false,
      reason: json['reason'] as String?,
      reportedAt: json['reported_at'] as String?,
      isReportSolved: json['is_report_solved'] as bool?,
    );

Map<String, dynamic> _$$ProblemItemDtoImplToJson(
        _$ProblemItemDtoImpl instance) =>
    <String, dynamic>{
      'type': instance.type,
      'actual_minutes': instance.actualMinutes,
      'payroll_minutes': instance.payrollMinutes,
      'is_payroll_adjusted': instance.isPayrollAdjusted,
      'reason': instance.reason,
      'reported_at': instance.reportedAt,
      'is_report_solved': instance.isReportSolved,
    };
