import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_summary_dto.freezed.dart';
part 'daily_summary_dto.g.dart';

/// Daily Summary DTO
///
/// Represents daily shift summary with staffing statistics.
///
/// Fields:
/// - date: The date in YYYY-MM-DD format
/// - totalRequired: Total number of required staff
/// - totalApproved: Number of approved shift requests
/// - totalPending: Number of pending shift requests
/// - hasProblem: Whether there are any issues with staffing
/// - fillRate: Percentage of filled positions (0-100)
@freezed
class DailySummaryDto with _$DailySummaryDto {
  const factory DailySummaryDto({
    @JsonKey(name: 'date') @Default('') String date,
    @JsonKey(name: 'total_required') @Default(0) int totalRequired,
    @JsonKey(name: 'total_approved') @Default(0) int totalApproved,
    @JsonKey(name: 'total_pending') @Default(0) int totalPending,
    @JsonKey(name: 'has_problem') @Default(false) bool hasProblem,
    @JsonKey(name: 'fill_rate') @Default(0) int fillRate,
  }) = _DailySummaryDto;

  factory DailySummaryDto.fromJson(Map<String, dynamic> json) =>
      _$DailySummaryDtoFromJson(json);
}
