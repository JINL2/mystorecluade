// lib/features/cash_ending/domain/repositories/vault_repository.dart

import '../entities/vault_transaction.dart';

/// Repository interface for Vault operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class VaultRepository {
  /// Save vault transaction record (deposit or withdrawal)
  ///
  /// Returns void on success
  /// Throws exception on failure
  Future<void> saveVaultTransaction(VaultTransaction transaction);

  /// Get recent vault transaction history for a location
  ///
  /// Returns list of vault transactions ordered by date descending
  /// Returns empty list if no records found
  Future<List<VaultTransaction>> getVaultTransactionHistory({
    required String locationId,
    int limit = 10,
  });
}
