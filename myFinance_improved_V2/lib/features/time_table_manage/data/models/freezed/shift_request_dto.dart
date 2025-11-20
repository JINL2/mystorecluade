import 'package:freezed_annotation/freezed_annotation.dart';
import 'employee_info_dto.dart';

part 'shift_request_dto.freezed.dart';
part 'shift_request_dto.g.dart';

/// Shift Request DTO
///
/// Used in multiple RPC responses
@freezed
class ShiftRequestDto with _$ShiftRequestDto {
  const factory ShiftRequestDto({
    @JsonKey(name: 'shift_request_id') @Default('') String shiftRequestId,
    @JsonKey(name: 'shift_id') @Default('') String shiftId,
    @JsonKey(name: 'employee') required EmployeeInfoDto employee,
    @JsonKey(name: 'is_approved') @Default(false) bool isApproved,
    @JsonKey(name: 'created_at') @Default('') String createdAt,
    @JsonKey(name: 'approved_at') String? approvedAt,
  }) = _ShiftRequestDto;

  factory ShiftRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftRequestDtoFromJson(json);
}
