// lib/features/cash_location/domain/entities/currency_type.dart
// Note: JSON serialization is handled by data/models layer

import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_type.freezed.dart';

/// Domain entity for currency types
@freezed
class CurrencyType with _$CurrencyType {
  const factory CurrencyType({
    String? currencyId,
    required String currencyCode,
    required String currencyName,
    required String symbol,
    @Default(2) int decimalPlaces,
    @Default(true) bool isActive,
  }) = _CurrencyType;
}
