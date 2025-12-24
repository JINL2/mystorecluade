import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../models/cash_location_model.dart';
import '../models/counterparty_model.dart';
import '../models/expense_account_model.dart';

/// Data source for cash control feature
/// Handles all Supabase API calls
class CashControlDataSource {
  final SupabaseClient _client;
  static const _tag = '[CashControlDataSource]';

  CashControlDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Get user's quick access expense accounts
  /// Uses RPC: get_user_quick_access_accounts
  Future<List<ExpenseAccountModel>> getExpenseAccounts({
    required String userId,
    required String companyId,
    int limit = 10,
  }) async {
    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_user_quick_access_accounts',
        params: {
          'p_user_id': userId,
          'p_company_id': companyId,
          'p_limit': limit,
        },
      );

      return response
          .map((json) => ExpenseAccountModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get expense accounts',
        extra: {'userId': userId, 'companyId': companyId},
      );
      return [];
    }
  }

  /// Get counterparties for a company
  Future<List<CounterpartyModel>> getCounterparties({
    required String companyId,
    bool? isInternal,
  }) async {
    try {
      var query = _client
          .from('counterparties')
          .select('*')
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      if (isInternal != null) {
        query = query.eq('is_internal', isInternal);
      }

      final response = await query.order('name');

      return (response as List)
          .map((json) => CounterpartyModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get counterparties',
        extra: {'companyId': companyId, 'isInternal': isInternal},
      );
      return [];
    }
  }

  /// Get cash locations for selector
  /// Uses RPC: get_cash_locations
  Future<List<CashLocationModel>> getCashLocations({
    required String companyId,
    String? storeId,
  }) async {
    debugPrint('$_tag 🔍 getCashLocations called - companyId: $companyId, storeId: $storeId');

    try {
      debugPrint('$_tag 📡 Calling RPC: get_cash_locations with p_company_id: $companyId');

      final response = await _client.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );

      debugPrint('$_tag 📥 RPC Response received - count: ${response.length}');
      debugPrint('$_tag 📥 Raw response: $response');

      var locations = response
          .map((json) {
            debugPrint('$_tag 🔄 Parsing JSON: $json');
            return CashLocationModel.fromJson(json as Map<String, dynamic>);
          })
          .toList();

      debugPrint('$_tag ✅ Parsed ${locations.length} locations');

      // Filter by store if provided
      if (storeId != null) {
        debugPrint('$_tag 🔍 Filtering by storeId: $storeId');
        final beforeFilter = locations.length;
        locations = locations.where((l) {
          debugPrint('$_tag   - Location: ${l.locationName}, storeId: ${l.storeId}');
          return l.storeId == storeId;
        }).toList();
        debugPrint('$_tag 📊 After filter: $beforeFilter -> ${locations.length}');
      }

      return locations;
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ ERROR in getCashLocations: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get cash locations',
        extra: {'companyId': companyId, 'storeId': storeId},
      );
      return [];
    }
  }

  /// Create expense entry using journal RPC
  /// Uses RPC: insert_journal_with_everything_utc
  Future<Map<String, dynamic>> createExpenseEntry({
    required double amount,
    required String companyId,
    required String storeId,
    required String createdBy,
    required String description,
    required String entryDateUtc,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? cashLocationId,
  }) async {
    final params = {
      'p_base_amount': amount,
      'p_company_id': companyId,
      'p_store_id': storeId,
      'p_created_by': createdBy,
      'p_description': description,
      'p_entry_date_utc': entryDateUtc,
      'p_lines': lines,
      'p_counterparty_id': counterpartyId,
      'p_if_cash_location_id': cashLocationId,
    };

    debugPrint('$_tag 📤 createExpenseEntry - Calling RPC: insert_journal_with_everything_utc');
    debugPrint('$_tag 📋 Request params:');
    debugPrint('$_tag   p_base_amount: $amount');
    debugPrint('$_tag   p_company_id: $companyId');
    debugPrint('$_tag   p_store_id: $storeId');
    debugPrint('$_tag   p_created_by: $createdBy');
    debugPrint('$_tag   p_description: $description');
    debugPrint('$_tag   p_entry_date_utc: $entryDateUtc');
    debugPrint('$_tag   p_lines: $lines');
    debugPrint('$_tag   p_counterparty_id: $counterpartyId');
    debugPrint('$_tag   p_if_cash_location_id: $cashLocationId');

    try {
      final response = await _client.rpc<dynamic>(
        'insert_journal_with_everything_utc',
        params: params,
      );

      debugPrint('$_tag ✅ RPC Response: $response');
      debugPrint('$_tag 📥 Response type: ${response.runtimeType}');

      return {
        'success': true,
        'data': response,
      };
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ RPC ERROR: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to create expense entry',
        extra: {
          'companyId': companyId,
          'amount': amount,
          'description': description,
        },
      );
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Create debt record
  /// Uses RPC: create_debt_record
  Future<Map<String, dynamic>> createDebtRecord({
    required Map<String, dynamic> debtInfo,
    required String companyId,
    required String storeId,
    required String journalId,
    required String accountId,
    required double amount,
    required String entryDate,
  }) async {
    try {
      final response = await _client.rpc<dynamic>(
        'create_debt_record',
        params: {
          'p_debt_info': debtInfo,
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_journal_id': journalId,
          'p_account_id': accountId,
          'p_amount': amount,
          'p_entry_date': entryDate,
        },
      );

      return {
        'success': true,
        'data': response,
      };
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to create debt record',
        extra: {
          'companyId': companyId,
          'journalId': journalId,
          'amount': amount,
        },
      );
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
