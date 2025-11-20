import 'package:freezed_annotation/freezed_annotation.dart';

part 'employee_info_dto.freezed.dart';
part 'employee_info_dto.g.dart';

/// Employee Info DTO
///
/// Used across multiple RPCs for employee data
@freezed
class EmployeeInfoDto with _$EmployeeInfoDto {
  const factory EmployeeInfoDto({
    @JsonKey(name: 'user_id') @Default('') String userId,
    @JsonKey(name: 'user_name') @Default('') String userName,
    @JsonKey(name: 'profile_image') String? profileImage,
    @JsonKey(name: 'position') String? position,
    @JsonKey(name: 'hourly_wage') double? hourlyWage,
  }) = _EmployeeInfoDto;

  factory EmployeeInfoDto.fromJson(Map<String, dynamic> json) =>
      _$EmployeeInfoDtoFromJson(json);
}
