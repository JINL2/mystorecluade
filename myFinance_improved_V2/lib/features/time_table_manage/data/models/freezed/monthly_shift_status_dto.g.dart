// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'monthly_shift_status_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$MonthlyShiftStatusDtoImpl _$$MonthlyShiftStatusDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$MonthlyShiftStatusDtoImpl(
      shiftDate: json['shift_date'] as String,
      storeId: json['store_id'] as String,
      totalRequired: (json['total_required'] as num?)?.toInt() ?? 0,
      totalApproved: (json['total_approved'] as num?)?.toInt() ?? 0,
      totalPending: (json['total_pending'] as num?)?.toInt() ?? 0,
      shifts: (json['shifts'] as List<dynamic>?)
              ?.map((e) =>
                  ShiftWithEmployeesDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$MonthlyShiftStatusDtoImplToJson(
        _$MonthlyShiftStatusDtoImpl instance) =>
    <String, dynamic>{
      'shift_date': instance.shiftDate,
      'store_id': instance.storeId,
      'total_required': instance.totalRequired,
      'total_approved': instance.totalApproved,
      'total_pending': instance.totalPending,
      'shifts': instance.shifts,
    };

_$ShiftWithEmployeesDtoImpl _$$ShiftWithEmployeesDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftWithEmployeesDtoImpl(
      shiftId: json['shift_id'] as String,
      shiftName: json['shift_name'] as String?,
      requiredEmployees: (json['required_employees'] as num?)?.toInt() ?? 0,
      shiftStartTime: json['shift_start_time'] as String?,
      shiftEndTime: json['shift_end_time'] as String?,
      approvedCount: (json['approved_count'] as num?)?.toInt() ?? 0,
      pendingCount: (json['pending_count'] as num?)?.toInt() ?? 0,
      approvedEmployees: (json['approved_employees'] as List<dynamic>?)
              ?.map((e) => ShiftEmployeeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      pendingEmployees: (json['pending_employees'] as List<dynamic>?)
              ?.map((e) => ShiftEmployeeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ShiftWithEmployeesDtoImplToJson(
        _$ShiftWithEmployeesDtoImpl instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'shift_name': instance.shiftName,
      'required_employees': instance.requiredEmployees,
      'shift_start_time': instance.shiftStartTime,
      'shift_end_time': instance.shiftEndTime,
      'approved_count': instance.approvedCount,
      'pending_count': instance.pendingCount,
      'approved_employees': instance.approvedEmployees,
      'pending_employees': instance.pendingEmployees,
    };

_$ShiftEmployeeDtoImpl _$$ShiftEmployeeDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftEmployeeDtoImpl(
      shiftRequestId: json['shift_request_id'] as String,
      userId: json['user_id'] as String,
      userName: json['user_name'] as String,
      isApproved: json['is_approved'] as bool? ?? false,
      profileImage: json['profile_image'] as String?,
    );

Map<String, dynamic> _$$ShiftEmployeeDtoImplToJson(
        _$ShiftEmployeeDtoImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'user_id': instance.userId,
      'user_name': instance.userName,
      'is_approved': instance.isApproved,
      'profile_image': instance.profileImage,
    };
