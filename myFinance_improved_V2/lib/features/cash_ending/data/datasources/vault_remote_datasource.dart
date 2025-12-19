// lib/features/cash_ending/data/datasources/vault_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/monitoring/sentry_config.dart';
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
  /// ✅ Uses insert_amount_multi_currency (Entry-based workflow)
  /// Supports IN, OUT, and RECOUNT transaction types with multi-currency
  /// [params] contains all parameters for the RPC function
  /// Returns the entry data from database (entry_id, balance_before, balance_after)
  /// Throws exception on error
  Future<Map<String, dynamic>?> saveVaultTransaction(
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
      final transactionType = params['p_vault_transaction_type'] ?? 'unknown';
      throw Exception(
        'Failed to save vault transaction via RPC '
        '(Location: $locationId, Type: $transactionType): $e',
      );
    }
  }

  /// Perform vault recount using RPC call
  ///
  /// @Deprecated Use saveVaultTransaction with p_vault_transaction_type='recount' instead
  /// [params] contains all parameters for the RPC function
  /// Returns RPC response with adjustment details
  /// Throws exception on error
  @Deprecated('Use saveVaultTransaction with transactionType="recount" instead')
  Future<Map<String, dynamic>> recountVault(Map<String, dynamic> params) async {
    try {
      final response = await _client.rpc(
        CashEndingConstants.rpcVaultAmountRecount,
        params: params,
      );

      // RPC returns JSON object, convert to Map
      if (response is Map<String, dynamic>) {
        return response;
      } else {
        throw Exception('Unexpected response type from vault_amount_recount');
      }
    } catch (e, stackTrace) {
      // Re-throw with additional context
      final locationId = params['p_location_id'] ?? 'unknown';
      final denominationCount = params['p_recount_data'] is List
          ? (params['p_recount_data'] as List).length
          : 0;
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'VaultRemoteDataSource.recountVault RPC failed',
        extra: {
          'locationId': locationId,
          'denominationCount': denominationCount,
        },
      );
      throw Exception(
        'Failed to recount vault via RPC '
        '(Location: $locationId, Denominations: $denominationCount): $e',
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
