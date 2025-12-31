import 'package:flutter_riverpod/flutter_riverpod.dart';

// Feature - DI (Dependency Injection)
import '../../di/providers.dart';

// Provider to fetch exchange rate between two currencies
final exchangeRateProvider = FutureProvider.autoDispose.family<double?, ExchangeRateParams>((ref, params) async {
  final service = ref.watch(exchangeRateServiceProvider);
  
  return await service.getExchangeRate(params.baseCurrency, params.targetCurrency);
});

// Parameter classes for the providers
class ExchangeRateParams {
  final String baseCurrency;
  final String targetCurrency;
  
  const ExchangeRateParams({
    required this.baseCurrency,
    required this.targetCurrency,
  });
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is ExchangeRateParams &&
    runtimeType == other.runtimeType &&
    baseCurrency == other.baseCurrency &&
    targetCurrency == other.targetCurrency;

  @override
  int get hashCode => baseCurrency.hashCode ^ targetCurrency.hashCode;
}

class MultipleExchangeRateParams {
  final String baseCurrency;
  final List<String> targetCurrencies;
  
  const MultipleExchangeRateParams({
    required this.baseCurrency,
    required this.targetCurrencies,
  });
  
  @override
  bool operator ==(Object other) =>
    identical(this, other) ||
    other is MultipleExchangeRateParams &&
    runtimeType == other.runtimeType &&
    baseCurrency == other.baseCurrency &&
    _listEquals(targetCurrencies, other.targetCurrencies);

  @override
  int get hashCode => baseCurrency.hashCode ^ Object.hashAll(targetCurrencies);
  
  bool _listEquals<T>(List<T> a, List<T> b) {
    if (a.length != b.length) return false;
    for (int i = 0; i < a.length; i++) {
      if (a[i] != b[i]) return false;
    }
    return true;
  }
}