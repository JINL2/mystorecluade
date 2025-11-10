// lib/features/cash_ending/data/datasources/vault_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Vault Transactions
///
/// This is the ONLY place where Supabase client is used for vault operations.
/// Handles all database operations and RPC calls for vault transactions.
/// Returns raw JSON data (Map<String, dynamic>).
class VaultRemoteDataSource {
  final SupabaseClient _client;

  VaultRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Save vault transaction using RPC call
  ///
  /// [params] contains all parameters for the RPC function
  /// Returns the response from database
  /// Throws exception on error
  Future<void> saveVaultTransaction(Map<String, dynamic> params) async {
    // Call RPC: vault_amount_insert
    await _client.rpc<void>(
      'vault_amount_insert',
      params: params,
    );
  }
}
