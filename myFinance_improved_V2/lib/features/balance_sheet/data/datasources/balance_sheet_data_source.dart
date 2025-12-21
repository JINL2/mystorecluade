import 'package:supabase_flutter/supabase_flutter.dart';

/// Balance sheet data source
class BalanceSheetDataSource {
  final SupabaseClient _client;

  BalanceSheetDataSource(this._client);

  /// Get balance sheet raw data from RPC
  Future<Map<String, dynamic>> getBalanceSheetRaw({
    required String companyId,
    required String startDate,
    required String endDate,
    String? storeId,
  }) async {
    final response = await _client.rpc(
      'get_balance_sheet',
      params: {
        'p_company_id': companyId,
        'p_start_date': startDate,
        'p_end_date': endDate,
        'p_store_id': storeId,
      },
    );

    if (response != null && response['success'] == true) {
      return response as Map<String, dynamic>;
    } else {
      throw Exception(response?['message'] ?? 'Failed to generate balance sheet');
    }
  }

  /// Get income statement raw data from RPC
  Future<List<dynamic>> getIncomeStatementRaw({
    required String companyId,
    required String startDate,
    required String endDate,
    String? storeId,
  }) async {
    dynamic response;

    // Try v2 first, fallback to v1
    try {
      response = await _client.rpc(
        'get_income_statement_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_start_date': startDate,
          'p_end_date': endDate,
        },
      );
    } catch (rpcError) {
      try {
        response = await _client.rpc(
          'get_income_statement',
          params: {
            'p_company_id': companyId,
            'p_store_id': storeId,
            'p_start_date': startDate,
            'p_end_date': endDate,
          },
        );
      } catch (fallbackError) {
        throw Exception('Income statement function not available on server');
      }
    }

    // Parse response
    if (response == null) {
      throw Exception('No response from server');
    }

    if (response is List && response.isNotEmpty) {
      return response;
    } else if (response is List && response.isEmpty) {
      throw Exception('No income statement data found for the selected period and store');
    } else if (response is Map) {
      final map = response as Map<String, dynamic>;
      if (map.containsKey('error')) {
        throw Exception(map['error']);
      } else if (map.containsKey('message')) {
        throw Exception(map['message']);
      } else if (map.containsKey('data') && map['data'] is List) {
        final data = map['data'] as List;
        if (data.isNotEmpty) {
          return data;
        } else {
          throw Exception('No income statement data found for the selected period and store');
        }
      } else {
        throw Exception('Unexpected response format from server');
      }
    } else {
      throw Exception('Unexpected response format from server');
    }
  }

  /// Get stores for a company
  Future<List<Map<String, dynamic>>> getStoresRaw(String companyId) async {
    final response = await _client
        .from('stores')
        .select('store_id, store_name, store_code')
        .eq('company_id', companyId)
        .order('store_name');

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get currency for a company
  Future<Map<String, dynamic>> getCurrencyRaw(String companyId) async {
    // Get company's base_currency_id
    final companyResponse = await _client
        .from('companies')
        .select('base_currency_id')
        .eq('company_id', companyId)
        .single();

    final baseCurrencyId = companyResponse['base_currency_id'] as String?;

    if (baseCurrencyId == null) {
      // Return default currency
      return {'currency_code': 'KRW', 'symbol': '₩'};
    }

    // Get currency details
    final currencyResponse = await _client
        .from('currency_types')
        .select('currency_code, symbol')
        .eq('currency_id', baseCurrencyId)
        .single();

    return {
      'currency_code': (currencyResponse['currency_code'] as String?) ?? 'KRW',
      'symbol': (currencyResponse['symbol'] as String?) ?? '₩',
    };
  }
}
