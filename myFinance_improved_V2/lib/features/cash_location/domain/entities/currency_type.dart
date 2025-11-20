// lib/features/cash_location/domain/entities/currency_type.dart

import 'package:freezed_annotation/freezed_annotation.dart';

part 'currency_type.freezed.dart';
part 'currency_type.g.dart';

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

  factory CurrencyType.fromJson(Map<String, dynamic> json) =>
      _$CurrencyTypeFromJson(json);
}
