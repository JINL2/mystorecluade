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

  /// Save cash ending using RPC call
  ///
  /// [params] contains all parameters for the RPC function
  /// Returns the response from database
  /// Throws exception on error
  Future<Map<String, dynamic>?> saveCashEnding(
    Map<String, dynamic> params,
  ) async {
    try {
      // RPC returns void on success, explicitly specify void type
      await _client.rpc<void>(
        CashEndingConstants.rpcInsertCashierAmount,
        params: params,
      );

      // RPC returns void on success, return null to indicate success
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
}
