// lib/features/cash_location/domain/entities/stock_flow.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_flow.freezed.dart';
part 'stock_flow.g.dart';

/// Domain entities for stock flow tracking in cash locations
/// These classes represent the core business logic for tracking
/// journal flows and actual cash flows
/// Note: Formatting methods removed - use presentation layer formatters

@freezed
class JournalFlow with _$JournalFlow {
  const factory JournalFlow({
    required String flowId,
    required String createdAt,
    required String systemTime,
    required double balanceBefore,
    required double flowAmount,
    required double balanceAfter,
    required String journalId,
    required String journalDescription,
    required String journalType,
    required String accountId,
    required String accountName,
    required CreatedBy createdBy,
    CounterAccount? counterAccount,
  }) = _JournalFlow;

  factory JournalFlow.fromJson(Map<String, dynamic> json) =>
      _$JournalFlowFromJson(json);
}

@freezed
class ActualFlow with _$ActualFlow {
  const factory ActualFlow({
    required String flowId,
    required String createdAt,
    required String systemTime,
    required double balanceBefore,
    required double flowAmount,
    required double balanceAfter,
    required CurrencyInfo currency,
    required CreatedBy createdBy,
    required List<DenominationDetail> currentDenominations,
  }) = _ActualFlow;

  factory ActualFlow.fromJson(Map<String, dynamic> json) =>
      _$ActualFlowFromJson(json);
}

@freezed
class LocationSummary with _$LocationSummary {
  const factory LocationSummary({
    required String cashLocationId,
    required String locationName,
    required String locationType,
    String? bankName,
    String? bankAccount,
    required String currencyCode,
    required String currencyId,
    String? baseCurrencySymbol,
  }) = _LocationSummary;

  factory LocationSummary.fromJson(Map<String, dynamic> json) =>
      _$LocationSummaryFromJson(json);
}

@freezed
class CounterAccount with _$CounterAccount {
  const factory CounterAccount({
    required String accountId,
    required String accountName,
    required String accountType,
    required double debit,
    required double credit,
    required String description,
  }) = _CounterAccount;

  factory CounterAccount.fromJson(Map<String, dynamic> json) =>
      _$CounterAccountFromJson(json);
}

@freezed
class CurrencyInfo with _$CurrencyInfo {
  const factory CurrencyInfo({
    required String currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
  }) = _CurrencyInfo;

  factory CurrencyInfo.fromJson(Map<String, dynamic> json) =>
      _$CurrencyInfoFromJson(json);
}

@freezed
class CreatedBy with _$CreatedBy {
  const factory CreatedBy({
    required String userId,
    required String fullName,
  }) = _CreatedBy;

  factory CreatedBy.fromJson(Map<String, dynamic> json) =>
      _$CreatedByFromJson(json);
}

@freezed
class DenominationDetail with _$DenominationDetail {
  const factory DenominationDetail({
    required String denominationId,
    required double denominationValue,
    required String denominationType,
    required int previousQuantity,
    required int currentQuantity,
    required int quantityChange,
    required double subtotal,
    String? currencySymbol,
    // Bank multi-currency fields
    String? currencyId,
    String? currencyCode,
    String? currencyName,
    double? amount,
    double? exchangeRate,
    double? amountInBaseCurrency,
  }) = _DenominationDetail;

  factory DenominationDetail.fromJson(Map<String, dynamic> json) =>
      _$DenominationDetailFromJson(json);
}

@freezed
class StockFlowData with _$StockFlowData {
  const factory StockFlowData({
    LocationSummary? locationSummary,
    required List<JournalFlow> journalFlows,
    required List<ActualFlow> actualFlows,
  }) = _StockFlowData;

  factory StockFlowData.fromJson(Map<String, dynamic> json) =>
      _$StockFlowDataFromJson(json);
}

@freezed
class PaginationInfo with _$PaginationInfo {
  const factory PaginationInfo({
    required int offset,
    required int limit,
    required int totalJournalFlows,
    required int totalActualFlows,
    required bool hasMore,
  }) = _PaginationInfo;

  factory PaginationInfo.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoFromJson(json);
}

@freezed
class StockFlowResponse with _$StockFlowResponse {
  const factory StockFlowResponse({
    required bool success,
    StockFlowData? data,
    PaginationInfo? pagination,
  }) = _StockFlowResponse;

  factory StockFlowResponse.fromJson(Map<String, dynamic> json) =>
      _$StockFlowResponseFromJson(json);
}
