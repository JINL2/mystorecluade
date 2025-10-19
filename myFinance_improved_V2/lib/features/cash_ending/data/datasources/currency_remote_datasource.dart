// lib/features/cash_ending/data/datasources/currency_remote_datasource.dart

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

  /// Get company currencies
  ///
  /// Returns list of currency_id and company_currency_id pairs
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getCompanyCurrencies(
    String companyId,
  ) async {
    final response = await _client
        .from('company_currency')
        .select('currency_id, company_currency_id')
        .eq('company_id', companyId)
        .eq('is_deleted', false);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get currency types (master data)
  ///
  /// [currencyIds] - Optional filter for specific currency IDs
  ///
  /// Returns list of currency type records
  /// Throws exception on error
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

  /// Get all denominations for company
  ///
  /// Returns list of denomination records grouped by currency
  /// Throws exception on error
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
