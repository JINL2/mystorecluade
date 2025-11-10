// lib/features/cash_ending/domain/entities/currency.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'denomination.dart';

part 'currency.freezed.dart';
part 'currency.g.dart';

/// Domain entity representing a currency
///
/// Uses Freezed for:
/// - Immutability guarantee
/// - Auto-generated copyWith, ==, hashCode
/// - JSON serialization support
@freezed
class Currency with _$Currency {
  const Currency._();

  const factory Currency({
    @JsonKey(name: 'currency_id') required String currencyId,
    @JsonKey(name: 'currency_code') required String currencyCode,
    @JsonKey(name: 'currency_name') required String currencyName,
    @JsonKey(name: 'symbol') required String symbol,
    @Default([]) List<Denomination> denominations,
  }) = _Currency;

  /// Create from JSON (from database)
  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);

  /// Calculate total amount for all denominations in this currency
  double get totalAmount {
    return denominations.fold(
      0.0,
      (sum, denom) => sum + denom.totalAmount,
    );
  }

  /// Check if this currency has any denomination quantities entered
  bool get hasData {
    return denominations.any((denom) => denom.hasQuantity);
  }

  /// Get only denominations that have quantity > 0
  List<Denomination> get activeDenominations {
    return denominations.where((denom) => denom.hasQuantity).toList();
  }
}
