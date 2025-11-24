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

  /// Get recent cash ending history for a location
  ///
  /// Returns list of cash ending records ordered by date descending
  /// Returns empty list if no records found
  Future<List<CashEnding>> getCashEndingHistory({
    required String locationId,
    int limit = 10,
  });

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

  /// Get balance summary for multiple locations
  ///
  /// Useful for dashboard or overview screens
  /// Returns list of balance summaries
  /// Throws CashEndingException on failure
  Future<List<BalanceSummary>> getMultipleBalanceSummary({
    required List<String> locationIds,
  });
}
