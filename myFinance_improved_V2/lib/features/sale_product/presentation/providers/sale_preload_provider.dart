import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../../register_denomination/data/services/exchange_rate_service.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/exchange_rate_data.dart';

/// State for preloaded sale data (exchange rates + cash locations)
/// NOTE: Consider using Freezed for consistency with SalesProductState
class SalePreloadState {
  final ExchangeRateData? exchangeRateData;
  final List<CashLocation> cashLocations;
  final bool isLoading;
  final String? errorMessage;

  const SalePreloadState({
    this.exchangeRateData,
    this.cashLocations = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  SalePreloadState copyWith({
    ExchangeRateData? exchangeRateData,
    List<CashLocation>? cashLocations,
    bool? isLoading,
    String? errorMessage,
  }) {
    return SalePreloadState(
      exchangeRateData: exchangeRateData ?? this.exchangeRateData,
      cashLocations: cashLocations ?? this.cashLocations,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  /// Get exchange rate for a specific currency code
  double? getRateForCurrency(String currencyCode) {
    return exchangeRateData?.findRate(currencyCode);
  }

  /// Get base currency symbol
  String get baseCurrencySymbol =>
      exchangeRateData?.baseCurrency.symbol ?? '₫';

  /// Get base currency code
  String get baseCurrencyCode =>
      exchangeRateData?.baseCurrency.currencyCode ?? 'VND';

  /// Check if data is loaded
  bool get hasData => exchangeRateData != null || cashLocations.isNotEmpty;
}

/// Provider to preload sale data (exchange rates + cash locations)
final salePreloadProvider =
    StateNotifierProvider<SalePreloadNotifier, SalePreloadState>((ref) {
  return SalePreloadNotifier(ref);
});

/// Notifier for preloaded sale data
class SalePreloadNotifier extends StateNotifier<SalePreloadState> {
  final Ref ref;

  SalePreloadNotifier(this.ref) : super(const SalePreloadState());

  /// Load all preload data (exchange rates + cash locations) in parallel
  Future<void> loadAll() async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;
      final storeId = appState.storeChoosen;

      if (companyId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please select a company first',
        );
        return;
      }

      // Load exchange rates and cash locations in parallel using repositories
      final results = await Future.wait([
        _loadExchangeRates(companyId, storeId),
        _loadCashLocations(companyId, storeId),
      ]);

      final exchangeRateData = results[0] as ExchangeRateData?;
      final cashLocations =
          (results[1] as List<CashLocation>?) ?? <CashLocation>[];

      state = state.copyWith(
        exchangeRateData: exchangeRateData,
        cashLocations: cashLocations,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading data: $e',
      );
    }
  }

  /// Load exchange rates using real-time API
  /// First gets currency list from DB (sorted by store balance), then fetches real-time rates
  Future<ExchangeRateData?> _loadExchangeRates(
    String companyId,
    String storeId,
  ) async {
    try {
      // 1. Get currency list from DB (sorted by store balance)
      final repository = ref.read(exchangeRateRepositoryProvider);
      final dbData = await repository.getExchangeRates(
        companyId: companyId,
        storeId: storeId.isNotEmpty ? storeId : null,
      );

      if (dbData == null) return null;

      // 2. Get real-time exchange rates from API
      final exchangeRateService = ExchangeRateService();
      final baseCurrency = dbData.baseCurrency.currencyCode;
      final targetCurrencies =
          dbData.rates.map((r) => r.currencyCode).toList();

      if (targetCurrencies.isEmpty) {
        return dbData;
      }

      final realTimeRates = await exchangeRateService.getMultipleExchangeRates(
        baseCurrency,
        targetCurrencies,
      );

      // 3. Build new rates with real-time data (keep DB order)
      final updatedRates = dbData.rates.map((rate) {
        final realTimeRate = realTimeRates[rate.currencyCode];
        return ExchangeRate(
          currencyCode: rate.currencyCode,
          symbol: rate.symbol,
          rate: realTimeRate ?? rate.rate, // fallback to DB rate
          name: rate.name,
        );
      }).toList();

      return ExchangeRateData(
        baseCurrency: dbData.baseCurrency,
        rates: updatedRates,
      );
    } catch (e) {
      // Return null on error - exchange rates are optional
      return null;
    }
  }

  /// Load cash locations using repository
  Future<List<CashLocation>> _loadCashLocations(
    String companyId,
    String storeId,
  ) async {
    try {
      if (storeId.isEmpty) {
        return [];
      }

      final repository = ref.read(paymentRepositoryProvider);
      return await repository.getCashLocations(
        companyId: companyId,
        storeId: storeId,
      );
    } catch (e) {
      // Return empty list on error - will be loaded again in payment page
      return [];
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadAll();
  }
}
