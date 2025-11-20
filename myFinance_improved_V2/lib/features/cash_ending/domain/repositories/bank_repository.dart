// lib/features/cash_ending/domain/repositories/bank_repository.dart

import '../entities/bank_balance.dart';

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

  /// Get recent bank balance history for a location
  ///
  /// Returns list of bank balance records ordered by date descending
  /// Returns empty list if no records found
  Future<List<BankBalance>> getBankBalanceHistory({
    required String locationId,
    int limit = 10,
  });
}
