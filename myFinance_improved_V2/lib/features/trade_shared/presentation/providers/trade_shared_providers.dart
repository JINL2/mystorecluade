import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/datasources/trade_remote_datasource.dart';
import '../../data/models/master_data_model.dart';
import '../../domain/entities/incoterm.dart';

/// Supabase client provider
final supabaseClientProvider = Provider<SupabaseClient>((ref) {
  return Supabase.instance.client;
});

/// Trade remote datasource provider
final tradeRemoteDatasourceProvider = Provider<TradeRemoteDatasource>((ref) {
  final supabase = ref.watch(supabaseClientProvider);
  return TradeRemoteDatasourceImpl(supabase);
});

/// Master data state
class MasterDataState {
  final List<Incoterm> incoterms;
  final List<PaymentTerm> paymentTerms;
  final List<LCType> lcTypes;
  final List<TradeDocumentType> documentTypes;
  final List<ShippingMethod> shippingMethods;
  final List<FreightTerm> freightTerms;
  final bool isLoading;
  final String? error;

  const MasterDataState({
    this.incoterms = const [],
    this.paymentTerms = const [],
    this.lcTypes = const [],
    this.documentTypes = const [],
    this.shippingMethods = const [],
    this.freightTerms = const [],
    this.isLoading = false,
    this.error,
  });

  bool get isLoaded => incoterms.isNotEmpty;

  MasterDataState copyWith({
    List<Incoterm>? incoterms,
    List<PaymentTerm>? paymentTerms,
    List<LCType>? lcTypes,
    List<TradeDocumentType>? documentTypes,
    List<ShippingMethod>? shippingMethods,
    List<FreightTerm>? freightTerms,
    bool? isLoading,
    String? error,
  }) {
    return MasterDataState(
      incoterms: incoterms ?? this.incoterms,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      lcTypes: lcTypes ?? this.lcTypes,
      documentTypes: documentTypes ?? this.documentTypes,
      shippingMethods: shippingMethods ?? this.shippingMethods,
      freightTerms: freightTerms ?? this.freightTerms,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

/// Master data notifier
class MasterDataNotifier extends StateNotifier<MasterDataState> {
  final TradeRemoteDatasource _datasource;

  MasterDataNotifier(this._datasource) : super(const MasterDataState());

  Future<void> loadAllMasterData() async {
    if (state.isLoaded) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final response = await _datasource.getAllMasterData();
      state = state.copyWith(
        incoterms: response.incoterms.map((m) => m.toEntity()).toList(),
        paymentTerms: response.paymentTerms.map((m) => m.toEntity()).toList(),
        lcTypes: response.lcTypes.map((m) => m.toEntity()).toList(),
        documentTypes: response.documentTypes.map((m) => m.toEntity()).toList(),
        shippingMethods: response.shippingMethods.map((m) => m.toEntity()).toList(),
        freightTerms: response.freightTerms.map((m) => m.toEntity()).toList(),
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  void clear() {
    state = const MasterDataState();
  }
}

/// Master data provider
final masterDataProvider =
    StateNotifierProvider<MasterDataNotifier, MasterDataState>((ref) {
  final datasource = ref.watch(tradeRemoteDatasourceProvider);
  return MasterDataNotifier(datasource);
});

// ============================================================
// Exchange Rate Providers for Trade Documents
// ============================================================

/// Exchange rate data for a company
class TradeExchangeRateData {
  final String baseCurrencyId;
  final String baseCurrencyCode;
  final String baseCurrencySymbol;
  final Map<String, double> rates; // currency_code -> rate

  const TradeExchangeRateData({
    required this.baseCurrencyId,
    required this.baseCurrencyCode,
    required this.baseCurrencySymbol,
    required this.rates,
  });

  /// Convert amount from source currency to base currency
  double? toBaseCurrency(double amount, String fromCurrencyCode) {
    if (fromCurrencyCode == baseCurrencyCode) return amount;
    final rate = rates[fromCurrencyCode];
    if (rate == null) return null;
    return amount * rate;
  }

  /// Convert amount from base currency to target currency
  double? fromBaseCurrency(double amount, String toCurrencyCode) {
    if (toCurrencyCode == baseCurrencyCode) return amount;
    final rate = rates[toCurrencyCode];
    if (rate == null || rate == 0) return null;
    return amount / rate;
  }

  /// Get exchange rate for a currency
  double? getRate(String currencyCode) {
    if (currencyCode == baseCurrencyCode) return 1.0;
    return rates[currencyCode];
  }
}

/// Fetch exchange rates for trade documents
final tradeExchangeRateProvider =
    FutureProvider.family<TradeExchangeRateData?, String>((ref, companyId) async {
  if (companyId.isEmpty) return null;

  final supabase = ref.watch(supabaseClientProvider);

  try {
    final response = await supabase.rpc<Map<String, dynamic>?>(
      'get_exchange_rate_v3',
      params: {'p_company_id': companyId},
    );

    if (response == null) return null;

    final baseCurrency = response['base_currency'] as Map<String, dynamic>?;
    if (baseCurrency == null) return null;

    final exchangeRates = response['exchange_rates'] as List<dynamic>? ?? [];

    final rates = <String, double>{};
    for (final rate in exchangeRates) {
      final currencyCode = rate['currency_code'] as String?;
      final rateValue = rate['rate'];
      if (currencyCode != null && rateValue != null) {
        rates[currencyCode] = (rateValue is int) ? rateValue.toDouble() : rateValue as double;
      }
    }

    return TradeExchangeRateData(
      baseCurrencyId: baseCurrency['currency_id'] as String? ?? '',
      baseCurrencyCode: baseCurrency['currency_code'] as String? ?? 'VND',
      baseCurrencySymbol: baseCurrency['symbol'] as String? ?? '₫',
      rates: rates,
    );
  } catch (e) {
    return null;
  }
});
