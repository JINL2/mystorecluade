import 'package:freezed_annotation/freezed_annotation.dart';

import 'daily_summary_dto.dart';
import 'monthly_stat_dto.dart';

part 'overview_store_dto.freezed.dart';
part 'overview_store_dto.g.dart';

/// Overview Store DTO
///
/// Represents store-level overview data with daily and monthly statistics.
///
/// Fields:
/// - storeId: The store identifier
/// - storeName: The store name
/// - dailySummary: List of daily shift summaries
/// - monthlyStats: List of monthly statistics
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
