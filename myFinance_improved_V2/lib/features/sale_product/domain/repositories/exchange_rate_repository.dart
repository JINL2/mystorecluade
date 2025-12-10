import '../entities/exchange_rate_data.dart';

/// Repository interface for exchange rates
abstract class ExchangeRateRepository {
  /// Get exchange rates for a company
  Future<ExchangeRateData?> getExchangeRates({
    required String companyId,
  });
}
