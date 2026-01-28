import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/exceptions/invoice_exceptions.dart';
import '../models/cash_location_model.dart';

/// Product remote data source for sales invoice
class ProductRemoteDataSource {
  final SupabaseClient _client;

  ProductRemoteDataSource(this._client);

  /// Get currency data using RPC
  /// Uses get_base_currency RPC which returns base currency and company currencies with exchange rates
  Future<Map<String, dynamic>> getCurrencyData({
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_base_currency',
        params: {
          'p_company_id': companyId,
        },
      );

      final baseCurrency = response['base_currency'] as Map<String, dynamic>?;
      if (baseCurrency == null) {
        throw InvoiceDataException(
          'Base currency not found',
          originalError: null,
        );
      }

      final companyCurrencies = response['company_currencies'] as List<dynamic>? ?? [];

      return {
        'base_currency': {
          'currency_id': baseCurrency['currency_id'],
          'currency_code': baseCurrency['currency_code'],
          'currency_name': baseCurrency['currency_name'],
          'symbol': baseCurrency['symbol'],
          'flag_emoji': baseCurrency['flag_emoji'] ?? '🏳️',
          'exchange_rate_to_base': 1.0,
        },
        'company_currencies': companyCurrencies.map((cc) {
          final currency = cc as Map<String, dynamic>;
          return {
            'currency_id': currency['currency_id'],
            'currency_code': currency['currency_code'],
            'currency_name': currency['currency_name'],
            'symbol': currency['symbol'],
            'flag_emoji': currency['flag_emoji'] ?? '🏳️',
            'exchange_rate_to_base': currency['exchange_rate_to_base'] ?? 1.0,
          };
        }).toList(),
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
