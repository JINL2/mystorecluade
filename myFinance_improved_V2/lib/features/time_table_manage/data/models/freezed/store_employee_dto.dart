import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_employee_dto.freezed.dart';
part 'store_employee_dto.g.dart';

/// Store Employee DTO
///
/// Maps to manager_shift_get_schedule RPC field: store_employees
@freezed
class StoreEmployeeDto with _$StoreEmployeeDto {
  const factory StoreEmployeeDto({
    @JsonKey(name: 'user_id') @Default('') String userId,
    @JsonKey(name: 'full_name') @Default('') String fullName,
    @JsonKey(name: 'email') @Default('') String email,
    @JsonKey(name: 'display_name') @Default('') String displayName,
  }) = _StoreEmployeeDto;

  factory StoreEmployeeDto.fromJson(Map<String, dynamic> json) =>
      _$StoreEmployeeDtoFromJson(json);
}
