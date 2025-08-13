import 'package:freezed_annotation/freezed_annotation.dart';

part 'balance_sheet_models.freezed.dart';
part 'balance_sheet_models.g.dart';

/// Balance Sheet main model
@freezed
class BalanceSheet with _$BalanceSheet {
  const factory BalanceSheet({
    required String id,
    required String companyId,
    required String storeId,
    required DateTime periodDate,
    required Assets assets,
    required Liabilities liabilities,
    required Equity equity,
    required double totalAssets,
    required double totalLiabilities,
    required double totalEquity,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _BalanceSheet;

  factory BalanceSheet.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetFromJson(json);
}

/// Assets model
@freezed
class Assets with _$Assets {
  const factory Assets({
    required CurrentAssets currentAssets,
    required NonCurrentAssets nonCurrentAssets,
    required double total,
  }) = _Assets;

  factory Assets.fromJson(Map<String, dynamic> json) =>
      _$AssetsFromJson(json);
}

/// Current Assets model
@freezed
class CurrentAssets with _$CurrentAssets {
  const factory CurrentAssets({
    required double cash,
    required double accountsReceivable,
    required double inventory,
    required double prepaidExpenses,
    required double otherCurrentAssets,
    required double total,
  }) = _CurrentAssets;

  factory CurrentAssets.fromJson(Map<String, dynamic> json) =>
      _$CurrentAssetsFromJson(json);
}

/// Non-Current Assets model
@freezed
class NonCurrentAssets with _$NonCurrentAssets {
  const factory NonCurrentAssets({
    required double propertyPlantEquipment,
    required double intangibleAssets,
    required double investments,
    required double otherNonCurrentAssets,
    required double total,
  }) = _NonCurrentAssets;

  factory NonCurrentAssets.fromJson(Map<String, dynamic> json) =>
      _$NonCurrentAssetsFromJson(json);
}

/// Liabilities model
@freezed
class Liabilities with _$Liabilities {
  const factory Liabilities({
    required CurrentLiabilities currentLiabilities,
    required NonCurrentLiabilities nonCurrentLiabilities,
    required double total,
  }) = _Liabilities;

  factory Liabilities.fromJson(Map<String, dynamic> json) =>
      _$LiabilitiesFromJson(json);
}

/// Current Liabilities model
@freezed
class CurrentLiabilities with _$CurrentLiabilities {
  const factory CurrentLiabilities({
    required double accountsPayable,
    required double shortTermDebt,
    required double accruedExpenses,
    required double currentPortionLongTermDebt,
    required double otherCurrentLiabilities,
    required double total,
  }) = _CurrentLiabilities;

  factory CurrentLiabilities.fromJson(Map<String, dynamic> json) =>
      _$CurrentLiabilitiesFromJson(json);
}

/// Non-Current Liabilities model
@freezed
class NonCurrentLiabilities with _$NonCurrentLiabilities {
  const factory NonCurrentLiabilities({
    required double longTermDebt,
    required double deferredTaxLiabilities,
    required double otherNonCurrentLiabilities,
    required double total,
  }) = _NonCurrentLiabilities;

  factory NonCurrentLiabilities.fromJson(Map<String, dynamic> json) =>
      _$NonCurrentLiabilitiesFromJson(json);
}

/// Equity model
@freezed
class Equity with _$Equity {
  const factory Equity({
    required double commonStock,
    required double retainedEarnings,
    required double additionalPaidInCapital,
    required double otherEquity,
    required double total,
  }) = _Equity;

  factory Equity.fromJson(Map<String, dynamic> json) =>
      _$EquityFromJson(json);
}

/// Balance Sheet Summary for display
@freezed
class BalanceSheetSummary with _$BalanceSheetSummary {
  const factory BalanceSheetSummary({
    required String companyName,
    required String storeName,
    required DateTime periodDate,
    required double totalAssets,
    required double totalLiabilities,
    required double totalEquity,
    required double currentRatio,
    required double debtToEquityRatio,
    required double returnOnEquity,
  }) = _BalanceSheetSummary;

  factory BalanceSheetSummary.fromJson(Map<String, dynamic> json) =>
      _$BalanceSheetSummaryFromJson(json);
}

/// Financial Ratios model
@freezed
class FinancialRatios with _$FinancialRatios {
  const factory FinancialRatios({
    // Liquidity Ratios
    required double currentRatio,
    required double quickRatio,
    required double cashRatio,
    
    // Leverage Ratios
    required double debtToEquityRatio,
    required double debtToAssetsRatio,
    required double equityMultiplier,
    
    // Efficiency Ratios
    required double assetTurnover,
    required double inventoryTurnover,
    required double receivablesTurnover,
    
    // Profitability Ratios
    required double returnOnAssets,
    required double returnOnEquity,
    required double grossProfitMargin,
    required double netProfitMargin,
  }) = _FinancialRatios;

  factory FinancialRatios.fromJson(Map<String, dynamic> json) =>
      _$FinancialRatiosFromJson(json);
}