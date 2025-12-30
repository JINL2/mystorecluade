import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/monitoring/sentry_config.dart';
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
  /// [storeId] is optional - if null, returns all stores
  /// [locationType] is optional - if provided, filters by location type (cash, bank, vault)
  Future<List<CashLocationModel>> getAllCashLocations({
    required String companyId,
    String? storeId,
    String? locationType,
  }) async {
    try {
      var query = _supabase
          .from('v_cash_location')
          .select('*')
          .eq('company_id', companyId)
          .eq('is_deleted', false);

      // Apply optional filters
      if (storeId != null) {
        query = query.eq('store_id', storeId);
      }
      if (locationType != null) {
        query = query.eq('location_type', locationType);
      }

      final response = await query
          .order('location_type')
          .order('location_name');

      return (response as List)
          .map((json) => CashLocationModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to load cash locations',
        extra: {'companyId': companyId, 'storeId': storeId, 'locationType': locationType},
      );
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to load cash location by ID',
        extra: {'locationId': locationId},
      );
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to load cash location by name',
        extra: {'locationName': locationName, 'locationType': locationType},
      );
      throw Exception('Failed to load cash location: ${e.toString()}');
    }
  }

  /// Get cash locations using RPC for selectors
  /// This method is for cash location selectors in forms
  /// Returns all data - filtering should be done in domain/use case layer
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

      // Simply convert to models - no business logic filtering
      return response
          .map((json) => CashLocationRPCResponse.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to load cash locations for selector',
        extra: {'companyId': companyId},
      );
      throw Exception('Failed to load cash locations: ${e.toString()}');
    }
  }

  /// Get cash real entries using RPC (UTC version)
  Future<List<CashRealEntryModel>> getCashReal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_cash_real_utc',
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to get cash real entries',
        extra: {'companyId': companyId, 'storeId': storeId, 'offset': offset},
      );
      return [];
    }
  }

  /// Get bank real entries using RPC (UTC version)
  Future<List<BankRealEntryModel>> getBankReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_bank_real_utc',
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to get bank real entries',
        extra: {'companyId': companyId, 'storeId': storeId, 'offset': offset},
      );
      return [];
    }
  }

  /// Get vault real entries using RPC (UTC version)
  /// Returns all entries from the RPC - filtering should be done in domain/use case layer
  Future<List<VaultRealEntryModel>> getVaultReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'get_vault_real_utc',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      // Simply convert to models - no business logic filtering
      return response
          .map((json) => VaultRealEntryModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to get vault real entries',
        extra: {'companyId': companyId, 'storeId': storeId, 'offset': offset},
      );
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to get cash journal entries',
        extra: {'companyId': companyId, 'storeId': storeId, 'locationType': locationType},
      );
      return [];
    }
  }

  /// Get location stock flow data using RPC (UTC version)
  Future<StockFlowResponse> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'get_location_stock_flow_v2_utc',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_cash_location_id': cashLocationId,
          'p_offset': offset,
          'p_limit': limit,
        },
      );

      return StockFlowResponseModel.fromJson(response);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to fetch stock flow data',
        extra: {'companyId': companyId, 'cashLocationId': cashLocationId, 'offset': offset},
      );
      throw Exception('Failed to fetch stock flow data: $e');
    }
  }

  /// Insert journal entry with lines using RPC (UTC version)
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
        'insert_journal_with_everything_utc',
        params: {
          'p_base_amount': baseAmount,
          'p_company_id': companyId,
          'p_created_by': createdBy,
          'p_description': description,
          'p_entry_date_utc': entryDate,
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to insert journal',
        extra: {'companyId': companyId, 'description': description, 'baseAmount': baseAmount},
      );
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
    // Trade/International banking fields
    String? beneficiaryName,
    String? bankAddress,
    String? swiftCode,
    String? bankBranch,
    String? accountType,
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

      // Trade/International banking fields
      if (beneficiaryName != null && beneficiaryName.isNotEmpty) {
        data['beneficiary_name'] = beneficiaryName;
      }
      if (bankAddress != null && bankAddress.isNotEmpty) {
        data['bank_address'] = bankAddress;
      }
      if (swiftCode != null && swiftCode.isNotEmpty) {
        data['swift_code'] = swiftCode;
      }
      if (bankBranch != null && bankBranch.isNotEmpty) {
        data['bank_branch'] = bankBranch;
      }
      if (accountType != null && accountType.isNotEmpty) {
        data['account_type'] = accountType;
      }

      await _supabase.from('cash_locations').insert(data);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to create cash location',
        extra: {'locationName': locationName, 'locationType': locationType},
      );
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
    // Trade/International banking fields
    String? beneficiaryName,
    String? bankAddress,
    String? swiftCode,
    String? bankBranch,
    String? accountType,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'location_name': name,
      };

      // Add optional fields only if provided
      if (note != null) updateData['note'] = note;
      if (description != null) updateData['description'] = description;
      if (bankName != null) updateData['bank_name'] = bankName;
      if (accountNumber != null) updateData['bank_account'] = accountNumber;

      // Trade/International banking fields
      if (beneficiaryName != null) updateData['beneficiary_name'] = beneficiaryName;
      if (bankAddress != null) updateData['bank_address'] = bankAddress;
      if (swiftCode != null) updateData['swift_code'] = swiftCode;
      if (bankBranch != null) updateData['bank_branch'] = bankBranch;
      if (accountType != null) updateData['account_type'] = accountType;

      await _supabase
          .from('cash_locations')
          .update(updateData)
          .eq('cash_location_id', locationId);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to update cash location',
        extra: {'locationId': locationId, 'name': name},
      );
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
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to delete cash location',
        extra: {'locationId': locationId},
      );
      throw Exception('Failed to delete cash location: ${e.toString()}');
    }
  }

  /// Get the current main account for a location type
  Future<CashLocationDetailModel?> getMainAccount({
    required String companyId,
    required String storeId,
    required String locationType,
  }) async {
    try {
      final response = await _supabase
          .from('cash_locations')
          .select('*')
          .eq('company_id', companyId)
          .eq('store_id', storeId)
          .eq('location_type', locationType)
          .eq('main_cash_location', true)
          .maybeSingle();

      if (response == null) return null;

      return CashLocationDetailModel.fromJson(response);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to get main account',
        extra: {'companyId': companyId, 'storeId': storeId, 'locationType': locationType},
      );
      throw Exception('Failed to get main account: ${e.toString()}');
    }
  }

  /// Update a single account's main status (simple CRUD, no business logic)
  Future<void> updateAccountMainStatus({
    required String locationId,
    required bool isMain,
  }) async {
    try {
      await _supabase
          .from('cash_locations')
          .update({
            'main_cash_location': isMain,
          })
          .eq('cash_location_id', locationId);
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to update account main status',
        extra: {'locationId': locationId, 'isMain': isMain},
      );
      throw Exception('Failed to update account main status: ${e.toString()}');
    }
  }

  /// Batch update multiple accounts' main status
  Future<void> batchUpdateMainStatus({
    required List<String> locationIds,
    required List<bool> isMainValues,
  }) async {
    try {
      for (var i = 0; i < locationIds.length; i++) {
        await updateAccountMainStatus(
          locationId: locationIds[i],
          isMain: isMainValues[i],
        );
      }
    } catch (e, stackTrace) {
      SentryConfig.captureException(
        e,
        stackTrace,
        hint: 'CashLocation: Failed to batch update main status',
        extra: {'locationCount': locationIds.length},
      );
      throw Exception('Failed to batch update main status: ${e.toString()}');
    }
  }
}
