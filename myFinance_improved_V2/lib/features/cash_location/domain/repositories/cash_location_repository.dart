// Domain Layer - Repository Interface
// This defines WHAT operations are available, not HOW they are implemented

import '../entities/cash_location.dart';
import '../entities/cash_real_entry.dart';
import '../entities/bank_real_entry.dart';
import '../entities/vault_real_entry.dart';
import '../entities/journal_entry.dart';

/// Repository interface for cash location operations
/// Implementation will be in data layer
abstract class CashLocationRepository {
  /// Get all cash locations for a company and store
  Future<List<CashLocation>> getAllCashLocations({
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
}
