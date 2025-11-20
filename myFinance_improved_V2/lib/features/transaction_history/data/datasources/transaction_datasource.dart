import 'package:flutter/foundation.dart';
import 'package:myfinance_improved/core/services/supabase_service.dart';

import '../../domain/entities/transaction_filter.dart';
import '../models/filter_options_model.dart';
import '../models/transaction_model.dart';

/// Data source for transaction operations
/// Handles all Supabase RPC calls for transactions
class TransactionDataSource {
  final SupabaseService _supabaseService;
  static const int _pageSize = 50;

  TransactionDataSource(this._supabaseService);

  /// Fetch transactions from Supabase using RPC call
  Future<List<TransactionModel>> getTransactionHistory({
    required String companyId,
    String? storeId,
    required TransactionFilter filter,
  }) async {
    try {
      // Determine store_id based on scope
      final effectiveStoreId = filter.scope == TransactionScope.company
        ? null  // NULL means show all stores in company
        : storeId;  // Show only current store

      final params = {
        'p_company_id': companyId,
        'p_store_id': effectiveStoreId,
        'p_date_from': filter.dateFrom?.toIso8601String(),
        'p_date_to': filter.dateTo?.toIso8601String(),
        'p_account_id': filter.accountId,
        'p_account_ids': filter.accountIds?.join(','),
        'p_cash_location_id': filter.cashLocationId,
        'p_counterparty_id': filter.counterpartyId,
        'p_journal_type': filter.journalType,
        'p_created_by': filter.createdBy,
        'p_limit': _pageSize,
        'p_offset': filter.offset,
      };

      final response = await _supabaseService.client.rpc<dynamic>(
        'get_transaction_history',
        params: params,
      );

      if (response == null) {
        return [];
      }

      // Handle different response types
      List<dynamic> dataList;
      if (response is List) {
        dataList = response;
      } else if (response is Map && response.containsKey('data')) {
        dataList = response['data'] as List;
      } else {
        return [];
      }

      // Parse transactions
      final transactions = <TransactionModel>[];
      for (final json in dataList) {
        try {
          final transaction = TransactionModel.fromJson(json as Map<String, dynamic>);
          transactions.add(transaction);
        } catch (e, stackTrace) {
          // Log parsing errors for debugging
          debugPrint('⚠️ Failed to parse transaction: $e');
          if (kDebugMode) {
            debugPrint('StackTrace: $stackTrace');
            debugPrint('Invalid JSON: $json');
          }
          // In production, this could be reported to analytics/crash reporting
          // e.g., FirebaseCrashlytics.instance.recordError(e, stackTrace);
        }
      }

      // Transactions are already sorted by the database, but we can ensure it here if needed
      // Note: TransactionModel is Freezed, access via getter

      return transactions;
    } catch (e) {
      throw Exception('Failed to fetch transactions: $e');
    }
  }

  /// Get filter options from Supabase
  Future<FilterOptionsModel> getFilterOptions({
    required String companyId,
    String? storeId,
  }) async {
    try {
      final params = {
        'p_company_id': companyId,
        'p_store_id': storeId,
      };

      final response = await _supabaseService.client.rpc<dynamic>(
        'get_transaction_filter_options',
        params: params,
      );

      if (response == null) {
        return const FilterOptionsModel();
      }

      return FilterOptionsModel.fromJson(response as Map<String, dynamic>);
    } catch (e) {
      return const FilterOptionsModel();
    }
  }
}
