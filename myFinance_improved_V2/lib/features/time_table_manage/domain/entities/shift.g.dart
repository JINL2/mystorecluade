// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftImpl _$$ShiftImplFromJson(Map<String, dynamic> json) => _$ShiftImpl(
      shiftId: json['shift_id'] as String? ?? '',
      storeId: json['store_id'] as String? ?? '',
      shiftDate: json['shift_date'] as String? ?? '',
      planStartTime: _parseStartTime(json['plan_start_time']),
      planEndTime: _parseEndTime(json['plan_end_time']),
      targetCount: (json['target_count'] as num?)?.toInt() ?? 0,
      currentCount: (json['current_count'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              [],
      shiftName: json['shift_name'] as String?,
    );

Map<String, dynamic> _$$ShiftImplToJson(_$ShiftImpl instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'store_id': instance.storeId,
      'shift_date': instance.shiftDate,
      'plan_start_time': _serializeTime(instance.planStartTime),
      'plan_end_time': _serializeTime(instance.planEndTime),
      'target_count': instance.targetCount,
      'current_count': instance.currentCount,
      'tags': instance.tags,
      'shift_name': instance.shiftName,
    };
