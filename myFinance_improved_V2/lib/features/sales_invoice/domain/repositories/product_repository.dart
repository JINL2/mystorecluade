import '../entities/cash_location.dart';
import '../entities/exchange_rate_data.dart';
import '../entities/payment_currency.dart';

/// Product repository interface for sales invoice
abstract class ProductRepository {
  /// Get currency data for payment
  Future<CurrencyDataResult> getCurrencyData({
    required String companyId,
  });

  /// Get cash locations
  Future<List<CashLocation>> getCashLocations({
    required String companyId,
    required String storeId,
  });

  /// Get exchange rates
  Future<ExchangeRateData?> getExchangeRates({
    required String companyId,
  });
}

/// Currency data result
class CurrencyDataResult {
  final PaymentCurrency baseCurrency;
  final List<PaymentCurrency> companyCurrencies;

  const CurrencyDataResult({
    required this.baseCurrency,
    required this.companyCurrencies,
  });
}

// ExchangeRateData moved to ../entities/exchange_rate_data.dart
// Import it from there if needed

