import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:myfinance_improved/core/utils/datetime_utils.dart';
import '../../../domain/entities/stock_flow.dart';

part 'stock_flow_dto.freezed.dart';
part 'stock_flow_dto.g.dart';

/// Location Summary DTO
@freezed
class LocationSummaryDto with _$LocationSummaryDto {
  const LocationSummaryDto._();

  const factory LocationSummaryDto({
    @JsonKey(name: 'cash_location_id') required String cashLocationId,
    @JsonKey(name: 'location_name') required String locationName,
    @JsonKey(name: 'location_type') required String locationType,
    @JsonKey(name: 'bank_name') String? bankName,
    @JsonKey(name: 'bank_account') String? bankAccount,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'base_currency_symbol') String? baseCurrencySymbol,
    @JsonKey(name: 'currency_symbol') String? currencySymbol,
  }) = _LocationSummaryDto;

  factory LocationSummaryDto.fromJson(Map<String, dynamic> json) =>
      _$LocationSummaryDtoFromJson(json);

  LocationSummary toEntity() {
    return LocationSummary(
      cashLocationId: cashLocationId,
      locationName: locationName,
      locationType: locationType,
      bankName: bankName,
      bankAccount: bankAccount,
      currencyCode: currencyCode,
      currencyId: currencyId,
      baseCurrencySymbol: baseCurrencySymbol ?? currencySymbol,
    );
  }
}

/// Currency Info DTO
@freezed
class CurrencyInfoDto with _$CurrencyInfoDto {
  const CurrencyInfoDto._();

  const factory CurrencyInfoDto({
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_name') required String currencyName,
    @JsonKey(name: 'symbol') required String symbol,
  }) = _CurrencyInfoDto;

  factory CurrencyInfoDto.fromJson(Map<String, dynamic> json) =>
      _$CurrencyInfoDtoFromJson(json);

  CurrencyInfo toEntity() {
    return CurrencyInfo(
      currencyId: currencyId,
      currencyCode: currencyCode,
      currencyName: currencyName,
      symbol: symbol,
    );
  }
}

/// Created By DTO
@freezed
class CreatedByDto with _$CreatedByDto {
  const CreatedByDto._();

