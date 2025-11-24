// lib/features/cash_ending/domain/repositories/vault_repository.dart

import '../entities/vault_transaction.dart';
import '../entities/vault_recount.dart';
import '../entities/balance_summary.dart';

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

  /// Perform vault recount (Stock to Flow conversion)
  ///
  /// Takes actual stock count and converts it to flow adjustments.
  /// The RPC function will:
  /// 1. Calculate system stock from flow data
  /// 2. Compare with actual stock
  /// 3. Insert adjustment transactions for the difference
  ///
  /// Returns a map with adjustment details:
  /// {
  ///   'success': bool,
  ///   'adjustment_count': int,
  ///   'total_variance': num,
  ///   'adjustments': List<Map>
  /// }
  ///
  /// Throws exception on failure
  Future<Map<String, dynamic>> recountVault(VaultRecount recount);

  /// Get recent vault transaction history for a location
  ///
  /// Returns list of vault transactions ordered by date descending
  /// Returns empty list if no records found
  Future<List<VaultTransaction>> getVaultTransactionHistory({
    required String locationId,
    int limit = 10,
  });

  /// Get balance summary (Journal vs Real) for vault location
  ///
  /// Returns balance comparison showing:
  /// - Total Journal (book balance)
  /// - Total Real (actual vault amount)
  /// - Difference
  /// Throws exception on failure
  Future<BalanceSummary> getBalanceSummary({
    required String locationId,
  });

  /// Execute multi-currency RECOUNT (all currencies in one RPC call)
  ///
  /// This is a specialized method that bypasses entity conversion
  /// and directly calls the RPC with pre-built parameters.
  ///
  /// More efficient than calling recountVault() multiple times
  /// because it creates a single cash_amount_entry for all currencies.
  ///
  /// RPC Parameters:
  /// - p_entry_type: 'vault'
  /// - p_vault_transaction_type: 'recount'
  /// - p_currencies: [{ currency_id, denominations: [...] }, ...]
  ///
  /// Throws exception on failure
  Future<void> executeMultiCurrencyRecount(Map<String, dynamic> rpcParams);
}
