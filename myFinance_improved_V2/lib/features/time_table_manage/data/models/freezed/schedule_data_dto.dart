import 'package:freezed_annotation/freezed_annotation.dart';
import 'store_employee_dto.dart';
import 'store_shift_dto.dart';

part 'schedule_data_dto.freezed.dart';
part 'schedule_data_dto.g.dart';

/// Schedule Data DTO
///
/// Maps to RPC: manager_shift_get_schedule
@freezed
class ScheduleDataDto with _$ScheduleDataDto {
  const factory ScheduleDataDto({
    @JsonKey(name: 'store_employees') @Default([]) List<StoreEmployeeDto> storeEmployees,
    @JsonKey(name: 'store_shifts') @Default([]) List<StoreShiftDto> storeShifts,
  }) = _ScheduleDataDto;

  factory ScheduleDataDto.fromJson(Map<String, dynamic> json) =>
      _$ScheduleDataDtoFromJson(json);
}
