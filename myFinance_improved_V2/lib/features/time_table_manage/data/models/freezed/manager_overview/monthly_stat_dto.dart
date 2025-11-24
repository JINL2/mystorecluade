import 'package:freezed_annotation/freezed_annotation.dart';

part 'monthly_stat_dto.freezed.dart';
part 'monthly_stat_dto.g.dart';

/// Monthly Stat DTO
///
/// Represents monthly statistics for shift management.
///
/// Fields:
/// - month: Month identifier (e.g., "2025-01")
/// - totalRequests: Total shift requests for the month
/// - totalApproved: Number of approved requests
/// - totalPending: Number of pending requests
/// - totalProblems: Number of problematic shifts
@freezed
class MonthlyStatDto with _$MonthlyStatDto {
  const factory MonthlyStatDto({
    @JsonKey(name: 'month') @Default('') String month,
    @JsonKey(name: 'total_requests') @Default(0) int totalRequests,
    @JsonKey(name: 'total_approved') @Default(0) int totalApproved,
    @JsonKey(name: 'total_pending') @Default(0) int totalPending,
    @JsonKey(name: 'total_problems') @Default(0) int totalProblems,
  }) = _MonthlyStatDto;

  factory MonthlyStatDto.fromJson(Map<String, dynamic> json) =>
      _$MonthlyStatDtoFromJson(json);
}
