import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_models.freezed.dart';
part 'revenue_models.g.dart';

/// Revenue data model for tracking store revenue
@freezed
class RevenueData with _$RevenueData {
  const factory RevenueData({
    @Default(0.0) double amount,
    @Default('USD') String currencySymbol,
    @Default('Today') String period,
    @Default(0.0) double comparisonAmount,
    @Default('') String comparisonPeriod,
    DateTime? lastUpdated,
    @Default(false) bool isLoading,
    String? errorMessage,
  }) = _RevenueData;

  factory RevenueData.fromJson(Map<String, dynamic> json) =>
      _$RevenueDataFromJson(json);
}

/// Revenue response from API/Database
@freezed
class RevenueResponse with _$RevenueResponse {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory RevenueResponse({
    required double amount,
    required String currencySymbol,
    required String period,
    double? comparisonAmount,
    String? comparisonPeriod,
    DateTime? lastUpdated,
    String? storeId,
    String? companyId,
  }) = _RevenueResponse;

  factory RevenueResponse.fromJson(Map<String, dynamic> json) =>
      _$RevenueResponseFromJson(json);
}

/// Revenue period enumeration
enum RevenuePeriod {
  today('Today', 'vs Yesterday'),
  yesterday('Yesterday', 'vs Day Before'),
  thisWeek('This Week', 'vs Last Week'),
  thisMonth('This Month', 'vs Last Month'),
  thisYear('This Year', 'vs Last Year');

  final String displayName;
  final String comparisonText;

  const RevenuePeriod(this.displayName, this.comparisonText);

  static RevenuePeriod fromString(String value) {
    return RevenuePeriod.values.firstWhere(
      (period) => period.name == value || period.displayName == value,
      orElse: () => RevenuePeriod.today,
    );
  }
}

/// Revenue breakdown by category
@freezed
class RevenueCategoryBreakdown with _$RevenueCategoryBreakdown {
  const factory RevenueCategoryBreakdown({
    required String category,
    required double amount,
    required double percentage,
    @Default('') String iconName,
    @Default('#000000') String colorHex,
  }) = _RevenueCategoryBreakdown;

  factory RevenueCategoryBreakdown.fromJson(Map<String, dynamic> json) =>
      _$RevenueCategoryBreakdownFromJson(json);
}

/// Daily revenue summary
@freezed
class DailyRevenueSummary with _$DailyRevenueSummary {
  const factory DailyRevenueSummary({
    required DateTime date,
    required double grossRevenue,
    required double netRevenue,
    required double expenses,
    required int transactionCount,
    required String currencySymbol,
    @Default([]) List<RevenueCategoryBreakdown> categoryBreakdown,
  }) = _DailyRevenueSummary;

  factory DailyRevenueSummary.fromJson(Map<String, dynamic> json) =>
      _$DailyRevenueSummaryFromJson(json);
}