// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_metadata_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftMetadataDtoImpl _$$ShiftMetadataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ShiftMetadataDtoImpl(
      shiftId: json['shift_id'] as String? ?? '',
      storeId: json['store_id'] as String? ?? '',
      shiftName: json['shift_name'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      numberShift: (json['number_shift'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );

Map<String, dynamic> _$$ShiftMetadataDtoImplToJson(
        _$ShiftMetadataDtoImpl instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'store_id': instance.storeId,
      'shift_name': instance.shiftName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'number_shift': instance.numberShift,
      'is_active': instance.isActive,
    };
