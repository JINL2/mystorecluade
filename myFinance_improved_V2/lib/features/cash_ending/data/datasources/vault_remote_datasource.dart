// lib/features/cash_ending/data/datasources/vault_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants.dart';

/// Remote Data Source for Vault operations
///
/// This is the ONLY place where Supabase client is used for vault operations.
/// Handles all database operations and RPC calls.
/// Returns raw JSON data (Map<String, dynamic>).
class VaultRemoteDataSource {
  final SupabaseClient _client;

  VaultRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Save vault transaction using RPC call
  ///
  /// Calls vault_amount_insert stored procedure
  /// [params] contains all parameters for the RPC function
  /// Throws exception on error
  Future<void> saveVaultTransaction(Map<String, dynamic> params) async {
    try {
      await _client.rpc<void>(
        CashEndingConstants.rpcInsertVaultAmount,
        params: params,
      );
    } catch (e) {
      // Re-throw with additional context
      final locationId = params['p_location_id'] ?? 'unknown';
      final amount = params['p_amount'] ?? 'unknown';
      throw Exception(
        'Failed to save vault transaction via RPC '
        '(Location: $locationId, Amount: $amount): $e',
      );
    }
  }

  /// Get vault transaction history from database
  ///
  /// Returns list of vault transaction records
  /// Throws exception on error
  Future<List<Map<String, dynamic>>> getVaultTransactionHistory({
    required String locationId,
    int limit = 10,
  }) async {
    try {
      // Note: Adjust table/view name based on your database schema
      final response = await _client
          .from('vault_amount')
          .select()
          .eq('location_id', locationId)
          .order('record_date', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception(
        'Failed to fetch vault transaction history '
        '(Location: $locationId, Limit: $limit): $e',
      );
    }
  }
}
