import '../../domain/entities/payment_currency.dart';

/// Payment currency model for data transfer
class PaymentCurrencyModel {
  final Map<String, dynamic> json;

  PaymentCurrencyModel(this.json);

  /// Create from JSON
  factory PaymentCurrencyModel.fromJson(Map<String, dynamic> json) {
    return PaymentCurrencyModel(json);
  }

  /// Convert to domain entity
  PaymentCurrency toEntity() {
    return PaymentCurrency(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      flagEmoji: json['flag_emoji']?.toString() ?? '',
      exchangeRateToBase: (json['exchange_rate_to_base'] as num?)?.toDouble(),
      rateDate: json['rate_date']?.toString(),
    );
  }
}
