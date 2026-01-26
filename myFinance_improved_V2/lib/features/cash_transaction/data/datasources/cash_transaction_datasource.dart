import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
import '../models/cash_location_model.dart';
import '../models/counterparty_model.dart';
import '../models/expense_account_model.dart';

/// Data source for cash control feature
/// Handles all Supabase API calls
class CashTransactionDataSource {
  final SupabaseClient _client;

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

    try {
      final response = await _client.rpc<List<dynamic>>(
        'get_expense_accounts',
        params: {
          'p_company_id': companyId,
          'p_search_query': searchQuery,
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
        hint: 'CashControl: Failed to get all expense accounts',
        extra: {'companyId': companyId, 'searchQuery': searchQuery},
      );
      return [];
    }
  }

  /// Get counterparties for a company
  /// Uses RPC: get_counterparties_v3 (mode: 'list')
  /// Server-side filtering for isInternal
  Future<List<CounterpartyModel>> getCounterparties({
    required String companyId,
    bool? isInternal,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_counterparties_v3',
        params: {
          'p_company_id': companyId,
          'p_is_internal': isInternal,
          'p_mode': 'list',
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Unknown error');
      }

      final data = response['data'] as List<dynamic>? ?? [];
      return data
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
  /// Uses RPC: get_counterparties_v3 (mode: 'list')
  /// Server-side filtering: is_internal=true AND linked_company_id=company_id
  /// Used for within-company transfers (same company, different stores)
  Future<CounterpartyModel?> getSelfCounterparty({
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_counterparties_v3',
        params: {
          'p_company_id': companyId,
          'p_is_internal': true,
          'p_linked_company_id': companyId,
          'p_mode': 'list',
        },
      );

      if (response['success'] != true) {
        throw Exception(response['error'] ?? 'Unknown error');
      }

      final data = response['data'] as List<dynamic>? ?? [];
      if (data.isEmpty) {
        return null;
      }

      return CounterpartyModel.fromJson(data.first as Map<String, dynamic>);
    } catch (e, stackTrace) {
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

    try {

      final response = await _client.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );


      var locations = response
          .map((json) {
            return CashLocationModel.fromJson(json as Map<String, dynamic>);
          })
          .toList();


      // Filter by store if provided
      if (storeId != null) {
        locations = locations.where((l) => l.storeId == storeId).toList();
      }

      return locations;
    } catch (e, stackTrace) {
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


    try {
      final response = await _client.rpc<dynamic>(
        'insert_journal_with_everything_utc',
        params: params,
      );


      return {
        'success': true,
        'data': response,
      };
    } catch (e, stackTrace) {
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

    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'ensure_inter_company_setup',
        params: {
          'p_my_company_id': myCompanyId,
          'p_target_company_id': targetCompanyId,
        },
      );

      return response;
    } catch (e, stackTrace) {
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

  /// Get or create counterparty for target company
  /// Uses RPC: get_or_create_counterparty_for_company
  /// Returns the counterparty_id for the target company
  Future<String?> getOrCreateCounterpartyForCompany({
    required String myCompanyId,
    required String targetCompanyId,
  }) async {

    try {
      final response = await _client.rpc<String>(
        'get_or_create_counterparty_for_company',
        params: {
          'p_my_company_id': myCompanyId,
          'p_target_company_id': targetCompanyId,
        },
      );

      return response;
    } catch (e, stackTrace) {
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

  /// Get base currency symbol for a company
  /// Uses RPC: get_base_currency
  /// Returns the currency symbol (e.g., '₩', '$', '₫')
  Future<String> getBaseCurrencySymbol({
    required String companyId,
  }) async {
    try {
      final response = await _client.rpc<Map<String, dynamic>>(
        'get_base_currency',
        params: {
          'p_company_id': companyId,
        },
      );

      final baseCurrency = response['base_currency'] as Map<String, dynamic>?;
      if (baseCurrency == null) {
        return '₩';
      }

      return baseCurrency['symbol'] as String? ?? '₩';
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashControl: Failed to get base currency symbol',
        extra: {'companyId': companyId},
      );
      return '₩';
    }
  }
}
