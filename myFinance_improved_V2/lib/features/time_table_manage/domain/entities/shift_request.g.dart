// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftRequestImpl _$$ShiftRequestImplFromJson(Map<String, dynamic> json) =>
    _$ShiftRequestImpl(
      shiftRequestId: json['shift_request_id'] as String,
      shiftId: json['shift_id'] as String,
      employee: EmployeeInfo.fromJson(json['employee'] as Map<String, dynamic>),
      isApproved: json['is_approved'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      approvedAt: json['approved_at'] == null
          ? null
          : DateTime.parse(json['approved_at'] as String),
    );

Map<String, dynamic> _$$ShiftRequestImplToJson(_$ShiftRequestImpl instance) =>
    <String, dynamic>{
      'shift_request_id': instance.shiftRequestId,
      'shift_id': instance.shiftId,
      'employee': instance.employee,
      'is_approved': instance.isApproved,
      'created_at': instance.createdAt.toIso8601String(),
      'approved_at': instance.approvedAt?.toIso8601String(),
    };
