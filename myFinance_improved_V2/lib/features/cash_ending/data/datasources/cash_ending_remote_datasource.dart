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
  /// Uses cash_ending_insert_amount_multi_currency (Entry-based workflow)
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

  /// Get balance summary (Journal vs Real) for a cash location
  ///
  /// Uses stock data from cash_amount_entries.balance_after
  /// Returns balance comparison data
  Future<Map<String, dynamic>> getBalanceSummary({
    required String locationId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        CashEndingConstants.rpcGetBalanceSummary,
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
}
