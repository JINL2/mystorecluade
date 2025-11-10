// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schedule_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScheduleDataImpl _$$ScheduleDataImplFromJson(Map<String, dynamic> json) =>
    _$ScheduleDataImpl(
      employees: (json['employees'] as List<dynamic>?)
              ?.map((e) => EmployeeInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      shifts: (json['shifts'] as List<dynamic>?)
              ?.map((e) => Shift.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      storeId: json['store_id'] as String,
    );

Map<String, dynamic> _$$ScheduleDataImplToJson(_$ScheduleDataImpl instance) =>
    <String, dynamic>{
      'employees': instance.employees,
      'shifts': instance.shifts,
      'store_id': instance.storeId,
    };
