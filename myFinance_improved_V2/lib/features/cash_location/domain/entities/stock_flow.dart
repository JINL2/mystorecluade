// lib/features/cash_location/domain/entities/stock_flow.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'stock_flow.freezed.dart';

/// Domain entities for stock flow tracking in cash locations
/// These classes represent the core business logic for tracking
/// journal flows and actual cash flows
/// Note: JSON serialization is handled by data/models layer

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
    String? journalAiDescription,
    required String journalType,
    required String accountId,
    required String accountName,
    required CreatedBy createdBy,
    CounterAccount? counterAccount,
    @Default([]) List<JournalAttachment> attachments,
  }) = _JournalFlow;
}

/// Attachment entity for journal flows
@freezed
class JournalAttachment with _$JournalAttachment {
  const JournalAttachment._();

  const factory JournalAttachment({
    required String attachmentId,
    required String fileName,
    required String fileType,
    String? fileUrl,
    String? ocrText,
    String? ocrStatus,
  }) = _JournalAttachment;

  /// Check if this is an image file
  bool get isImage => fileType.startsWith('image/');

  /// Check if this is a PDF file
  bool get isPdf => fileType == 'application/pdf';

  /// Check if this attachment has OCR text
  bool get hasOcr => ocrText != null && ocrText!.isNotEmpty;
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
}

@freezed
class CurrencyInfo with _$CurrencyInfo {
  const factory CurrencyInfo({
    required String currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
  }) = _CurrencyInfo;
}

@freezed
class CreatedBy with _$CreatedBy {
  const factory CreatedBy({
    required String userId,
    required String fullName,
    String? profileImage,
  }) = _CreatedBy;
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
}

@freezed
class StockFlowData with _$StockFlowData {
  const factory StockFlowData({
    LocationSummary? locationSummary,
    required List<JournalFlow> journalFlows,
    required List<ActualFlow> actualFlows,
  }) = _StockFlowData;
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
}

@freezed
class StockFlowResponse with _$StockFlowResponse {
  const factory StockFlowResponse({
    required bool success,
    StockFlowData? data,
    PaginationInfo? pagination,
  }) = _StockFlowResponse;
}
