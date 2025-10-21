import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bank_real_model.dart';
import '../models/cash_location_model.dart';
import '../models/cash_real_model.dart';
import '../models/vault_real_model.dart';
import '../models/journal_entry_model.dart';

/// Cash Location Data Source
/// Handles all API calls for cash location feature
class CashLocationDataSource {
  final _supabase = Supabase.instance.client;

  /// Get all cash locations (all types) for client-side filtering
  /// Uses v_cash_location view to get cash amounts for cash location page
  Future<List<CashLocationModel>> getAllCashLocations({
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase
          .from('v_cash_location')
          .select('*')
          .eq('store_id', storeId)
          .eq('company_id', companyId)
          .eq('is_deleted', false)
          .order('location_type')
          .order('location_name');

      return (response as List)
          .map((json) => CashLocationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to load cash locations: ${e.toString()}');
    }
  }

  /// Get cash locations using RPC for selectors
  /// This method is for cash location selectors in forms
  Future<List<CashLocationRPCResponse>> getCashLocationsForSelector({
    required String companyId,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_cash_locations',
        params: {
          'p_company_id': companyId,
        },
      );

      return response
          .map((json) => CashLocationRPCResponse.fromJson(json as Map<String, dynamic>))
          .where((location) =>
              !location.isDeleted &&
              (location.additionalData['company_id'] == companyId),
          )
          .toList();
    } catch (e) {
      throw Exception('Failed to load cash locations: ${e.toString()}');
    }
  }

  /// Get cash real entries using RPC
  Future<List<CashRealEntryModel>> getCashReal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_cash_real',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      return response
          .map((json) => CashRealEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get bank real entries using RPC
  Future<List<BankRealEntryModel>> getBankReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_bank_real',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      return response
          .map((json) => BankRealEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get vault real entries using RPC
  Future<List<VaultRealEntryModel>> getVaultReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_vault_real',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      // Filter to only include vault type entries
      final vaultEntries = response
          .where((json) => (json as Map<String, dynamic>)['location_type'] == 'vault')
          .map((json) => VaultRealEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();

      return vaultEntries;
    } catch (e) {
      return [];
    }
  }

  /// Get cash journal entries using RPC
  Future<List<JournalEntryModel>> getCashJournal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc(
        'get_cash_journal',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      if (response == null) return [];

      return (response as List)
          .map((json) => JournalEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
