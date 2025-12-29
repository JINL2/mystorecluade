import 'package:freezed_annotation/freezed_annotation.dart';

part 'bs_summary.freezed.dart';

/// Balance Sheet Summary Entity (Domain Layer)
///
/// Pure business entity without JSON serialization.
/// Represents the Balance Sheet summary as of a specific date.
@freezed
class BsSummary with _$BsSummary {
  const BsSummary._();

  const factory BsSummary({
    // Current amounts
    @Default(0) double totalAssets,
    @Default(0) double currentAssets,
    @Default(0) double nonCurrentAssets,
    @Default(0) double totalLiabilities,
    @Default(0) double currentLiabilities,
    @Default(0) double nonCurrentLiabilities,
    @Default(0) double totalEquity,

    // Balance check (should be 0 if balanced)
    @Default(0) double balanceCheck,

    // Previous period (nullable)
    double? prevTotalAssets,
    double? prevTotalEquity,

    // Change percentages (nullable)
    double? assetsChangePct,
    double? equityChangePct,
  }) = _BsSummary;

  /// Whether the balance sheet is balanced (Assets = Liabilities + Equity)
  bool get isBalanced => balanceCheck.abs() < 0.01;

  /// Check if there's previous period data for comparison
  bool get hasPreviousPeriod =>
      prevTotalAssets != null || prevTotalEquity != null;

  /// Check if assets grew compared to previous period
  bool get isAssetsGrowing => assetsChangePct != null && assetsChangePct! > 0;

  /// Check if equity grew compared to previous period
  bool get isEquityGrowing => equityChangePct != null && equityChangePct! > 0;

  /// Debt to equity ratio (if equity is positive)
  double? get debtToEquityRatio {
    if (totalEquity <= 0) return null;
    return totalLiabilities / totalEquity;
  }

  /// Current ratio (current assets / current liabilities)
  double? get currentRatio {
    if (currentLiabilities <= 0) return null;
    return currentAssets / currentLiabilities;
  }
}

/// B/S Detail Row Entity (Domain Layer)
@freezed
class BsDetailRow with _$BsDetailRow {
  const factory BsDetailRow({
    @Default('') String section,
    @Default(0) int sectionOrder,
    @Default('') String accountCode,
    @Default('') String accountName,
    @Default(0) double balance,
  }) = _BsDetailRow;
}
