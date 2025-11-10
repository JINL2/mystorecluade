// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_employees_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailableEmployeesDataImpl _$$AvailableEmployeesDataImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailableEmployeesDataImpl(
      availableEmployees: (json['available_employees'] as List<dynamic>?)
              ?.map((e) => EmployeeInfo.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      existingShifts: (json['existing_shifts'] as List<dynamic>?)
              ?.map((e) => Shift.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      storeId: json['store_id'] as String,
      shiftDate: json['shift_date'] as String,
    );

Map<String, dynamic> _$$AvailableEmployeesDataImplToJson(
        _$AvailableEmployeesDataImpl instance) =>
    <String, dynamic>{
      'available_employees': instance.availableEmployees,
      'existing_shifts': instance.existingShifts,
      'store_id': instance.storeId,
      'shift_date': instance.shiftDate,
    };
