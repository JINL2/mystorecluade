import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/invoice_exceptions.dart';
import '../models/cash_location_model.dart';

/// Product remote data source for sales invoice
class ProductRemoteDataSource {
  final SupabaseClient _client;

  ProductRemoteDataSource(this._client);

  /// Get currency data using table queries
  Future<Map<String, dynamic>> getCurrencyData({
    required String companyId,
  }) async {
    try {
      // 1. Get company's base currency ID
      final companyResult = await _client
          .from('companies')
          .select('base_currency_id')
          .eq('company_id', companyId)
          .maybeSingle();

      if (companyResult == null) {
        throw InvoiceDataException(
          'Company not found',
          originalError: null,
        );
      }

      final baseCurrencyId = companyResult['base_currency_id'] as String?;
      if (baseCurrencyId == null || baseCurrencyId.isEmpty) {
        throw InvoiceDataException(
          'Base currency not configured for this company',
          originalError: null,
        );
      }

      // 2. Get base currency details from currency_types
      final baseCurrencyResult = await _client
          .from('currency_types')
          .select('currency_id, currency_code, currency_name, symbol, flag_emoji')
          .eq('currency_id', baseCurrencyId)
          .maybeSingle();

      if (baseCurrencyResult == null) {
        throw InvoiceDataException(
          'Base currency type not found',
          originalError: null,
        );
      }

      // 3. Get company currencies (non-deleted)
      final companyCurrencies = await _client
          .from('company_currency')
          .select('currency_id')
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      List<Map<String, dynamic>> companyCurrencyList = [];

      if (companyCurrencies.isNotEmpty) {
        final currencyIds = (companyCurrencies as List<dynamic>)
            .map((cc) => (cc as Map<String, dynamic>)['currency_id'] as String)
            .toList();

        // 4. Get currency details for company currencies
        final currencyTypes = await _client
            .from('currency_types')
            .select('currency_id, currency_code, currency_name, symbol, flag_emoji')
            .inFilter('currency_id', currencyIds);

        companyCurrencyList = (currencyTypes as List<dynamic>)
            .map((ct) {
              final currency = ct as Map<String, dynamic>;
              return {
                'currency_id': currency['currency_id'],
                'currency_code': currency['currency_code'],
                'currency_name': currency['currency_name'],
                'symbol': currency['symbol'],
                'flag_emoji': currency['flag_emoji'] ?? '🏳️',
                'exchange_rate_to_base': currency['currency_id'] == baseCurrencyId ? 1.0 : null,
              };
            })
            .toList();
      }

      return {
        'base_currency': {
          'currency_id': baseCurrencyResult['currency_id'],
          'currency_code': baseCurrencyResult['currency_code'],
          'currency_name': baseCurrencyResult['currency_name'],
          'symbol': baseCurrencyResult['symbol'],
          'flag_emoji': baseCurrencyResult['flag_emoji'] ?? '🏳️',
          'exchange_rate_to_base': 1.0,
        },
        'company_currencies': companyCurrencyList,
      };
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load currency data: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse currency data: $e',
        originalError: e,
      );
    }
  }

  /// Get cash locations using RPC
  Future<List<CashLocationModel>> getCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_location_type': null,
        },
      );

      return (response)
          .map((e) => CashLocationModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load cash locations: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse cash location data: $e',
        originalError: e,
      );
    }
  }

  /// Get exchange rates
  /// Uses get_exchange_rate_v3 which supports store-based currency sorting
  Future<Map<String, dynamic>?> getExchangeRates({
    required String companyId,
    String? storeId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>?>(
        'get_exchange_rate_v3',
        params: {
          'p_company_id': companyId,
          if (storeId != null) 'p_store_id': storeId,
        },
      );

      return response;
    } on PostgrestException catch (e) {
      throw InvoiceNetworkException(
        'Failed to load exchange rates: ${e.message}',
        code: e.code,
        originalError: e,
      );
    } catch (e) {
      if (e is InvoiceException) rethrow;
      throw InvoiceDataException(
        'Failed to parse exchange rate data: $e',
        originalError: e,
      );
    }
  }
}
