import 'package:supabase_flutter/supabase_flutter.dart';

/// Balance sheet data source
class BalanceSheetDataSource {
  final SupabaseClient _client;

  BalanceSheetDataSource(this._client);

  /// Get balance sheet raw data from RPC (v2 - no date filter, store filter only)
  /// Uses balance_sheet_logs table for O(1) performance
  Future<Map<String, dynamic>> getBalanceSheetRaw({
    required String companyId,
    String? storeId,
  }) async {
    final response = await _client.rpc(
      'get_balance_sheet_v2',
      params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
      },
    );

    if (response != null && response['success'] == true) {
      return response as Map<String, dynamic>;
    } else {
      final error = response?['error'] as Map<String, dynamic>?;
      throw Exception(error?['message'] ?? response?['message'] ?? 'Failed to generate balance sheet');
    }
  }

  /// Get income statement raw data from RPC (v3 - with timezone support)
  /// Uses balance_sheet_logs table for O(1) performance
  ///
  /// Parameters:
  /// - companyId: Company UUID
  /// - startTime: Start timestamp in user's local time (YYYY-MM-DD HH:MM:SS)
  /// - endTime: End timestamp in user's local time (YYYY-MM-DD HH:MM:SS)
  /// - timezone: IANA timezone string (e.g., 'Asia/Ho_Chi_Minh', 'Asia/Seoul')
  /// - storeId: Optional store UUID (null = all stores)
  Future<List<dynamic>> getIncomeStatementRaw({
    required String companyId,
    required String startTime,
    required String endTime,
    required String timezone,
    String? storeId,
  }) async {
    final response = await _client.rpc(
      'get_income_statement_v3',
      params: {
        'p_company_id': companyId,
        'p_start_time': startTime,
        'p_end_time': endTime,
        'p_timezone': timezone,
        'p_store_id': storeId,
      },
    );

    // Parse response - v3 always returns 13 sections (even with 0 values)
    if (response == null) {
      throw Exception('No response from server');
    }

    if (response is List) {
      return response;
    } else if (response is Map) {
      final map = response as Map<String, dynamic>;
      if (map.containsKey('error')) {
        throw Exception(map['error']);
      } else if (map.containsKey('message')) {
        throw Exception(map['message']);
      }
      throw Exception('Unexpected response format from server');
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