  const factory CreatedByDto({
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _CreatedByDto;

  factory CreatedByDto.fromJson(Map<String, dynamic> json) =>
      _$CreatedByDtoFromJson(json);

  CreatedBy toEntity() {
    return CreatedBy(
      userId: userId,
      fullName: fullName,
    );
  }
}

/// Denomination Detail DTO
@freezed
class DenominationDetailDto with _$DenominationDetailDto {
  const DenominationDetailDto._();

  const factory DenominationDetailDto({
    @JsonKey(name: 'denomination_id') String? denominationId,
    @JsonKey(name: 'denomination_value') double? denominationValue,
    @JsonKey(name: 'denomination_type') String? denominationType,
    @JsonKey(name: 'previous_quantity') int? previousQuantity,
    @JsonKey(name: 'current_quantity') int? currentQuantity,
    @JsonKey(name: 'quantity_change') int? quantityChange,
    @JsonKey(name: 'subtotal') double? subtotal,
    @JsonKey(name: 'currency_symbol') String? currencySymbol,
  }) = _DenominationDetailDto;

  factory DenominationDetailDto.fromJson(Map<String, dynamic> json) =>
      _$DenominationDetailDtoFromJson(json);

  DenominationDetail toEntity() {
    return DenominationDetail(
      denominationId: denominationId ?? '',
      denominationValue: denominationValue ?? 0.0,
      denominationType: denominationType ?? '',
      previousQuantity: previousQuantity,
      currentQuantity: currentQuantity,
      quantityChange: quantityChange,
      subtotal: subtotal ?? 0.0,
      currencySymbol: currencySymbol,
    );
  }
}

/// Actual Flow DTO
@freezed
class ActualFlowDto with _$ActualFlowDto {
  const ActualFlowDto._();

  const factory ActualFlowDto({
    @JsonKey(name: 'flow_id') required String flowId,
    @JsonKey(name: 'created_at') required String createdAt,
    @JsonKey(name: 'system_time') required String systemTime,
    @JsonKey(name: 'balance_before') required double balanceBefore,
    @JsonKey(name: 'flow_amount') required double flowAmount,
    @JsonKey(name: 'balance_after') required double balanceAfter,
    @JsonKey(name: 'currency') required CurrencyInfoDto currency,
    @JsonKey(name: 'created_by') required CreatedByDto createdBy,
    @JsonKey(name: 'current_denominations') @Default([])
    List<DenominationDetailDto> currentDenominations,
  }) = _ActualFlowDto;

  factory ActualFlowDto.fromJson(Map<String, dynamic> json) =>
      _$ActualFlowDtoFromJson(json);

  ActualFlow toEntity() {
    // ✅ UTC Migration: RPC now returns timestamptz from created_at_utc and system_time_utc
    // Convert UTC strings to local time for display
    final createdAtLocal = (createdAt.isNotEmpty)
        ? DateTimeUtils.toLocal(createdAt).toIso8601String()
        : '';
    final systemTimeLocal = (systemTime.isNotEmpty)
        ? DateTimeUtils.toLocal(systemTime).toIso8601String()
        : '';

    return ActualFlow(
      flowId: flowId,
      createdAt: createdAtLocal,
      systemTime: systemTimeLocal,
      balanceBefore: balanceBefore,
      flowAmount: flowAmount,
      balanceAfter: balanceAfter,
      currency: currency.toEntity(),
      createdBy: createdBy.toEntity(),
      currentDenominations: currentDenominations.map((d) => d.toEntity()).toList(),
    );
  }
}

/// Pagination Info DTO
@freezed
class PaginationInfoDto with _$PaginationInfoDto {
  const PaginationInfoDto._();

  const factory PaginationInfoDto({
    @JsonKey(name: 'offset') @Default(0) int offset,
    @JsonKey(name: 'limit') @Default(20) int limit,
    @JsonKey(name: 'total_journal_flows') @Default(0) int totalJournalFlows,
    @JsonKey(name: 'total_actual_flows') @Default(0) int totalActualFlows,
    @JsonKey(name: 'has_more') @Default(false) bool hasMore,
  }) = _PaginationInfoDto;

  factory PaginationInfoDto.fromJson(Map<String, dynamic> json) =>
      _$PaginationInfoDtoFromJson(json);

  PaginationInfo toEntity() {
    return PaginationInfo(
      offset: offset,
      limit: limit,
      totalJournalFlows: totalJournalFlows,
      totalActualFlows: totalActualFlows,
      hasMore: hasMore,
    );
  }
}

/// Stock Flow Data DTO
@freezed
class StockFlowDataDto with _$StockFlowDataDto {
  const StockFlowDataDto._();

  const factory StockFlowDataDto({
    @JsonKey(name: 'location_summary') LocationSummaryDto? locationSummary,
    @JsonKey(name: 'actual_flows') @Default([]) List<ActualFlowDto> actualFlows,
  }) = _StockFlowDataDto;

  factory StockFlowDataDto.fromJson(Map<String, dynamic> json) =>
      _$StockFlowDataDtoFromJson(json);
}

/// Stock Flow Response DTO
@freezed
class StockFlowResponseDto with _$StockFlowResponseDto {
  const StockFlowResponseDto._();

  const factory StockFlowResponseDto({
    @JsonKey(name: 'success') @Default(false) bool success,
    @JsonKey(name: 'data') StockFlowDataDto? data,
    @JsonKey(name: 'pagination') PaginationInfoDto? pagination,
  }) = _StockFlowResponseDto;

  factory StockFlowResponseDto.fromJson(Map<String, dynamic> json) =>
      _$StockFlowResponseDtoFromJson(json);
}
