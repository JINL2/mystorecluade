// lib/features/cash_ending/domain/repositories/cash_ending_repository.dart

import '../entities/cash_ending.dart';
import '../entities/balance_summary.dart';

/// Repository interface for Cash Ending operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class CashEndingRepository {
  /// Save a cash ending record
  ///
  /// Returns the saved entity with generated ID
  /// Throws CashEndingException on failure
  Future<CashEnding> saveCashEnding(CashEnding cashEnding);

  /// Get balance summary (Journal vs Real) for a location
  ///
  /// Returns balance comparison data showing:
  /// - Total Journal (book balance)
  /// - Total Real (actual cash count)
  /// - Difference
  /// Throws CashEndingException on failure
  Future<BalanceSummary> getBalanceSummary({
    required String locationId,
  });
}
