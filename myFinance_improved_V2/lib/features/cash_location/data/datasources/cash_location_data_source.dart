import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/entities/stock_flow.dart';
import '../models/bank_real_model.dart';
import '../models/cash_location_detail_model.dart';
import '../models/cash_location_model.dart';
import '../models/cash_real_model.dart';
import '../models/journal_entry_model.dart';
import '../models/stock_flow_model.dart';
import '../models/vault_real_model.dart';

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

  /// Get single cash location by ID with full details
  Future<CashLocationDetailModel?> getCashLocationById({
    required String locationId,
  }) async {
    try {
      final response = await _supabase
          .from('cash_locations')
          .select('*')
          .eq('cash_location_id', locationId)
          .maybeSingle();

      if (response == null) return null;

      return CashLocationDetailModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load cash location: ${e.toString()}');
    }
  }

  /// Get single cash location by name and type
  Future<CashLocationDetailModel?> getCashLocationByName({
    required String locationName,
    required String locationType,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase
          .from('cash_locations')
          .select('*')
          .eq('location_name', locationName)
          .eq('location_type', locationType)
          .eq('company_id', companyId)
          .eq('store_id', storeId)
          .maybeSingle();

      if (response == null) return null;

      return CashLocationDetailModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to load cash location: ${e.toString()}');
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
      final response = await _supabase.rpc<List<dynamic>>(
        'get_cash_journal',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      return response
          .map((json) => JournalEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  /// Get location stock flow data using RPC
  Future<StockFlowResponse> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'get_location_stock_flow_v2',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_cash_location_id': cashLocationId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      return StockFlowResponseModel.fromJson(response);
    } catch (e) {
      throw Exception('Failed to fetch stock flow data: $e');
    }
  }

  /// Insert journal entry with lines using RPC
  Future<Map<String, dynamic>> insertJournalWithEverything({
    required double baseAmount,
    required String companyId,
    required String createdBy,
    required String description,
    required String entryDate,
    required List<Map<String, dynamic>> lines,
    String? counterpartyId,
    String? ifCashLocationId,
    String? storeId,
  }) async {
    try {
      final response = await _supabase.rpc<dynamic>(
        'insert_journal_with_everything',
        params: {
          'p_base_amount': baseAmount,
          'p_company_id': companyId,
          'p_created_by': createdBy,
          'p_description': description,
          'p_entry_date': entryDate,
          'p_lines': lines,
          'p_counterparty_id': counterpartyId,
          'p_if_cash_location_id': ifCashLocationId,
          'p_store_id': storeId,
        },
      );

      return {
        'success': true,
        'data': response,
      };
    } catch (e) {
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Create a new cash location
  Future<void> createCashLocation({
    required String companyId,
    required String storeId,
    required String locationName,
    required String locationType,
    String? bankName,
    String? accountNumber,
    String? currencyId,
    String? locationInfo,
  }) async {
    try {
      final data = <String, dynamic>{
        'company_id': companyId,
        'store_id': storeId,
        'location_name': locationName,
        'location_type': locationType,
      };

      if (bankName != null) data['bank_name'] = bankName;
      if (accountNumber != null) data['bank_account'] = accountNumber;
      if (currencyId != null) data['currency_id'] = currencyId;
      if (locationInfo != null) data['location_info'] = locationInfo;

      await _supabase.from('cash_locations').insert(data);
    } catch (e) {
      throw Exception('Failed to create cash location: ${e.toString()}');
    }
  }

  /// Update cash location details
  Future<void> updateCashLocation({
    required String locationId,
    required String name,
    String? note,
    String? description,
    String? bankName,
    String? accountNumber,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'name': name,
        'updated_at': DateTime.now().toUtc().toIso8601String(),
      };

      // Add optional fields only if provided
      if (note != null) updateData['note'] = note;
      if (description != null) updateData['description'] = description;
      if (bankName != null) updateData['bank_name'] = bankName;
      if (accountNumber != null) updateData['account_number'] = accountNumber;

      await _supabase
          .from('cash_locations')
          .update(updateData)
          .eq('id', locationId);
    } catch (e) {
      throw Exception('Failed to update cash location: ${e.toString()}');
    }
  }

  /// Delete cash location (soft delete by setting is_deleted = true)
  Future<void> deleteCashLocation(String locationId) async {
    try {
      // Use RPC to delete cash location
      await _supabase.rpc(
        'delete_cash_location',
        params: {
          'p_cash_location_id': locationId,
        },
      );
    } catch (e) {
      throw Exception('Failed to delete cash location: ${e.toString()}');
    }
  }

  /// Update main account status (unsets other main accounts if setting as main)
  Future<void> updateMainAccountStatus({
    required String locationId,
    required bool isMain,
    required String companyId,
    required String storeId,
    required String locationType,
  }) async {
    try {
      // If setting as main, first unset any existing main account
      if (isMain) {
        await _supabase
            .from('cash_locations')
            .update({'main_cash_location': false})
            .eq('company_id', companyId)
            .eq('store_id', storeId)
            .eq('location_type', locationType);
      }

      // Update the current account
      await _supabase
          .from('cash_locations')
          .update({
            'main_cash_location': isMain,
            'updated_at': DateTime.now().toUtc().toIso8601String(),
          })
          .eq('cash_location_id', locationId);
    } catch (e) {
      throw Exception('Failed to update main account status: ${e.toString()}');
    }
  }
}
