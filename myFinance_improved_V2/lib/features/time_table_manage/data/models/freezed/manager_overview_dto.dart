import 'package:freezed_annotation/freezed_annotation.dart';

part 'manager_overview_dto.freezed.dart';
part 'manager_overview_dto.g.dart';

/// Manager Overview DTO - Top level
///
/// Maps to RPC: manager_shift_get_overview
@freezed
class ManagerOverviewDto with _$ManagerOverviewDto {
  const factory ManagerOverviewDto({
    @JsonKey(name: 'scope') required OverviewScopeDto scope,
    @JsonKey(name: 'stores') @Default([]) List<OverviewStoreDto> stores,
  }) = _ManagerOverviewDto;

  factory ManagerOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerOverviewDtoFromJson(json);
}

/// Overview Scope DTO
@freezed
class OverviewScopeDto with _$OverviewScopeDto {
  const factory OverviewScopeDto({
    @JsonKey(name: 'company_id') @Default('') String companyId,
    @JsonKey(name: 'company_name') @Default('') String companyName,
    @JsonKey(name: 'total_stores') @Default(0) int totalStores,
    @JsonKey(name: 'date_range') required DateRangeDto dateRange,
  }) = _OverviewScopeDto;

  factory OverviewScopeDto.fromJson(Map<String, dynamic> json) =>
      _$OverviewScopeDtoFromJson(json);
}

/// Date Range DTO
@freezed
class DateRangeDto with _$DateRangeDto {
  const factory DateRangeDto({
    @JsonKey(name: 'start_date') @Default('') String startDate,
    @JsonKey(name: 'end_date') @Default('') String endDate,
  }) = _DateRangeDto;

  factory DateRangeDto.fromJson(Map<String, dynamic> json) =>
      _$DateRangeDtoFromJson(json);
}

/// Overview Store DTO
@freezed
class OverviewStoreDto with _$OverviewStoreDto {
  const factory OverviewStoreDto({
    @JsonKey(name: 'store_id') @Default('') String storeId,
    @JsonKey(name: 'store_name') @Default('') String storeName,
    @JsonKey(name: 'daily_summary') @Default([]) List<DailySummaryDto> dailySummary,
    @JsonKey(name: 'monthly_stats') @Default([]) List<MonthlyStatDto> monthlyStats,
  }) = _OverviewStoreDto;

  factory OverviewStoreDto.fromJson(Map<String, dynamic> json) =>
      _$OverviewStoreDtoFromJson(json);
}

/// Daily Summary DTO
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

/// Monthly Stat DTO
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
