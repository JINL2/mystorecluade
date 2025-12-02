import 'package:equatable/equatable.dart';

/// Exchange rate data entity
class ExchangeRateData extends Equatable {
  final Currency baseCurrency;
  final List<ExchangeRate> rates;

  const ExchangeRateData({
    required this.baseCurrency,
    required this.rates,
  });

  /// Find exchange rate by currency code
  double? findRate(String currencyCode) {
    try {
      return rates
          .firstWhere((rate) => rate.currencyCode == currencyCode)
          .rate;
    } catch (_) {
      return null;
    }
  }

  @override
  List<Object?> get props => [baseCurrency, rates];
}

/// Currency information
class Currency extends Equatable {
  final String currencyCode;
  final String symbol;
  final String? name;

  const Currency({
    required this.currencyCode,
    required this.symbol,
    this.name,
  });

  @override
  List<Object?> get props => [currencyCode, symbol, name];
}

/// Exchange rate for a specific currency
class ExchangeRate extends Equatable {
  final String currencyCode;
  final String symbol;
  final double rate;
  final String? name;

  const ExchangeRate({
    required this.currencyCode,
    required this.symbol,
    required this.rate,
    this.name,
  });

  @override
  List<Object?> get props => [currencyCode, symbol, rate, name];
}
