// lib/features/cash_ending/domain/repositories/currency_repository.dart

import '../entities/currency.dart';
import '../entities/denomination.dart';

/// Repository interface for Currency operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class CurrencyRepository {
  /// Get company currencies with exchange rates (NEW - RPC method)
  ///
  /// Business Logic:
  /// - Fetch all currencies for a company
  /// - Include base currency identification
  /// - Include exchange rates to base currency
  /// - Include denominations
  ///
  /// [rateDate] - Optional date for historical exchange rates (default: today)
  ///
  /// Returns list of currencies with exchange rate info
  /// Returns empty list if no currencies found
  Future<List<Currency>> getCompanyCurrenciesWithExchangeRates({
    required String companyId,
    DateTime? rateDate,
  });

  /// Get all active currencies for a company (LEGACY)
  ///
  /// Returns list of currencies with their denominations
  /// Returns empty list if no currencies found
  @Deprecated('Use getCompanyCurrenciesWithExchangeRates instead')
  Future<List<Currency>> getCompanyCurrencies(String companyId);

  /// Get denominations for a specific currency
  ///
  /// Returns list of denominations ordered by value descending
  /// Returns empty list if no denominations found
  Future<List<Denomination>> getDenominationsByCurrency({
    required String companyId,
    required String currencyId,
  });

  /// Get all currency types available in the system
  ///
  /// This fetches the master list of currency types (KRW, USD, etc.)
  /// Returns empty list if none found
  Future<List<Currency>> getAllCurrencyTypes();
}
