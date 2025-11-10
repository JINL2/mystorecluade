// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_metadata_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftMetadataModelImpl _$$ShiftMetadataModelImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftMetadataModelImpl(
      shiftId: json['shift_id'] as String,
      shiftName: json['shift_name'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
      description: json['description'] as String?,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ShiftMetadataModelImplToJson(
        _$ShiftMetadataModelImpl instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'shift_name': instance.shiftName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'description': instance.description,
      'is_active': instance.isActive,
    };
