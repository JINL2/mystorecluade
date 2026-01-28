import '../../data/mappers/currency_info_mapper.dart';
import '../entities/currency.dart';

abstract class CurrencyRepository {
  /// Get available currency types for selection (with is_already_added flag)
  Future<List<CurrencyType>> getAvailableCurrencyTypes(String companyId);

  /// Get currencies configured for a specific company
  Future<List<Currency>> getCompanyCurrencies(String companyId);

  /// Add a currency to a company's configuration
  Future<Currency> addCompanyCurrency(String companyId, String currencyId);

  /// Remove a currency from a company's configuration
  Future<void> removeCompanyCurrency(String companyId, String currencyId);

  /// Get a specific currency by ID for a company
  Future<Currency?> getCompanyCurrency(String companyId, String currencyId);

  /// Search available currency types
  Future<List<CurrencyType>> searchCurrencyTypes(String companyId, String query);

  /// Stream of company currencies for real-time updates
  Stream<List<Currency>> watchCompanyCurrencies(String companyId);

  /// Check if a currency has denominations
  Future<bool> hasDenominations(String companyId, String currencyId);

  /// Check if the given currency is the base currency for the company
  Future<bool> isBaseCurrency(String companyId, String currencyId);

  /// Get full currency info including base currency details
  Future<CurrencyInfoResponse> getCurrencyInfo(String companyId);

  /// Get current exchange rate for a currency (relative to base currency)
  Future<ExchangeRateResult> getCurrentExchangeRate(
    String companyId,
    String currencyId,
  );

  /// Insert a new exchange rate for a currency
  Future<ExchangeRateResult> insertExchangeRate({
    required String companyId,
    required String currencyId,
    required double rate,
    required String userId,
    DateTime? rateDate,
  });
}

/// Result of exchange rate operations
class ExchangeRateResult {
  const ExchangeRateResult({
    required this.success,
    this.operation,
    this.currentRate,
    this.rateId,
    this.rate,
    this.rateDate,
    this.baseCurrencyId,
    this.baseCurrencyCode,
    this.errorCode,
    this.error,
  });

  final bool success;
  final String? operation; // 'read' or 'insert'
  final double? currentRate;
  final String? rateId;
  final double? rate;
  final DateTime? rateDate;
  final String? baseCurrencyId;
  final String? baseCurrencyCode;
  final String? errorCode;
  final String? error;

  factory ExchangeRateResult.fromRpcResponse(Map<String, dynamic> response) {
    return ExchangeRateResult(
      success: response['success'] as bool? ?? false,
      operation: response['operation'] as String?,
      currentRate: (response['current_rate'] as num?)?.toDouble(),
      rateId: response['rate_id'] as String?,
      rate: (response['rate'] as num?)?.toDouble(),
      rateDate: response['rate_date'] != null
          ? DateTime.tryParse(response['rate_date'].toString())
          : null,
      baseCurrencyId: response['base_currency_id'] as String?,
      baseCurrencyCode: response['base_currency_code'] as String?,
      errorCode: response['error_code'] as String?,
      error: response['error'] as String?,
    );
  }
}