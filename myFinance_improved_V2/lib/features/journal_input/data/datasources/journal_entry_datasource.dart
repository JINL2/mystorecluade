// Data Source: JournalEntryDataSource
// Handles all API calls and database queries for journal entries

import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../models/journal_entry_model.dart';

class JournalEntryDataSource {
  final SupabaseClient _supabase;

  JournalEntryDataSource(this._supabase);

  /// Fetch all accounts from the database
  Future<List<Map<String, dynamic>>> getAccounts() async {
    try {
      final response = await _supabase
          .from('accounts')
          .select('account_id, account_name, category_tag')
          .order('account_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch accounts: $e');
    }
  }

  /// Fetch counterparties for a specific company
  Future<List<Map<String, dynamic>>> getCounterparties(String companyId) async {
    try {
      if (companyId.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('counterparties')
          .select('counterparty_id, name, is_internal, linked_company_id')
          .eq('company_id', companyId)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch counterparties: $e');
    }
  }

  /// Fetch stores for a linked company (counterparty)
  Future<List<Map<String, dynamic>>> getCounterpartyStores(String linkedCompanyId) async {
    try {
      if (linkedCompanyId.isEmpty) {
        return [];
      }

      final response = await _supabase
          .from('stores')
          .select('store_id, store_name')
          .eq('company_id', linkedCompanyId)
          .order('store_name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to fetch counterparty stores: $e');
    }
  }

  /// Fetch cash locations using RPC
  Future<List<Map<String, dynamic>>> getCashLocations({
    required String companyId,
    String? storeId,
  }) async {
    try {
      if (companyId.isEmpty) {
        return [];
      }

      // Use RPC to get cash locations
      final response = await _supabase.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );

      // Convert RPC response to expected format
      final locations = response.map((item) {
        final location = {
          'cash_location_id': item['id'],
          'location_name': item['name'],
          'location_type': item['type'],
          'store_id': item['storeId'],
        };

        // Filter by store if specified
        if (storeId != null && storeId.isNotEmpty) {
          if (item['storeId'] == storeId) {
            return location;
          }
          return null;
        }

        return location;
      }).whereType<Map<String, dynamic>>().toList();

      return locations;
    } catch (e) {
      throw Exception('Failed to fetch cash locations: $e');
    }
  }

  /// Check account mapping for internal transactions
  Future<Map<String, dynamic>?> checkAccountMapping({
    required String companyId,
    required String counterpartyId,
    required String accountId,
  }) async {
    try {
      final response = await _supabase
          .from('account_mappings')
          .select('my_account_id, linked_account_id, direction')
          .eq('my_company_id', companyId)
          .eq('counterparty_id', counterpartyId)
          .eq('my_account_id', accountId)
          .maybeSingle();

      if (response != null) {
        return {
          'my_account_id': response['my_account_id'],
          'linked_account_id': response['linked_account_id'],
          'direction': response['direction'],
        };
      }

      return null;
    } catch (e) {
      return null;
    }
  }

  /// Fetch exchange rates using RPC
  Future<Map<String, dynamic>> getExchangeRates(String companyId) async {
    try {
      if (companyId.isEmpty) {
        throw Exception('Company ID is required');
      }

      final response = await _supabase.rpc<Map<String, dynamic>>(
        'get_exchange_rate_v2',
        params: {
          'p_company_id': companyId,
        },
      );

      return response;
    } catch (e) {
      throw Exception('Failed to fetch exchange rates: $e');
    }
  }

  /// Submit journal entry using RPC
  Future<void> submitJournalEntry({
    required JournalEntryModel journalEntry,
    required String userId,
    required String companyId,
    String? storeId,
  }) async {
    try {
      // Use device's current time at the moment of submission
      final currentDeviceTime = DateTime.now();
      final entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').format(currentDeviceTime);

      // Prepare journal lines
      final pLines = journalEntry.getTransactionLinesJson();

      // Get main counterparty ID
      final mainCounterpartyId = journalEntry.getMainCounterpartyId();

      // Calculate total debits for base amount
      final totalDebits = journalEntry.transactionLines
          .where((line) => line.isDebit)
          .fold(0.0, (sum, line) => sum + line.amount);

      // Call the journal RPC
      await _supabase.rpc<void>(
        'insert_journal_with_everything',
        params: {
          'p_base_amount': totalDebits,
          'p_company_id': companyId,
          'p_created_by': userId,
          'p_description': journalEntry.overallDescription,
          'p_entry_date': entryDate,
          'p_lines': pLines,
          'p_counterparty_id': mainCounterpartyId,
          'p_if_cash_location_id': journalEntry.counterpartyCashLocationId,
          'p_store_id': storeId,
        },
      );
    } catch (e) {
      throw Exception('Failed to create journal entry: $e');
    }
  }
}
