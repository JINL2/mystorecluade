// lib/features/cash_ending/data/datasources/cash_ending_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

/// Remote Data Source for Cash Ending
///
/// This is the ONLY place where Supabase client is used for cash ending.
/// Handles all database operations and RPC calls.
/// Returns raw JSON data (Map<String, dynamic>).
class CashEndingRemoteDataSource {
  final SupabaseClient _client;

  CashEndingRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Save cash ending using universal multi-currency RPC
  ///
  /// Uses insert_amount_multi_currency (Entry-based workflow)
  /// [params] contains all parameters for the RPC function
  /// Returns the entry data from database (entry_id, balance_before, balance_after)
  Future<Map<String, dynamic>?> saveCashEnding(
    Map<String, dynamic> params,
  ) async {
    try {
      final response = await _client.rpc(
        CashEndingConstants.rpcInsertAmountMultiCurrency,
        params: params,
      );

      // RPC returns table with entry_id, balance_before, balance_after
      if (response is List && response.isNotEmpty) {
        return response.first as Map<String, dynamic>;
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  /// Get cash ending history from view
  ///
  /// Returns list of cash ending records
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getCashEndingHistory({
    required String locationId,
    int limit = 10,
  }) async {
    final response = await _client
        .from('cash_ending_history_view')
        .select()
        .eq('location_id', locationId)
        .order('record_date', ascending: false)
        .limit(limit);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Get balance summary (Journal vs Real) for a cash location
  ///
  /// Uses stock data from cash_amount_entries.balance_after
  /// Returns balance comparison data
  Future<Map<String, dynamic>> getBalanceSummary({
    required String locationId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        CashEndingConstants.rpcGetBalanceSummaryV2,
        params: {'p_location_id': locationId},
      );

      if (response is Map<String, dynamic>) {
        // Check if RPC returned error
        if (response['success'] == false) {
          throw Exception(
            response['error'] ?? 'Failed to get balance summary',
          );
        }
        return response;
      } else {
        throw Exception('Unexpected response type from balance summary RPC');
      }
    } catch (e) {
      throw Exception(
        'Failed to get balance summary for location $locationId: $e',
      );
    }
  }

  /// Get balance summary for multiple locations
  ///
  /// Useful for dashboard or overview screens
  /// Returns list of balance summaries
  /// Throws exception on error
  Future<Map<String, dynamic>> getMultipleBalanceSummary({
    required List<String> locationIds,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        CashEndingConstants.rpcGetMultipleBalanceSummary,
        params: {'p_location_ids': locationIds},
      );

      if (response is Map<String, dynamic>) {
        if (response['success'] == false) {
          throw Exception(
            response['error'] ?? 'Failed to get multiple balance summaries',
          );
        }
        return response;
      } else {
        throw Exception(
          'Unexpected response type from multiple balance summary RPC',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to get multiple balance summaries: $e',
      );
    }
  }

  /// Get company-wide balance summary
  ///
  /// Aggregates balance summary for all locations in a company
  /// [locationType] can be 'cash', 'vault', 'bank', or null for all
  /// Returns aggregated balance data
  /// Throws exception on error
  Future<Map<String, dynamic>> getCompanyBalanceSummary({
    required String companyId,
    String? locationType,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        CashEndingConstants.rpcGetCompanyBalanceSummary,
        params: {
          'p_company_id': companyId,
          'p_location_type': locationType,
        },
      );

      if (response is Map<String, dynamic>) {
        if (response['success'] == false) {
          throw Exception(
            response['error'] ?? 'Failed to get company balance summary',
          );
        }
        return response;
      } else {
        throw Exception(
          'Unexpected response type from company balance summary RPC',
        );
      }
    } catch (e) {
      throw Exception(
        'Failed to get company balance summary for $companyId: $e',
      );
    }
  }
}
