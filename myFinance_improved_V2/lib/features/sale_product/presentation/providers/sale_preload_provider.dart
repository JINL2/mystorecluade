import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../app/providers/app_state_provider.dart';
import '../../data/datasources/exchange_rate_datasource.dart';
import '../../data/datasources/payment_remote_datasource.dart';
import '../../domain/entities/cash_location.dart';
import '../../domain/entities/exchange_rate_data.dart';
import '../helpers/exchange_rate_helper.dart';

/// State for preloaded sale data (exchange rates + cash locations)
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
  bool get hasData =>
      exchangeRateData != null || cashLocations.isNotEmpty;
}

/// Provider for ExchangeRateDataSource
final _exchangeRateDataSourceProvider =
    Provider<ExchangeRateDataSource>((ref) {
  return ExchangeRateDataSource(Supabase.instance.client);
});

/// Provider for PaymentRemoteDataSource
final _paymentRemoteDataSourceProvider =
    Provider<PaymentRemoteDataSource>((ref) {
  return PaymentRemoteDataSource(Supabase.instance.client);
});

/// Provider to preload sale data (exchange rates + cash locations)
final salePreloadProvider =
    StateNotifierProvider<SalePreloadNotifier, SalePreloadState>((ref) {
  final exchangeRateDataSource = ref.watch(_exchangeRateDataSourceProvider);
  final paymentDataSource = ref.watch(_paymentRemoteDataSourceProvider);
  return SalePreloadNotifier(ref, exchangeRateDataSource, paymentDataSource);
});

/// Notifier for preloaded sale data
class SalePreloadNotifier extends StateNotifier<SalePreloadState> {
  final Ref ref;
  final ExchangeRateDataSource _exchangeRateDataSource;
  final PaymentRemoteDataSource _paymentDataSource;

  SalePreloadNotifier(
    this.ref,
    this._exchangeRateDataSource,
    this._paymentDataSource,
  ) : super(const SalePreloadState());

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

      // Load exchange rates and cash locations in parallel
      final results = await Future.wait([
        _loadExchangeRates(companyId),
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

  /// Load exchange rates
  Future<ExchangeRateData?> _loadExchangeRates(String companyId) async {
    try {
      final response = await _exchangeRateDataSource.getExchangeRates(
        companyId: companyId,
      );

      if (response.error != null) {
        return null;
      }

      return ExchangeRateHelper.fromJson(response.toJson());
    } catch (e) {
      // Return null on error - exchange rates are optional
      return null;
    }
  }

  /// Load cash locations
  Future<List<CashLocation>> _loadCashLocations(
    String companyId,
    String storeId,
  ) async {
    try {
      if (storeId.isEmpty) {
        return [];
      }

      final models = await _paymentDataSource.getCashLocations(
        companyId: companyId,
        storeId: storeId,
      );

      return models.map((model) => model.toEntity()).toList();
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
