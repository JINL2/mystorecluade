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

  /// Get all cash locations (all types) with balance information
  /// Uses RPC to get cash amounts for cash location page
  /// [storeId] is optional - if null, returns all stores
  /// [locationType] is optional - if provided, filters by location type (cash, bank, vault)
  Future<List<CashLocationModel>> getAllCashLocations({
    required String companyId,
    String? storeId,
    String? locationType,
  }) async {
    try {
      final response = await _supabase.rpc<List<dynamic>>(
        'cash_location_get_cash_locations_with_balance',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_location_type': locationType,
        },
      );

      return response
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
  /// Uses RPC: cash_location_get_info (BY ID mode)
  Future<CashLocationDetailModel?> getCashLocationById({
    required String locationId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'cash_location_get_info',
        params: {
          'p_cash_location_id': locationId,
        },
      );

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
  /// Uses RPC: cash_location_get_info (BY NAME mode)
  Future<CashLocationDetailModel?> getCashLocationByName({
    required String locationName,
    required String locationType,
    required String companyId,
    required String storeId,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'cash_location_get_info',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_location_name': locationName,
          'p_location_type': locationType,
        },
      );

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
  /// Uses RPC: cash_location_manage_cash_location (INSERT mode)
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
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'cash_location_manage_cash_location',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_location_name': locationName,
          'p_location_type': locationType,
          'p_bank_name': bankName,
          'p_bank_account': accountNumber,
          'p_currency_id': currencyId,
          'p_location_info': locationInfo,
          'p_beneficiary_name': beneficiaryName,
          'p_bank_address': bankAddress,
          'p_swift_code': swiftCode,
          'p_bank_branch': bankBranch,
          'p_account_type': accountType,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Unknown error');
      }
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
  /// Uses RPC: cash_location_manage_cash_location (UPDATE mode)
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
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'cash_location_manage_cash_location',
        params: {
          'p_cash_location_id': locationId,
          'p_location_name': name,
          'p_note': note,
          'p_bank_name': bankName,
          'p_bank_account': accountNumber,
          'p_beneficiary_name': beneficiaryName,
          'p_bank_address': bankAddress,
          'p_swift_code': swiftCode,
          'p_bank_branch': bankBranch,
          'p_account_type': accountType,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Unknown error');
      }
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
      await _supabase.rpc<void>(
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
  /// Uses RPC: cash_location_get_info (BY MAIN mode)
  Future<CashLocationDetailModel?> getMainAccount({
    required String companyId,
    required String storeId,
    required String locationType,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>?>(
        'cash_location_get_info',
        params: {
          'p_company_id': companyId,
          'p_store_id': storeId,
          'p_location_type': locationType,
          'p_main_only': true,
        },
      );

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
  /// Uses RPC: cash_location_manage_cash_location (UPDATE mode)
  Future<void> updateAccountMainStatus({
    required String locationId,
    required bool isMain,
  }) async {
    try {
      final response = await _supabase.rpc<Map<String, dynamic>>(
        'cash_location_manage_cash_location',
        params: {
          'p_cash_location_id': locationId,
          'p_main_cash_location': isMain,
        },
      );

      if (response['success'] != true) {
        throw Exception(response['message'] ?? 'Unknown error');
      }
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
}
