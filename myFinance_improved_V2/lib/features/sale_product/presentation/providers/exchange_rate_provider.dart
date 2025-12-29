import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/exchange_rate_data.dart';

part 'exchange_rate_provider.g.dart';

/// Provider to fetch and manage exchange rates
///
/// Uses @riverpod for automatic code generation and better type safety.
/// Returns AsyncValue<ExchangeRateData?> for loading/error states.
@riverpod
class SaleExchangeRateNotifier extends _$SaleExchangeRateNotifier {
  @override
  Future<ExchangeRateData?> build() async {
    // Initial load - returns null if not loaded yet
    return null;
  }

  /// Load exchange rates from server
  Future<void> loadExchangeRates() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      final appState = ref.read(appStateProvider);
      final companyId = appState.companyChoosen;

      if (companyId.isEmpty) {
        throw Exception('Please select a company first');
      }

      final repository = ref.read(exchangeRateRepositoryProvider);
      final exchangeRateData = await repository.getExchangeRates(
        companyId: companyId,
      );

      if (exchangeRateData == null) {
        throw Exception('Failed to load exchange rates');
      }

      return exchangeRateData;
    });
  }

  /// Refresh exchange rates
  Future<void> refresh() async {
    await loadExchangeRates();
  }
}

/// Extension on AsyncValue<ExchangeRateData?> for convenience methods
extension ExchangeRateAsyncValueExtension on AsyncValue<ExchangeRateData?> {
  /// Get exchange rate for a specific currency code
  double? getRateForCurrency(String currencyCode) {
    return valueOrNull?.findRate(currencyCode);
  }

  /// Get base currency symbol
  String get baseCurrencySymbol =>
      valueOrNull?.baseCurrency.symbol ?? '₫';

  /// Get base currency code
  String get baseCurrencyCode =>
      valueOrNull?.baseCurrency.currencyCode ?? 'VND';
}
