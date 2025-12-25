import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../models/cash_location_model.dart';
import '../models/counterparty_model.dart';
import '../models/expense_account_model.dart';

/// Data source for cash control feature
/// Handles all Supabase API calls
class CashTransactionDataSource {
  final SupabaseClient _client;
  static const _tag = '[CashTransactionDataSource]';

  CashTransactionDataSource({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Get user's quick access expense accounts
  /// Uses RPC: get_user_quick_access_accounts
  /// Now includes account_code for filtering
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

  /// Get all expense accounts (not just quick access)
  /// Uses RPC: get_expense_accounts
  /// Returns only accounts with account_type = 'expense'
  Future<List<ExpenseAccountModel>> getAllExpenseAccounts({
    required String companyId,
    String? searchQuery,
    int limit = 50,
  }) async {
    debugPrint('$_tag 🔍 getAllExpenseAccounts called - companyId: $companyId, query: $searchQuery');

    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_expense_accounts',
        params: {
          'p_company_id': companyId,
          'p_search_query': searchQuery,
          'p_limit': limit,
        },
      );

      debugPrint('$_tag 📥 get_expense_accounts response count: ${response.length}');

      return response
          .map((json) => ExpenseAccountModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ ERROR in getAllExpenseAccounts: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get all expense accounts',
        extra: {'companyId': companyId, 'searchQuery': searchQuery},
      );
      return [];
    }
  }

  /// Get accounts by type with optional filtering
  /// Uses RPC: get_accounts_by_type
  /// Flexible filtering by account_type, code range, or search
  Future<List<ExpenseAccountModel>> getAccountsByType({
    required String companyId,
    String? accountType,
    String? codeFrom,
    String? codeTo,
    String? searchQuery,
    int limit = 50,
  }) async {
    debugPrint('$_tag 🔍 getAccountsByType called - type: $accountType, code: $codeFrom-$codeTo');

    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_accounts_by_type',
        params: {
          'p_company_id': companyId,
          'p_account_type': accountType,
          'p_code_from': codeFrom,
          'p_code_to': codeTo,
          'p_search_query': searchQuery,
          'p_limit': limit,
        },
      );

      debugPrint('$_tag 📥 get_accounts_by_type response count: ${response.length}');

      return response
          .map((json) => ExpenseAccountModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ ERROR in getAccountsByType: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get accounts by type',
        extra: {'companyId': companyId, 'accountType': accountType},
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

  /// Get self-counterparty for a company
  /// This is the counterparty where company_id = linked_company_id
  /// Used for within-company transfers (same company, different stores)
  Future<CounterpartyModel?> getSelfCounterparty({
    required String companyId,
  }) async {
    debugPrint('$_tag 🔍 getSelfCounterparty called - companyId: $companyId');

    try {
      final response = await _client
          .from('counterparties')
          .select('*')
          .eq('company_id', companyId)
          .eq('linked_company_id', companyId)
          .eq('is_deleted', false)
          .eq('is_internal', true)
          .limit(1)
          .maybeSingle();

      if (response == null) {
        debugPrint('$_tag ⚠️ No self-counterparty found for company: $companyId');
        return null;
      }

      debugPrint('$_tag ✅ Found self-counterparty: ${response['name']}');
      return CounterpartyModel.fromJson(response);
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ Error getting self-counterparty: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get self-counterparty',
        extra: {'companyId': companyId},
      );
      return null;
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

  /// Ensure inter-company setup (counterparties + account mappings)
  /// Uses RPC: ensure_inter_company_setup
  /// For Between Companies transfers - creates Note Receivable/Payable mappings
  /// It will automatically create:
  /// 1. Counterparties (both directions) if not exist
  /// 2. Account mappings (Note Receivable/Payable 1110/2010)
  Future<Map<String, dynamic>> ensureInterCompanySetup({
    required String myCompanyId,
    required String targetCompanyId,
  }) async {
    debugPrint('$_tag 🔄 ensureInterCompanySetup called');
    debugPrint('$_tag   myCompanyId: $myCompanyId');
    debugPrint('$_tag   targetCompanyId: $targetCompanyId');

    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'ensure_inter_company_setup',
        params: {
          'p_my_company_id': myCompanyId,
          'p_target_company_id': targetCompanyId,
        },
      );

      debugPrint('$_tag ✅ ensureInterCompanySetup response: $response');
      return response;
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ ensureInterCompanySetup error: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to ensure inter-company setup',
        extra: {
          'myCompanyId': myCompanyId,
          'targetCompanyId': targetCompanyId,
        },
      );
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Ensure within-company setup (self-counterparty + account mappings)
  /// Uses RPC: ensure_within_company_setup
  /// For Within Company transfers (같은 회사, 다른 가게)
  /// Creates Inter-branch Receivable/Payable (1360/2360) mappings
  Future<Map<String, dynamic>> ensureWithinCompanySetup({
    required String companyId,
  }) async {
    debugPrint('$_tag 🔄 ensureWithinCompanySetup called');
    debugPrint('$_tag   companyId: $companyId');

    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'ensure_within_company_setup',
        params: {
          'p_company_id': companyId,
        },
      );

      debugPrint('$_tag ✅ ensureWithinCompanySetup response: $response');
      return response;
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ ensureWithinCompanySetup error: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to ensure within-company setup',
        extra: {
          'companyId': companyId,
        },
      );
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Get or create counterparty for target company
  /// Uses RPC: get_or_create_counterparty_for_company
  /// Returns the counterparty_id for the target company
  Future<String?> getOrCreateCounterpartyForCompany({
    required String myCompanyId,
    required String targetCompanyId,
  }) async {
    debugPrint('$_tag 🔄 getOrCreateCounterpartyForCompany called');
    debugPrint('$_tag   myCompanyId: $myCompanyId');
    debugPrint('$_tag   targetCompanyId: $targetCompanyId');

    try {
      final response = await _client.rpc<String>(
        'get_or_create_counterparty_for_company',
        params: {
          'p_my_company_id': myCompanyId,
          'p_target_company_id': targetCompanyId,
        },
      );

      debugPrint('$_tag ✅ getOrCreateCounterpartyForCompany response: $response');
      return response;
    } catch (e, stackTrace) {
      debugPrint('$_tag ❌ getOrCreateCounterpartyForCompany error: $e');
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get or create counterparty',
        extra: {
          'myCompanyId': myCompanyId,
          'targetCompanyId': targetCompanyId,
        },
      );
      return null;
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
