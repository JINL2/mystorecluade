/// Currency converter for exchange rate calculations
///
/// Contains business logic for currency conversion operations.
class CurrencyConverter {
  CurrencyConverter._();

  /// Convert amount from base currency to target currency
  ///
  /// Parameters:
  /// - [baseAmount]: Amount in base currency
  /// - [exchangeRate]: Exchange rate (1 base = X target)
  ///
  /// Returns: Converted amount in target currency
  static double convert({
    required double baseAmount,
    required double exchangeRate,
  }) {
    if (exchangeRate <= 0) {
      throw ArgumentError('Exchange rate must be greater than 0');
    }
    return baseAmount * exchangeRate;
  }

  /// Convert amount using exchange rate to base
  ///
  /// Parameters:
  /// - [amount]: Amount to convert
  /// - [exchangeRateToBase]: Rate to convert to base currency
  ///
  /// Returns: Amount in base currency
  static double convertToBase({
    required double amount,
    required double exchangeRateToBase,
  }) {
    if (exchangeRateToBase <= 0) {
      return amount;
    }
    return amount / exchangeRateToBase;
  }

  /// Find exchange rate from currency data
  ///
  /// Parameters:
  /// - [targetCurrencyCode]: Target currency code (e.g., 'USD', 'KRW')
  /// - [exchangeRates]: List of exchange rate data
  ///
  /// Returns: Exchange rate or 1.0 if not found
  static double findExchangeRate({
    required String targetCurrencyCode,
    required List<Map<String, dynamic>> exchangeRates,
  }) {
    try {
      final rateData = exchangeRates.firstWhere(
        (rate) => rate['currency_code'] == targetCurrencyCode,
        orElse: () => {'rate': 1.0},
      );
      return (rateData['rate'] as num?)?.toDouble() ?? 1.0;
    } catch (e) {
      return 1.0;
    }
  }
}
