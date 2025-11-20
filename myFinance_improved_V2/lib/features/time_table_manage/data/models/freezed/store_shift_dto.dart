import 'package:freezed_annotation/freezed_annotation.dart';

part 'store_shift_dto.freezed.dart';
part 'store_shift_dto.g.dart';

/// Store Shift DTO
///
/// Maps to manager_shift_get_schedule RPC field: store_shifts
@freezed
class StoreShiftDto with _$StoreShiftDto {
  const factory StoreShiftDto({
    @JsonKey(name: 'shift_id') @Default('') String shiftId,
    @JsonKey(name: 'shift_name') @Default('') String shiftName,
    @JsonKey(name: 'start_time') @Default('') String startTime,
    @JsonKey(name: 'end_time') @Default('') String endTime,
    @JsonKey(name: 'display_name') @Default('') String displayName,
  }) = _StoreShiftDto;

  factory StoreShiftDto.fromJson(Map<String, dynamic> json) =>
      _$StoreShiftDtoFromJson(json);
}
