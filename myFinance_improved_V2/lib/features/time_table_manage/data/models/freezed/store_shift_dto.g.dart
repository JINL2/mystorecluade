// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_shift_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreShiftDtoImpl _$$StoreShiftDtoImplFromJson(Map<String, dynamic> json) =>
    _$StoreShiftDtoImpl(
      shiftId: json['shift_id'] as String? ?? '',
      shiftName: json['shift_name'] as String? ?? '',
      startTime: json['start_time'] as String? ?? '',
      endTime: json['end_time'] as String? ?? '',
      displayName: json['display_name'] as String? ?? '',
    );

Map<String, dynamic> _$$StoreShiftDtoImplToJson(_$StoreShiftDtoImpl instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'shift_name': instance.shiftName,
      'start_time': instance.startTime,
      'end_time': instance.endTime,
      'display_name': instance.displayName,
    };
