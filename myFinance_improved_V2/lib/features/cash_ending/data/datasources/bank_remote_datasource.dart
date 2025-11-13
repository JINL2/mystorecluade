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

  /// Save bank balance using RPC call
  ///
  /// Calls bank_amount_insert_v2 stored procedure
  /// [params] contains all parameters for the RPC function
  /// Throws exception on error
  Future<void> saveBankBalance(Map<String, dynamic> params) async {
    try {
      await _client.rpc<void>(
        CashEndingConstants.rpcInsertBankAmount,
        params: params,
      );
    } catch (e) {
      // Re-throw with additional context
      throw Exception('Failed to save bank balance via RPC: $e');
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
      throw Exception('Failed to fetch bank balance history: $e');
    }
  }
}
