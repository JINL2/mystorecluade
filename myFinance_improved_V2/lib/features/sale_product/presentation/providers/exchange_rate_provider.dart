import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/exchange_rate_data.dart';

/// State for exchange rate data
class ExchangeRateState {
  final ExchangeRateData? exchangeRateData;
  final bool isLoading;
  final String? errorMessage;

  const ExchangeRateState({
    this.exchangeRateData,
    this.isLoading = false,
    this.errorMessage,
  });

  ExchangeRateState copyWith({
    ExchangeRateData? exchangeRateData,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ExchangeRateState(
      exchangeRateData: exchangeRateData ?? this.exchangeRateData,
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
}

/// Provider to fetch and manage exchange rates
final saleExchangeRateProvider =
    StateNotifierProvider<SaleExchangeRateNotifier, ExchangeRateState>((ref) {
  return SaleExchangeRateNotifier(ref);
});

/// Notifier for exchange rate state
class SaleExchangeRateNotifier extends StateNotifier<ExchangeRateState> {
  final Ref ref;

  SaleExchangeRateNotifier(this.ref) : super(const ExchangeRateState());

  /// Load exchange rates from server
  Future<void> loadExchangeRates() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Please select a company first',
        );
        return;
      }

      final repository = ref.read(exchangeRateRepositoryProvider);
      final exchangeRateData = await repository.getExchangeRates(
        companyId: companyId,
      );

      if (exchangeRateData == null) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: 'Failed to load exchange rates',
        );
        return;
      }

      state = state.copyWith(
        exchangeRateData: exchangeRateData,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Error loading exchange rates: $e',
      );
    }
  }

  /// Refresh exchange rates
  Future<void> refresh() async {
    await loadExchangeRates();
  }
}
