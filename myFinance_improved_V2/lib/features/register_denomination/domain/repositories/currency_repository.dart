import '../entities/currency.dart';

abstract class CurrencyRepository {
  /// Get available currency types for selection
  Future<List<CurrencyType>> getAvailableCurrencyTypes();

  /// Get currencies configured for a specific company
  Future<List<Currency>> getCompanyCurrencies(String companyId);

  /// Add a currency to a company's configuration
  Future<Currency> addCompanyCurrency(String companyId, String currencyId);

  /// Remove a currency from a company's configuration
  Future<void> removeCompanyCurrency(String companyId, String currencyId);

  /// Get a specific currency by ID for a company
  Future<Currency?> getCompanyCurrency(String companyId, String currencyId);

  /// Update company currency settings
  Future<Currency> updateCompanyCurrency(String companyId, String currencyId, {
    bool? isActive,
  });

  /// Search available currency types
  Future<List<CurrencyType>> searchCurrencyTypes(String query);

  /// Stream of company currencies for real-time updates
  Stream<List<Currency>> watchCompanyCurrencies(String companyId);

  /// Check if a currency has denominations
  Future<bool> hasDenominations(String companyId, String currencyId);

  /// Check if the given currency is the base currency for the company
  Future<bool> isBaseCurrency(String companyId, String currencyId);
}