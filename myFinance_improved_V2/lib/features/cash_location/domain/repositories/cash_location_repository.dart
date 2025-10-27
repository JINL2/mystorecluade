// Domain Layer - Repository Interface
// This defines WHAT operations are available, not HOW they are implemented

import '../entities/cash_location.dart';
import '../entities/cash_location_detail.dart';
import '../entities/cash_real_entry.dart';
import '../entities/bank_real_entry.dart';
import '../entities/vault_real_entry.dart';
import '../entities/journal_entry.dart';
import '../entities/stock_flow.dart';

/// Repository interface for cash location operations
/// Implementation will be in data layer
abstract class CashLocationRepository {
  /// Get all cash locations for a company and store
  Future<List<CashLocation>> getAllCashLocations({
    required String companyId,
    required String storeId,
  });

  /// Get single cash location by ID with full details
  Future<CashLocationDetail?> getCashLocationById({
    required String locationId,
  });

  /// Get single cash location by name and type
  Future<CashLocationDetail?> getCashLocationByName({
    required String locationName,
    required String locationType,
    required String companyId,
    required String storeId,
  });

  /// Get cash real entries
  Future<List<CashRealEntry>> getCashReal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  });

  /// Get bank real entries
  Future<List<BankRealEntry>> getBankReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  });

  /// Get vault real entries
  Future<List<VaultRealEntry>> getVaultReal({
    required String companyId,
    required String storeId,
    int offset = 0,
    int limit = 20,
  });

  /// Get cash journal entries
  Future<List<JournalEntry>> getCashJournal({
    required String companyId,
    required String storeId,
    required String locationType,
    int offset = 0,
    int limit = 20,
  });

  /// Get stock flow data for a specific cash location
  Future<StockFlowResponse> getLocationStockFlow({
    required String companyId,
    required String storeId,
    required String cashLocationId,
    int offset = 0,
    int limit = 20,
  });

  /// Insert journal entry with lines
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
  });

  /// Update cash location details
  Future<void> updateCashLocation({
    required String locationId,
    required String name,
    String? note,
    String? description,
    String? bankName,
    String? accountNumber,
  });

  /// Delete cash location
  Future<void> deleteCashLocation(String locationId);

  /// Update main account status (unsets other main accounts if setting as main)
  Future<void> updateMainAccountStatus({
    required String locationId,
    required bool isMain,
    required String companyId,
    required String storeId,
    required String locationType,
  });
}
