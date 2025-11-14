// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'available_employees_data_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AvailableEmployeesDataDtoImpl _$$AvailableEmployeesDataDtoImplFromJson(
        Map<String, dynamic> json) =>
    _$AvailableEmployeesDataDtoImpl(
      availableEmployees: (json['available_employees'] as List<dynamic>?)
              ?.map((e) => EmployeeInfoDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      existingShifts: (json['existing_shifts'] as List<dynamic>?)
              ?.map((e) => ShiftDto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      storeId: json['store_id'] as String? ?? '',
      shiftDate: json['shift_date'] as String? ?? '',
    );

Map<String, dynamic> _$$AvailableEmployeesDataDtoImplToJson(
        _$AvailableEmployeesDataDtoImpl instance) =>
    <String, dynamic>{
      'available_employees': instance.availableEmployees,
      'existing_shifts': instance.existingShifts,
      'store_id': instance.storeId,
      'shift_date': instance.shiftDate,
    };
