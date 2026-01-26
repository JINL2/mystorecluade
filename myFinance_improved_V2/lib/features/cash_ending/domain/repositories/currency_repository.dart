// lib/features/cash_ending/domain/repositories/currency_repository.dart

import '../entities/currency.dart';

/// Repository interface for Currency operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
///
/// NOTE: Denominations are included in Currency entity via
/// get_company_currencies_with_exchange_rates RPC. No separate query needed.
abstract class CurrencyRepository {
  /// Get company currencies with exchange rates (RPC method)
  ///
  /// Business Logic:
  /// - Fetch all currencies for a company
  /// - Include base currency identification
  /// - Include exchange rates to base currency
  /// - Include denominations (embedded in response)
  ///
  /// [rateDate] - Optional date for historical exchange rates (default: today)
  ///
  /// Returns list of currencies with exchange rate info and denominations
  /// Returns empty list if no currencies found
  Future<List<Currency>> getCompanyCurrenciesWithExchangeRates({
    required String companyId,
    DateTime? rateDate,
  });
}
