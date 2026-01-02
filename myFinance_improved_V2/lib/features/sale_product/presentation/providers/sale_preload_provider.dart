import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../di/sale_product_providers.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/exchange_rate_data.dart';

part 'sale_preload_provider.freezed.dart';
part 'sale_preload_provider.g.dart';

/// State for preloaded sale data (exchange rates + cash locations)
@freezed
class SalePreloadData with _$SalePreloadData {
  const factory SalePreloadData({
    ExchangeRateData? exchangeRateData,
    @Default([]) List<CashLocation> cashLocations,
  }) = _SalePreloadData;

  const SalePreloadData._();

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
///
/// Uses @riverpod for automatic code generation and better type safety.
/// Returns AsyncValue<SalePreloadData> for loading/error states.
@riverpod
class SalePreloadNotifier extends _$SalePreloadNotifier {
  @override
  Future<SalePreloadData> build() async {
    final appState = ref.read(appStateProvider);
    final companyId = appState.companyChoosen;
    final storeId = appState.storeChoosen;

    if (companyId.isEmpty) {
      return const SalePreloadData();
    }

    // Load exchange rates and cash locations in parallel
    final results = await Future.wait([
      _loadExchangeRates(companyId, storeId),
      _loadCashLocations(companyId, storeId),
    ]);

    return SalePreloadData(
      exchangeRateData: results[0] as ExchangeRateData?,
      cashLocations: (results[1] as List<CashLocation>?) ?? <CashLocation>[],
    );
  }

  /// Reload all data (for manual refresh)
  Future<void> loadAll() async {
    ref.invalidateSelf();
    await future;
  }

  /// Load exchange rates from DB only (real-time rates loaded on-demand in PaymentMethodPage)
  Future<ExchangeRateData?> _loadExchangeRates(
    String companyId,
    String storeId,
  ) async {
    try {
      final repository = ref.read(exchangeRateRepositoryProvider);
      return await repository.getExchangeRates(
        companyId: companyId,
        storeId: storeId.isNotEmpty ? storeId : null,
      );
    } catch (e) {
      return null;
    }
  }

  /// Load cash locations using repository
  Future<List<CashLocation>> _loadCashLocations(
    String companyId,
    String storeId,
  ) async {
    try {
      if (storeId.isEmpty) return [];

      final repository = ref.read(paymentRepositoryProvider);
      return await repository.getCashLocations(
        companyId: companyId,
        storeId: storeId,
      );
    } catch (e) {
      return [];
    }
  }

  /// Refresh all data
  Future<void> refresh() async {
    await loadAll();
  }
}
