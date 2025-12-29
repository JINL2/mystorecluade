import '../../domain/entities/exchange_rate_data.dart';

/// Exchange rate data model for data transfer
class ExchangeRateDataModel {
  final Map<String, dynamic> json;

  ExchangeRateDataModel(this.json);

  /// Create from JSON
  factory ExchangeRateDataModel.fromJson(Map<String, dynamic> json) {
    return ExchangeRateDataModel(json);
  }

  /// Convert to domain entity
  ExchangeRateData toEntity() {
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
          .map(
            (rateJson) => ExchangeRate(
              currencyCode: rateJson['currency_code']?.toString() ?? '',
              symbol: rateJson['symbol']?.toString() ?? '',
              rate: (rateJson['rate'] as num?)?.toDouble() ?? 1.0,
              name: rateJson['currency_name']?.toString(),
            ),
          )
          .toList(),
    );
  }
}
