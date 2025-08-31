import 'package:freezed_annotation/freezed_annotation.dart';

part 'revenue_models.freezed.dart';
part 'revenue_models.g.dart';

@freezed
class RevenueData with _$RevenueData {
  const factory RevenueData({
    @Default(0.0) double amount,
    @Default('USD') String currencySymbol,
    @Default('Today') String period,
    @Default(0.0) double comparisonAmount,
    @Default('') String comparisonPeriod,
  }) = _RevenueData;
  
  factory RevenueData.fromJson(Map<String, dynamic> json) => _$RevenueDataFromJson(json);
}

@freezed
class RevenueResponse with _$RevenueResponse {
  const factory RevenueResponse({
    @Default(0.0) double revenue,
    @Default('USD') String currency_symbol,
    @Default('Today') String period,
    @Default(0.0) double comparison_revenue,
    @Default('') String comparison_period,
  }) = _RevenueResponse;
  
  factory RevenueResponse.fromJson(Map<String, dynamic> json) => _$RevenueResponseFromJson(json);
}

/// Revenue period enumeration
enum RevenuePeriod {
  today('Today', 'yesterday'),
  yesterday('Yesterday', 'previous day'),
  thisMonth('This Month', 'last month'),
  lastMonth('Last Month', 'previous month'),
  thisYear('This Year', 'last year');
  
  const RevenuePeriod(this.displayName, this.comparisonText);
  
  final String displayName;
  final String comparisonText;
  
  static RevenuePeriod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'today':
        return RevenuePeriod.today;
      case 'yesterday':
        return RevenuePeriod.yesterday;
      case 'this month':
        return RevenuePeriod.thisMonth;
      case 'last month':
        return RevenuePeriod.lastMonth;
      case 'this year':
        return RevenuePeriod.thisYear;
      default:
        return RevenuePeriod.today;
    }
  }
}