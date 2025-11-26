import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_dto.freezed.dart';
part 'shift_dto.g.dart';

/// Shift DTO
///
/// Maps to RPC: insert_shift_schedule response
@freezed
class ShiftDto with _$ShiftDto {
  const factory ShiftDto({
    @JsonKey(name: 'shift_id') @Default('') String shiftId,
    @JsonKey(name: 'store_id') @Default('') String storeId,
    @JsonKey(name: 'shift_date') @Default('') String shiftDate,
    @JsonKey(name: 'plan_start_time') @Default('') String planStartTime,
    @JsonKey(name: 'plan_end_time') @Default('') String planEndTime,
    @JsonKey(name: 'target_count') @Default(0) int targetCount,
    @JsonKey(name: 'current_count') @Default(0) int currentCount,
    @JsonKey(name: 'tags') @Default([]) List<String> tags,
    @JsonKey(name: 'shift_name') String? shiftName,
  }) = _ShiftDto;

  factory ShiftDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftDtoFromJson(json);
}
