// lib/features/cash_ending/data/datasources/currency_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Currencies
///
/// This is the ONLY place where Supabase client is used for currency operations.
/// Handles all database queries for currencies.
/// Returns raw JSON data (Map<String, dynamic>).
///
/// NOTE: Denominations are included in get_company_currencies_with_exchange_rates
/// RPC response as JSONB. No separate query needed.
class CurrencyRemoteDataSource {
  final SupabaseClient _client;

  CurrencyRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Get company currencies with exchange rates (RPC)
  ///
  /// Business Logic:
  /// - Fetch all currencies for a company via RPC
  /// - Includes base currency identification
  /// - Includes exchange rates to base currency
  /// - Includes denominations as JSONB
  ///
  /// [companyId] - Company ID
  /// [rateDate] - Optional date for historical exchange rates
  ///
  /// Returns list of currency data with exchange rates and denominations
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getCompanyCurrenciesWithExchangeRates({
    required String companyId,
    DateTime? rateDate,
  }) async {
    final response = await _client.rpc<List<dynamic>>(
      'get_company_currencies_with_exchange_rates',
      params: {
        'p_company_id': companyId,
        'p_rate_date': rateDate?.toIso8601String().split('T')[0] ??
            DateTime.now().toIso8601String().split('T')[0],
      },
    );

    return List<Map<String, dynamic>>.from(response);
  }
}
