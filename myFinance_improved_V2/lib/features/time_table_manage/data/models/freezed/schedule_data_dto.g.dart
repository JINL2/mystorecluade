// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleDataDtoImpl _$$ScheduleDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$ScheduleDataDtoImpl(
      storeEmployees: (json['store_employees'] as List<dynamic>?)
              ?.map((e) => StoreEmployeeDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      storeShifts: (json['store_shifts'] as List<dynamic>?)
              ?.map((e) => StoreShiftDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ScheduleDataDtoImplToJson(
        _$ScheduleDataDtoImpl instance) =>
    <String, dynamic>{
      'store_employees': instance.storeEmployees,
      'store_shifts': instance.storeShifts,
    };
