// lib/features/cash_ending/data/datasources/vault_remote_datasource.dart

import 'package:flutter/foundation.dart';
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
    debugPrint('\n🟢 [VaultRemoteDataSource] recountVault() 호출');
    debugPrint('   - RPC Name: ${CashEndingConstants.rpcVaultAmountRecount}');
    debugPrint('   - Parameters: $params');

    try {
      debugPrint('📡 [VaultRemoteDataSource] Supabase RPC 호출 중...');
      final response = await _client.rpc(
        CashEndingConstants.rpcVaultAmountRecount,
        params: params,
      );

      debugPrint('📥 [VaultRemoteDataSource] Supabase 응답 받음: $response');

      // RPC returns JSON object, convert to Map
      if (response is Map<String, dynamic>) {
        debugPrint('✅ [VaultRemoteDataSource] 응답 타입 검증 성공 (Map<String, dynamic>)');
        return response;
      } else {
        debugPrint('❌ [VaultRemoteDataSource] 응답 타입 오류: ${response.runtimeType}');
        throw Exception('Unexpected response type from vault_amount_recount');
      }
    } catch (e) {
      // Re-throw with additional context
      final locationId = params['p_location_id'] ?? 'unknown';
      final denominationCount = params['p_recount_data'] is List
          ? (params['p_recount_data'] as List).length
          : 0;
      debugPrint('❌ [VaultRemoteDataSource] RPC 호출 실패: $e');
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
