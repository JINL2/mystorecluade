// lib/features/cash_ending/domain/repositories/bank_repository.dart

import '../entities/bank_balance.dart';
import '../entities/balance_summary.dart';

/// Repository interface for Bank operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class BankRepository {
  /// Save bank balance record
  ///
  /// Returns void on success
  /// Throws exception on failure
  Future<void> saveBankBalance(BankBalance balance);

  /// Get balance summary (Journal vs Real) for bank location
  ///
  /// Returns balance comparison showing:
  /// - Total Journal (book balance)
  /// - Total Real (actual bank amount)
  /// - Difference
  /// Throws exception on failure
  Future<BalanceSummary> getBalanceSummary({
    required String locationId,
  });
}
