// Domain Layer - Repository Interface
// This defines WHAT operations are available, not HOW they are implemented

import '../entities/bank_real_entry.dart';
import '../entities/cash_location.dart';
import '../entities/cash_location_detail.dart';
import '../entities/cash_real_entry.dart';
import '../entities/journal_entry.dart';
import '../entities/stock_flow.dart';
import '../entities/vault_real_entry.dart';

/// Repository interface for cash location operations
/// Implementation will be in data layer
abstract class CashLocationRepository {
  /// Get all cash locations for a company and store
  /// [storeId] is optional - if null, returns all stores
  /// [locationType] is optional - if provided, filters by location type (cash, bank, vault)
  Future<List<CashLocation>> getAllCashLocations({
    required String companyId,
    String? storeId,
    String? locationType,
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
  });

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
  });

  /// Delete cash location
  Future<void> deleteCashLocation(String locationId);

  /// Get the current main account for a location type
  Future<CashLocationDetail?> getMainAccount({
    required String companyId,
    required String storeId,
    required String locationType,
  });

  /// Update a single account's main status (without business logic)
  Future<void> updateAccountMainStatus({
    required String locationId,
    required bool isMain,
  });

  /// Batch update multiple accounts' main status
  Future<void> batchUpdateMainStatus({
    required List<String> locationIds,
    required List<bool> isMainValues,
  });
}
