// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shift_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShiftDtoImpl _$$ShiftDtoImplFromJson(Map<String, dynamic> json) =>
    _$ShiftDtoImpl(
      shiftId: json['shift_id'] as String? ?? '',
      storeId: json['store_id'] as String? ?? '',
      shiftDate: json['shift_date'] as String? ?? '',
      planStartTime: json['plan_start_time'] as String? ?? '',
      planEndTime: json['plan_end_time'] as String? ?? '',
      targetCount: (json['target_count'] as num?)?.toInt() ?? 0,
      currentCount: (json['current_count'] as num?)?.toInt() ?? 0,
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
      shiftName: json['shift_name'] as String?,
    );

Map<String, dynamic> _$$ShiftDtoImplToJson(_$ShiftDtoImpl instance) =>
    <String, dynamic>{
      'shift_id': instance.shiftId,
      'store_id': instance.storeId,
      'shift_date': instance.shiftDate,
      'plan_start_time': instance.planStartTime,
      'plan_end_time': instance.planEndTime,
      'target_count': instance.targetCount,
      'current_count': instance.currentCount,
      'tags': instance.tags,
      'shift_name': instance.shiftName,
    };
