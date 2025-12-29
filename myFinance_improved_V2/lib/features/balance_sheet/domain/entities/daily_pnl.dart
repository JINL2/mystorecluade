import 'package:freezed_annotation/freezed_annotation.dart';

part 'daily_pnl.freezed.dart';

/// Daily P&L Entity (Domain Layer)
///
/// Pure business entity without JSON serialization.
/// Represents daily P&L data for trend analysis.
@freezed
class DailyPnl with _$DailyPnl {
  const DailyPnl._();

  const factory DailyPnl({
    required DateTime date,
    @Default(0) double revenue,
    @Default(0) double cogs,
    @Default(0) double opex,
    @Default(0) double netIncome,
  }) = _DailyPnl;

  /// Gross profit for the day
  double get grossProfit => revenue - cogs;

  /// Operating income for the day
  double get operatingIncome => grossProfit - opex;

  /// Check if the day was profitable
  bool get isProfitable => netIncome > 0;

  /// Gross margin percentage
  double get grossMargin => revenue > 0 ? (grossProfit / revenue) * 100 : 0;

  /// Net margin percentage
  double get netMargin => revenue > 0 ? (netIncome / revenue) * 100 : 0;
}
