import 'package:supabase_flutter/supabase_flutter.dart';

/// Base currency information
class BaseCurrency {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;

  const BaseCurrency({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
  });

  factory BaseCurrency.fromJson(Map<String, dynamic> json) {
    return BaseCurrency(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'currency_id': currencyId,
        'currency_code': currencyCode,
        'currency_name': currencyName,
        'symbol': symbol,
      };
}

/// Exchange rate for a currency
class ExchangeRateItem {
  final String currencyId;
  final String currencyCode;
  final String currencyName;
  final String symbol;
  final double rate;

  const ExchangeRateItem({
    required this.currencyId,
    required this.currencyCode,
    required this.currencyName,
    required this.symbol,
    required this.rate,
  });

  factory ExchangeRateItem.fromJson(Map<String, dynamic> json) {
    // Support both 'exchange_rate' (RPC response) and 'rate' (internal/toJson)
    final rateValue = json['exchange_rate'] ?? json['rate'];
    return ExchangeRateItem(
      currencyId: json['currency_id']?.toString() ?? '',
      currencyCode: json['currency_code']?.toString() ?? '',
      currencyName: json['currency_name']?.toString() ?? '',
      symbol: json['symbol']?.toString() ?? '',
      rate: (rateValue as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'currency_id': currencyId,
        'currency_code': currencyCode,
        'currency_name': currencyName,
        'symbol': symbol,
        'rate': rate,
      };
}

/// Exchange rate response from get_exchange_rate_v3 RPC
class ExchangeRateResponse {
  final BaseCurrency? baseCurrency;
  final List<ExchangeRateItem> exchangeRates;
  final String? error;

  const ExchangeRateResponse({
    this.baseCurrency,
    required this.exchangeRates,
    this.error,
  });

  factory ExchangeRateResponse.empty() => const ExchangeRateResponse(
        baseCurrency: null,
        exchangeRates: [],
      );

  factory ExchangeRateResponse.fromJson(Map<String, dynamic> json) {
    // Check for error
    if (json.containsKey('error') && json['error'] != null) {
      return ExchangeRateResponse(
        baseCurrency: null,
        exchangeRates: [],
        error: json['error']?.toString(),
      );
    }

    return ExchangeRateResponse(
      baseCurrency: json['base_currency'] != null
          ? BaseCurrency.fromJson(json['base_currency'] as Map<String, dynamic>)
          : null,
      exchangeRates: (json['exchange_rates'] as List<dynamic>? ?? [])
          .map((e) => ExchangeRateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'base_currency': baseCurrency?.toJson(),
        'exchange_rates': exchangeRates.map((e) => e.toJson()).toList(),
        if (error != null) 'error': error,
      };
}

/// Remote data source for exchange rates
class ExchangeRateDataSource {
  final SupabaseClient _client;

  ExchangeRateDataSource(this._client);

  /// Get exchange rates from RPC
  /// v3 supports store-based currency sorting by foreign currency balance
  Future<ExchangeRateResponse> getExchangeRates({
    required String companyId,
    String? storeId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_exchange_rate_v3',
      params: {
        'p_company_id': companyId,
        if (storeId != null) 'p_store_id': storeId,
      },
    ).single();

    return ExchangeRateResponse.fromJson(response);
  }
}
