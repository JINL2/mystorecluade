// lib/features/report_control/presentation/pages/templates/cash_location/domain/entities/cash_location_report.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'cash_location_report.freezed.dart';
part 'cash_location_report.g.dart';

/// Cash Location Report Data
///
/// Main entity for daily cash location reconciliation report.
/// Contains summary, locations by store, recent entries, and AI insights.
@freezed
class CashLocationReport with _$CashLocationReport {
  const factory CashLocationReport({
    /// Report metadata
    @JsonKey(name: 'report_date') required String reportDate,
    @JsonKey(name: 'currency_symbol') @Default('₫') String currencySymbol,
    @JsonKey(name: 'currency_code') @Default('VND') String currencyCode,

    /// Hero stats for summary display
    @JsonKey(name: 'hero_stats') required CashLocationHeroStats heroStats,

    /// Locations grouped by store (optional - may not be in JSON)
    @JsonKey(name: 'locations_by_store')
    @Default([]) List<StoreLocations> locationsByStore,

    /// Recent cash entries (optional - may not be in JSON)
    @JsonKey(name: 'recent_entries') @Default([]) List<CashEntry> recentEntries,

    /// Issues summary (locations with problems)
    @JsonKey(name: 'issues') @Default([]) List<CashLocationIssue> issues,

    /// AI-generated insights
    @JsonKey(name: 'ai_insights') required CashLocationInsights aiInsights,
  }) = _CashLocationReport;

  factory CashLocationReport.fromJson(Map<String, dynamic> json) =>
      _$CashLocationReportFromJson(json);
}

/// Hero stats for cash location summary
@freezed
class CashLocationHeroStats with _$CashLocationHeroStats {
  const factory CashLocationHeroStats({
    @JsonKey(name: 'total_locations') required int totalLocations,
    @JsonKey(name: 'balanced_count') required int balancedCount,
    @JsonKey(name: 'issues_count') required int issuesCount,
    @JsonKey(name: 'shortage_count') @Default(0) int shortageCount,
    @JsonKey(name: 'surplus_count') @Default(0) int surplusCount,
    @JsonKey(name: 'total_book_amount') required double totalBookAmount,
    @JsonKey(name: 'total_actual_amount') required double totalActualAmount,
    @JsonKey(name: 'net_difference') required double netDifference,
    @JsonKey(name: 'overall_status') required String overallStatus,
    // Formatted strings
    @JsonKey(name: 'total_book_formatted') required String totalBookFormatted,
    @JsonKey(name: 'total_actual_formatted')
    required String totalActualFormatted,
    @JsonKey(name: 'net_difference_formatted')
    required String netDifferenceFormatted,
  }) = _CashLocationHeroStats;

  factory CashLocationHeroStats.fromJson(Map<String, dynamic> json) =>
      _$CashLocationHeroStatsFromJson(json);
}

/// Locations grouped by store
@freezed
class StoreLocations with _$StoreLocations {
  const factory StoreLocations({
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'locations') required List<CashLocation> locations,
    @JsonKey(name: 'store_total_book') @Default(0) double storeTotalBook,
    @JsonKey(name: 'store_total_actual') @Default(0) double storeTotalActual,
    @JsonKey(name: 'store_difference') @Default(0) double storeDifference,
  }) = _StoreLocations;

  factory StoreLocations.fromJson(Map<String, dynamic> json) =>
      _$StoreLocationsFromJson(json);
}

/// Individual cash location
@freezed
class CashLocation with _$CashLocation {
  const factory CashLocation({
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'location_type') required String locationType, // cash, bank, vault
    @JsonKey(name: 'book_amount') required double bookAmount,
    @JsonKey(name: 'actual_amount') required double actualAmount,
    @JsonKey(name: 'difference') required double difference,
    @JsonKey(name: 'status') required String status, // balanced, shortage, surplus
    // Formatted strings
    @JsonKey(name: 'book_formatted') required String bookFormatted,
    @JsonKey(name: 'actual_formatted') required String actualFormatted,
    @JsonKey(name: 'difference_formatted') required String differenceFormatted,
  }) = _CashLocation;

  factory CashLocation.fromJson(Map<String, dynamic> json) =>
      _$CashLocationFromJson(json);
}

/// Recent cash entry
@freezed
class CashEntry with _$CashEntry {
  const factory CashEntry({
    @JsonKey(name: 'entry_id') required String entryId,
    @JsonKey(name: 'date') required String date,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'store_name') required String storeName,
    @JsonKey(name: 'employee_name') required String employeeName,
    @JsonKey(name: 'net_cash_flow') required double netCashFlow,
    @JsonKey(name: 'formatted_amount') required String formattedAmount,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'entry_type') String? entryType,
  }) = _CashEntry;

  factory CashEntry.fromJson(Map<String, dynamic> json) =>
      _$CashEntryFromJson(json);
}

/// Cash location issue with investigation data
@freezed
class CashLocationIssue with _$CashLocationIssue {
  const factory CashLocationIssue({
    @JsonKey(name: 'location_id') required String locationId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'location_type') required String locationType, // cash, bank, vault
    @JsonKey(name: 'store_id') required String storeId,
    @JsonKey(name: 'store_name') required String storeName,
    // Amounts
    @JsonKey(name: 'book_amount') required double bookAmount,
    @JsonKey(name: 'actual_amount') required double actualAmount,
    @JsonKey(name: 'difference') required double difference,
    // Formatted
    @JsonKey(name: 'book_formatted') required String bookFormatted,
    @JsonKey(name: 'actual_formatted') required String actualFormatted,
    @JsonKey(name: 'difference_formatted') required String differenceFormatted,
    // Issue info
    @JsonKey(name: 'issue_type') required String issueType, // shortage, surplus
    @JsonKey(name: 'severity') @Default('medium') String severity, // low, medium, high
    // Last entry (for investigation)
    @JsonKey(name: 'last_entry') LastEntryInfo? lastEntry,
  }) = _CashLocationIssue;

  factory CashLocationIssue.fromJson(Map<String, dynamic> json) =>
      _$CashLocationIssueFromJson(json);
}

/// Last entry info for a location (for investigation)
@freezed
class LastEntryInfo with _$LastEntryInfo {
  const factory LastEntryInfo({
    @JsonKey(name: 'entry_id') required String entryId,
    @JsonKey(name: 'employee_id') required String employeeId,
    @JsonKey(name: 'employee_name') required String employeeName,
    @JsonKey(name: 'entry_date') required String entryDate,
    @JsonKey(name: 'entry_time') required String entryTime,
    @JsonKey(name: 'amount') required double amount,
    @JsonKey(name: 'formatted_amount') required String formattedAmount,
    @JsonKey(name: 'description') String? description,
    @JsonKey(name: 'entry_type') String? entryType,
  }) = _LastEntryInfo;

  factory LastEntryInfo.fromJson(Map<String, dynamic> json) =>
      _$LastEntryInfoFromJson(json);
}

/// AI-generated insights for cash location
@freezed
class CashLocationInsights with _$CashLocationInsights {
  const factory CashLocationInsights({
    required String summary,
    required List<String> recommendations,
  }) = _CashLocationInsights;

  factory CashLocationInsights.fromJson(Map<String, dynamic> json) =>
      _$CashLocationInsightsFromJson(json);
}
