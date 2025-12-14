// Presentation Helper: Exchange Rate Data Conversion
// Converts JSON to Domain entity without exposing Data Model to Presentation

import '../../domain/entities/exchange_rate_data.dart';

/// Helper to convert exchange rate JSON to domain entity
/// This keeps the Data Model encapsulated within the Data layer
class ExchangeRateHelper {
  ExchangeRateHelper._();

  /// Convert JSON response to ExchangeRateData entity
  static ExchangeRateData? fromJson(Map<String, dynamic>? json) {
    if (json == null) return null;

    final baseCurrencyJson = json['base_currency'] as Map<String, dynamic>?;
    final ratesJson = json['exchange_rates'] as List?;

    return ExchangeRateData(
      baseCurrency: Currency(
        currencyCode: baseCurrencyJson?['currency_code']?.toString() ?? 'VND',
        symbol: baseCurrencyJson?['symbol']?.toString() ?? '₫',
        name: baseCurrencyJson?['currency_name']?.toString(),
      ),
      rates: (ratesJson ?? [])
          .cast<Map<String, dynamic>>()
          .map((rateJson) {
            // Support both 'exchange_rate' (RPC response) and 'rate' (internal)
            final rateValue = rateJson['exchange_rate'] ?? rateJson['rate'];
            return ExchangeRate(
                currencyCode: rateJson['currency_code']?.toString() ?? '',
                symbol: rateJson['symbol']?.toString() ?? '',
                rate: (rateValue as num?)?.toDouble() ?? 1.0,
                name: rateJson['currency_name']?.toString(),
              );
          })
          .toList(),
    );
  }
}
