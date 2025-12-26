// lib/features/cash_location/domain/entities/stock_flow/actual_flow.dart

import 'package:freezed_annotation/freezed_annotation.dart';

import 'shared_entities.dart';

part 'actual_flow.freezed.dart';

/// Domain entity for actual cash flow tracking
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

/// Denomination detail for actual flows
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
