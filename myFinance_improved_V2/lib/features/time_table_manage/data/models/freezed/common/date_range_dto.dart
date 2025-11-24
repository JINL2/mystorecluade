import 'package:freezed_annotation/freezed_annotation.dart';

part 'date_range_dto.freezed.dart';
part 'date_range_dto.g.dart';

/// Date Range DTO
///
/// Common DTO representing a date range with start and end dates.
/// Used across multiple features for date range queries.
///
/// Usage:
/// ```dart
/// final range = DateRangeDto(startDate: '2025-01-01', endDate: '2025-01-31');
/// ```
@freezed
class DateRangeDto with _$DateRangeDto {
  const factory DateRangeDto({
    @JsonKey(name: 'start_date') @Default('') String startDate,
    @JsonKey(name: 'end_date') @Default('') String endDate,
  }) = _DateRangeDto;

  factory DateRangeDto.fromJson(Map<String, dynamic> json) =>
      _$DateRangeDtoFromJson(json);
}
