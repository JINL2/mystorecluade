import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/pnl_summary_dto.dart';
import '../models/bs_summary_dto.dart';

/// Balance sheet data source
class BalanceSheetDataSource {
  final SupabaseClient _client;

  BalanceSheetDataSource(this._client);

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // NEW RPC METHODS (get_pnl, get_pnl_detail, get_bs, get_bs_detail)
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

  /// Get P&L summary from get_pnl() RPC
  Future<PnlSummaryModel> getPnlSummary({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
    DateTime? prevStartDate,
    DateTime? prevEndDate,
  }) async {
    final response = await _client.rpc('get_pnl', params: {
      'p_company_id': companyId,
      'p_start_date': _formatDate(startDate),
      'p_end_date': _formatDate(endDate),
      if (storeId != null) 'p_store_id': storeId,
      if (prevStartDate != null) 'p_prev_start_date': _formatDate(prevStartDate),
      if (prevEndDate != null) 'p_prev_end_date': _formatDate(prevEndDate),
    });

    if (response is List && response.isNotEmpty) {
      return PnlSummaryModel.fromJson(response.first as Map<String, dynamic>);
    }
    return const PnlSummaryModel();
  }

  /// Get P&L detail from get_pnl_detail() RPC
  Future<List<PnlDetailRowModel>> getPnlDetail({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  }) async {
    final response = await _client.rpc('get_pnl_detail', params: {
      'p_company_id': companyId,
      'p_start_date': _formatDate(startDate),
      'p_end_date': _formatDate(endDate),
      if (storeId != null) 'p_store_id': storeId,
    });

    if (response is List) {
      return response
          .map((row) => PnlDetailRowModel.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Get B/S summary from get_bs() RPC
  Future<BsSummaryModel> getBsSummary({
    required String companyId,
    required DateTime asOfDate,
    String? storeId,
    DateTime? compareDate,
  }) async {
    final response = await _client.rpc('get_bs', params: {
      'p_company_id': companyId,
      'p_as_of_date': _formatDate(asOfDate),
      if (storeId != null) 'p_store_id': storeId,
      if (compareDate != null) 'p_compare_date': _formatDate(compareDate),
    });

    if (response is List && response.isNotEmpty) {
      return BsSummaryModel.fromJson(response.first as Map<String, dynamic>);
    }
    return const BsSummaryModel();
  }

  /// Get B/S detail from get_bs_detail() RPC
  Future<List<BsDetailRowModel>> getBsDetail({
    required String companyId,
    required DateTime asOfDate,
    String? storeId,
  }) async {
    final response = await _client.rpc('get_bs_detail', params: {
      'p_company_id': companyId,
      'p_as_of_date': _formatDate(asOfDate),
      if (storeId != null) 'p_store_id': storeId,
    });

    if (response is List) {
      return response
          .map((row) => BsDetailRowModel.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Get daily P&L trend for charts
  Future<List<DailyPnlModel>> getDailyPnlTrend({
    required String companyId,
    required DateTime startDate,
    required DateTime endDate,
    String? storeId,
  }) async {
    // Use raw SQL query via RPC or direct query
    // This queries journal data directly for daily breakdown
    final response = await _client.rpc('get_pnl_daily', params: {
      'p_company_id': companyId,
      'p_start_date': _formatDate(startDate),
      'p_end_date': _formatDate(endDate),
      if (storeId != null) 'p_store_id': storeId,
    });

    if (response is List) {
      return response
          .map((row) => DailyPnlModel.fromJson(row as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  /// Get monthly P&L trend for charts
  Future<List<Map<String, dynamic>>> getMonthlyPnlTrend({
    required String companyId,
    required int year,
    String? storeId,
  }) async {
    final response = await _client.rpc('get_pnl_monthly', params: {
      'p_company_id': companyId,
      'p_year': year,
      if (storeId != null) 'p_store_id': storeId,
    });

    if (response is List) {
      return List<Map<String, dynamic>>.from(response);
    }
    return [];
  }

  String _formatDate(DateTime date) => date.toIso8601String().split('T')[0];

  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  // UTILITY METHODS
  // ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

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
