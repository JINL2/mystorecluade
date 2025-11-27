// lib/features/cash_ending/data/datasources/currency_remote_datasource.dart

import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Currencies and Denominations
///
/// This is the ONLY place where Supabase client is used for currency operations.
/// Handles all database queries for currencies and denominations.
/// Returns raw JSON data (Map<String, dynamic>).
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
  /// Returns list of currency data with exchange rates
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getCompanyCurrenciesWithExchangeRates({
    required String companyId,
    DateTime? rateDate,
  }) async {
    if (kDebugMode) {
      debugPrint('[CurrencyDataSource] Loading currencies for company');
    }

    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_company_currencies_with_exchange_rates',
        params: {
          'p_company_id': companyId,
          'p_rate_date': rateDate?.toIso8601String().split('T')[0] ??
              DateTime.now().toIso8601String().split('T')[0],
        },
      );

      final result = List<Map<String, dynamic>>.from(response);

      if (kDebugMode) {
        debugPrint('[CurrencyDataSource] Loaded ${result.length} currencies');
      }

      return result;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('[CurrencyDataSource] Error loading currencies: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Get company currencies (LEGACY)
  ///
  /// Returns list of currency_id and company_currency_id pairs
  /// Ordered by created_at to ensure consistent default currency (first added)
  /// Throws exception on error
  @Deprecated('Use getCompanyCurrenciesWithExchangeRates instead')
  Future<List<Map<String, dynamic>>> getCompanyCurrencies(
    String companyId,
  ) async {
    final response = await _client
        .from('company_currency')
        .select('currency_id, company_currency_id, created_at')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('created_at', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get currency types (master data) (LEGACY)
  ///
  /// [currencyIds] - Optional filter for specific currency IDs
  ///
  /// Returns list of currency type records
  /// Throws exception on error
  @Deprecated('Use getCompanyCurrenciesWithExchangeRates instead')
  Future<List<Map<String, dynamic>>> getCurrencyTypes({
    List<String>? currencyIds,
  }) async {
    var query = _client
        .from('currency_types')
        .select('currency_id, currency_code, currency_name, symbol');

    if (currencyIds != null && currencyIds.isNotEmpty) {
      query = query.inFilter('currency_id', currencyIds);
    }

    final response = await query;

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get denominations for company and currency
  ///
  /// Returns list of denomination records ordered by value descending
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getDenominationsByCurrency({
    required String companyId,
    required String currencyId,
  }) async {
    final response = await _client
        .from('currency_denominations')
        .select('*')
        .eq('company_id', companyId)
        .eq('currency_id', currencyId)
        .eq('is_deleted', false)
        .order('value', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get all denominations for company (LEGACY)
  ///
  /// Returns list of denomination records grouped by currency
  /// Throws exception on error
  @Deprecated('Use getCompanyCurrenciesWithExchangeRates instead')
  Future<List<Map<String, dynamic>>> getAllDenominations(
    String companyId,
  ) async {
    final response = await _client
        .from('currency_denominations')
        .select('*')
        .eq('company_id', companyId)
        .eq('is_deleted', false)
        .order('value', ascending: false);

    return List<Map<String, dynamic>>.from(response);
  }
}
