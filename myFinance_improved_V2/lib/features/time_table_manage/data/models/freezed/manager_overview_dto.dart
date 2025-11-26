import 'package:freezed_annotation/freezed_annotation.dart';

import 'manager_overview/overview_scope_dto.dart';
import 'manager_overview/overview_store_dto.dart';

part 'manager_overview_dto.freezed.dart';
part 'manager_overview_dto.g.dart';

/// Manager Overview DTO - Top level
///
/// Maps to RPC: manager_shift_get_overview
///
/// This DTO aggregates overview data from multiple stores.
/// It has been refactored to use separate DTO files for better modularity.
///
/// Structure:
/// - ManagerOverviewDto (this file)
///   ├── OverviewScopeDto
///   │   └── DateRangeDto (common)
///   └── OverviewStoreDto
///       ├── DailySummaryDto
///       └── MonthlyStatDto
///
/// Benefits of this structure:
/// - Smaller file sizes (48KB → 6 files × ~8KB)
/// - Better reusability (DateRangeDto can be shared)
/// - Faster build times (partial regeneration)
/// - Clearer responsibilities
@freezed
class ManagerOverviewDto with _$ManagerOverviewDto {
  const factory ManagerOverviewDto({
    @JsonKey(name: 'scope') required OverviewScopeDto scope,
    @JsonKey(name: 'stores') @Default([]) List<OverviewStoreDto> stores,
  }) = _ManagerOverviewDto;

  factory ManagerOverviewDto.fromJson(Map<String, dynamic> json) =>
      _$ManagerOverviewDtoFromJson(json);
}

// ============================================================================
// Migration Notes
// ============================================================================
//
// ✅ BEFORE (Monolithic - 90 lines → 48KB freezed):
// - All DTOs in one file
// - Hard to navigate
// - Slow build times
// - No reusability
//
// ✅ AFTER (Modular - 6 files × ~15 lines → 6 × ~8KB freezed):
// - Separated by responsibility
// - Easy to navigate
// - Fast build times (partial regeneration)
// - High reusability (DateRangeDto)
//
// File Structure:
// manager_overview/
//   ├── daily_summary_dto.dart
//   ├── monthly_stat_dto.dart
//   ├── overview_scope_dto.dart
//   └── overview_store_dto.dart
// common/
//   └── date_range_dto.dart
//
// ============================================================================
