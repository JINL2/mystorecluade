// lib/features/cash_ending/domain/entities/currency.dart

import 'package:freezed_annotation/freezed_annotation.dart';
import 'denomination.dart';

part 'currency.freezed.dart';

/// Domain entity representing a currency
///
/// Maps to RPC: get_company_currencies_with_exchange_rates
@freezed
class Currency with _$Currency {
  const factory Currency({
    required String currencyId,
    String? companyCurrencyId,
    required String currencyCode, // e.g., 'KRW', 'USD', 'JPY'
    required String currencyName, // e.g., 'Korean Won'
    required String symbol, // e.g., '₩', '$', '¥'
    String? flagEmoji,

    // Grand Total calculation fields
    @Default(false) bool isBaseCurrency,
    @Default(1.0) double exchangeRateToBase,

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

  /// Calculate total amount in base currency
  ///
  /// Grand Total Calculation Logic:
  /// ```
  /// totalInBaseCurrency = totalAmount × exchangeRateToBase
  /// ```
  ///
  /// Example:
  /// - Currency: USD
  /// - Total: $100
  /// - Exchange Rate: 26,227.24 (USD → VND)
  /// - Result: ₫2,622,724
  double get totalAmountInBaseCurrency {
    return totalAmount * exchangeRateToBase;
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
