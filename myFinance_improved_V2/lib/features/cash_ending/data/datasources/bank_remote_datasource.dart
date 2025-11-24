// lib/features/cash_ending/data/datasources/bank_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

/// Remote Data Source for Bank operations
///
/// This is the ONLY place where Supabase client is used for bank operations.
/// Handles all database operations and RPC calls.
/// Returns raw JSON data (Map<String, dynamic>).
class BankRemoteDataSource {
  final SupabaseClient _client;

  BankRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Save bank balance using universal multi-currency RPC
  ///
  /// ✅ Uses insert_amount_multi_currency (Entry-based workflow)
  /// Supports multi-currency bank balances
  /// [params] contains all parameters for the RPC function
  /// Returns the entry data from database (entry_id, balance_before, balance_after)
  /// Throws exception on error
  Future<Map<String, dynamic>?> saveBankBalance(
    Map<String, dynamic> params,
  ) async {
    try {
      // ✅ NEW: Universal RPC returns entry data
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
      // Re-throw with additional context
      final locationId = params['p_location_id'] ?? 'unknown';
      throw Exception(
        'Failed to save bank balance via RPC '
        '(Location: $locationId): $e',
      );
    }
  }

  /// Get bank balance history from database
  ///
  /// Returns list of bank balance records
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  }) async {
    try {
      // Note: Adjust table/view name based on your database schema
      final response = await _client
          .from('bank_amount')
          .select()
          .eq('location_id', locationId)
          .order('record_date', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception(
        'Failed to fetch bank balance history '
        '(Location: $locationId, Limit: $limit): $e',
      );
    }
  }
}
