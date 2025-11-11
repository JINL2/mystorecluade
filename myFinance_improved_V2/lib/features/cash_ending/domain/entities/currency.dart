// lib/features/cash_ending/domain/entities/currency.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'denomination.dart';

part 'currency.freezed.dart';

/// Domain entity representing a currency
///
/// Maps to `currency_types` table in database.
/// DB columns: currency_id (uuid), currency_code (text), currency_name (text), symbol (text)
@freezed
class Currency with _$Currency {
  const factory Currency({
    required String currencyId,
    required String currencyCode, // e.g., 'KRW', 'USD', 'JPY'
    required String currencyName, // e.g., 'Korean Won'
    required String symbol, // e.g., '₩', '$', '¥'
    @Default([]) List<Denomination> denominations,
  }) = _Currency;

  const Currency._();

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
