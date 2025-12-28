import '../entities/exchange_rate_data.dart';

/// Repository interface for exchange rates
abstract class ExchangeRateRepository {
  /// Get exchange rates for a company
  /// [storeId] is optional - when provided, currencies are sorted by foreign currency balance
  Future<ExchangeRateData?> getExchangeRates({
    required String companyId,
    String? storeId,
  });
}
