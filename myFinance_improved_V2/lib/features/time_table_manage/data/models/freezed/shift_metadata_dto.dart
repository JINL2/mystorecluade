import 'package:freezed_annotation/freezed_annotation.dart';

part 'shift_metadata_dto.freezed.dart';
part 'shift_metadata_dto.g.dart';

/// Shift Metadata DTO
///
/// Maps to RPC: get_shift_metadata_v2_utc
///
/// RPC returns TABLE with shift information from store_shifts table:
/// - shift_id, store_id, shift_name
/// - start_time_utc, end_time_utc (time with time zone, converted to user timezone)
/// - number_shift (required employee count)
/// - is_active (boolean)
/// - is_can_overtime (boolean)
@freezed
class ShiftMetadataDto with _$ShiftMetadataDto {
  const factory ShiftMetadataDto({
    @JsonKey(name: 'shift_id') @Default('') String shiftId,
    @JsonKey(name: 'store_id') @Default('') String storeId,
    @JsonKey(name: 'shift_name') @Default('') String shiftName,
    @JsonKey(name: 'start_time_utc') @Default('') String startTime,
    @JsonKey(name: 'end_time_utc') @Default('') String endTime,
    @JsonKey(name: 'number_shift') @Default(0) int numberShift,
    @JsonKey(name: 'is_active') @Default(true) bool isActive,
    @JsonKey(name: 'is_can_overtime') @Default(false) bool isCanOvertime,
  }) = _ShiftMetadataDto;

  factory ShiftMetadataDto.fromJson(Map<String, dynamic> json) =>
      _$ShiftMetadataDtoFromJson(json);
}
