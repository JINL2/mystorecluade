// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_request_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftRequestDtoImpl _$$ShiftRequestDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftRequestDtoImpl(
      shiftRequestId: json['shift_request_id'] as String? ?? '',
      shiftId: json['shift_id'] as String? ?? '',
      employee:
          EmployeeInfoDto.fromJson(json['employee'] as Map<String, dynamic>),
      isApproved: json['is_approved'] as bool? ?? false,
      createdAt: json['created_at'] as String? ?? '',
      approvedAt: json['approved_at'] as String?,
    );

Map<String, dynamic> _$$ShiftRequestDtoImplToJson(
        _$ShiftRequestDtoImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'shift_id': instance.shiftId,
      'employee': instance.employee,
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt,
      'approved_at': instance.approvedAt,
    };
