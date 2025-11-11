import 'package:freezed_annotation/freezed_annotation.dart';
import 'employee_info_dto.dart';
import 'shift_dto.dart';

part 'available_employees_data_dto.freezed.dart';
part 'available_employees_data_dto.g.dart';

/// Available Employees Data DTO
///
/// Maps to RPC: get_employees_and_shifts
@freezed
class AvailableEmployeesDataDto with _$AvailableEmployeesDataDto {
  const factory AvailableEmployeesDataDto({
    @JsonKey(name: 'available_employees') @Default([]) List<EmployeeInfoDto> availableEmployees,
    @JsonKey(name: 'existing_shifts') @Default([]) List<ShiftDto> existingShifts,
    @JsonKey(name: 'store_id') @Default('') String storeId,
    @JsonKey(name: 'shift_date') @Default('') String shiftDate,
  }) = _AvailableEmployeesDataDto;

  factory AvailableEmployeesDataDto.fromJson(Map<String, dynamic> json) =>
      _$AvailableEmployeesDataDtoFromJson(json);
}
