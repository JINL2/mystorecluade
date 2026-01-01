// Exchange Rate Provider
//
// Autonomous provider for exchange rate data fetching.
// Used by ExchangeRateCalculator selector.
library;

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'exchange_rate_provider.g.dart';

/// Params for exchange rates calculator query
class CalculatorExchangeRateParams {
  final String companyId;
  final String? storeId;

  const CalculatorExchangeRateParams({
    required this.companyId,
    this.storeId,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalculatorExchangeRateParams &&
          runtimeType == other.runtimeType &&
          companyId == other.companyId &&
          storeId == other.storeId;

  @override
  int get hashCode => companyId.hashCode ^ (storeId?.hashCode ?? 0);
}

/// Fetch exchange rates for currency conversion
/// Uses get_exchange_rate_v3 RPC which supports store-based currency sorting
@riverpod
Future<Map<String, dynamic>> calculatorExchangeRateData(
  Ref ref,
  CalculatorExchangeRateParams params,
) async {
  if (params.companyId.isEmpty) {
    throw Exception('Company ID is required');
  }

  final supabase = Supabase.instance.client;

  final response = await supabase.rpc<Map<String, dynamic>?>(
    'get_exchange_rate_v3',
    params: {
      'p_company_id': params.companyId,
      if (params.storeId != null && params.storeId!.isNotEmpty)
        'p_store_id': params.storeId,
    },
  );

  if (response == null) {
    return {
      'base_currency': null,
      'exchange_rates': <Map<String, dynamic>>[],
    };
  }

  return Map<String, dynamic>.from(response);
}
