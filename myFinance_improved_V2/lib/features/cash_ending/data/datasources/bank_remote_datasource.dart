// lib/features/cash_ending/data/datasources/bank_remote_datasource.dart

import 'package:supabase_flutter/supabase_flutter.dart';

/// Remote Data Source for Bank Balance
///
/// This is the ONLY place where Supabase client is used for bank operations.
/// Handles all database operations and RPC calls for bank balance.
/// Returns raw JSON data (Map<String, dynamic>).
class BankRemoteDataSource {
  final SupabaseClient _client;

  BankRemoteDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Save bank balance using RPC call
  ///
  /// [params] contains all parameters for the RPC function
  /// Returns the response from database
  /// Throws exception on error
  Future<void> saveBankBalance(Map<String, dynamic> params) async {
    // Call RPC: bank_amount_insert_v2
    await _client.rpc<void>(
      'bank_amount_insert_v2',
      params: params,
    );
  }
}
