// lib/features/cash_ending/domain/usecases/load_currencies_usecase.dart

import '../../../../core/monitoring/sentry_config.dart';
import '../entities/currency.dart';
import '../repositories/currency_repository.dart';

/// Result object for LoadCurrenciesUseCase
class LoadCurrenciesResult {
  final List<Currency> currencies;
  final String? defaultCurrencyId;
  final Currency? baseCurrency;

  const LoadCurrenciesResult({
    required this.currencies,
    this.defaultCurrencyId,
    this.baseCurrency,
  });

  /// Calculate Grand Total in base currency
  ///
  /// Logic: Sum of all currencies converted to base currency
  /// ```
  /// Grand Total = Σ(currency.totalAmount × currency.exchangeRateToBase)
  /// ```
  double get grandTotalInBaseCurrency {
    return currencies.fold(
      0.0,
      (sum, currency) => sum + currency.totalAmountInBaseCurrency,
    );
  }
}

/// UseCase: Load company currencies with auto-selection logic
///
/// Business Logic:
/// - Load all currencies for a company
/// - Auto-select first currency as default if available
/// - This ensures the UI always has a valid selection
class LoadCurrenciesUseCase {
  final CurrencyRepository _currencyRepository;

  LoadCurrenciesUseCase(this._currencyRepository);

  /// Execute the use case
  ///
  /// [companyId] - The company ID to load currencies for
  ///
  /// Returns currencies with a default selection and base currency
  Future<LoadCurrenciesResult> execute(String companyId) async {
    try {
      // RPC call to get currencies with exchange rates
      final currencies = await _currencyRepository
          .getCompanyCurrenciesWithExchangeRates(
        companyId: companyId,
      );

      // Business Rule: Find base currency
      Currency? baseCurrency;
      try {
        baseCurrency = currencies.firstWhere(
          (c) => c.isBaseCurrency,
        );
      } catch (e) {
        // If no base currency found, use first currency as fallback
        baseCurrency = currencies.isNotEmpty ? currencies.first : null;
      }

      // Business Rule: Auto-select first currency as default
      // This ensures the UI is always in a valid state
      final defaultCurrencyId = currencies.isNotEmpty
          ? currencies.first.currencyId
          : null;

      return LoadCurrenciesResult(
        currencies: currencies,
        defaultCurrencyId: defaultCurrencyId,
        baseCurrency: baseCurrency,
      );
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'LoadCurrenciesUseCase.execute failed',
        extra: {'companyId': companyId},
      );
      rethrow;
    }
  }
}
