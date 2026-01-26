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

  /// Save vault transaction using universal multi-currency RPC
  ///
  /// Uses cash_ending_insert_amount_multi_currency (Entry-based workflow)
  /// Supports IN, OUT, and RECOUNT transaction types with multi-currency
  /// [params] contains all parameters for the RPC function
  /// Returns the entry data from database (entry_id, balance_before, balance_after)
  Future<Map<String, dynamic>?> saveVaultTransaction(
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
      // Re-throw with additional context
      final locationId = params['p_location_id'] ?? 'unknown';
      final transactionType = params['p_vault_transaction_type'] ?? 'unknown';
      throw Exception(
        'Failed to save vault transaction via RPC '
        '(Location: $locationId, Type: $transactionType): $e',
      );
    }
  }
}
