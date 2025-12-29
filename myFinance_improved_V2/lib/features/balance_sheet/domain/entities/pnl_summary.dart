import 'package:freezed_annotation/freezed_annotation.dart';

part 'pnl_summary.freezed.dart';

/// P&L Summary Entity (Domain Layer)
///
/// Pure business entity without JSON serialization.
/// Represents the Profit & Loss summary for a period.
@freezed
class PnlSummary with _$PnlSummary {
  const PnlSummary._();

  const factory PnlSummary({
    // Current period amounts
    @Default(0) double revenue,
    @Default(0) double cogs,
    @Default(0) double grossProfit,
    @Default(0) double operatingExpense,
    @Default(0) double operatingIncome,
    @Default(0) double nonOperatingExpense,
    @Default(0) double netIncome,

    // Margins (%)
    @Default(0) double grossMargin,
    @Default(0) double operatingMargin,
    @Default(0) double netMargin,

    // Previous period (nullable)
    double? prevRevenue,
    double? prevNetIncome,

    // Change percentages (nullable)
    double? revenueChangePct,
    double? netIncomeChangePct,
  }) = _PnlSummary;

  /// Check if there's previous period data for comparison
  bool get hasPreviousPeriod => prevRevenue != null || prevNetIncome != null;

  /// Check if revenue increased compared to previous period
  bool get isRevenueGrowing =>
      revenueChangePct != null && revenueChangePct! > 0;

  /// Check if net income increased compared to previous period
  bool get isNetIncomeGrowing =>
      netIncomeChangePct != null && netIncomeChangePct! > 0;

  /// Check if the business is profitable
  bool get isProfitable => netIncome > 0;
}

/// P&L Detail Row Entity (Domain Layer)
@freezed
class PnlDetailRow with _$PnlDetailRow {
  const factory PnlDetailRow({
    @Default('') String section,
    @Default(0) int sectionOrder,
    @Default('') String accountCode,
    @Default('') String accountName,
    @Default(0) double amount,
  }) = _PnlDetailRow;
}
