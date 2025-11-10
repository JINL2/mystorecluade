// lib/features/cash_ending/domain/repositories/cash_ending_repository.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../entities/cash_ending.dart';

/// Repository interface for Cash Ending operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
///
/// ✅ Strong Typing:
/// - Uses Result<T, Failure> for type-safe error handling
/// - Compile-time guarantee of error handling
/// - Clear distinction between success and failure cases
abstract class CashEndingRepository {
  /// Save a cash ending record
  ///
  /// Returns:
  /// - Success<CashEnding>: Saved entity with generated ID
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid data
  Future<result_type.Result<CashEnding, Failure>> saveCashEnding(CashEnding cashEnding);

  /// Get recent cash ending history for a location
  ///
  /// Returns:
  /// - Success<List<CashEnding>>: List of cash ending records ordered by date descending
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid location ID
  Future<result_type.Result<List<CashEnding>, Failure>> getCashEndingHistory({
    required String locationId,
    int limit = 10,
  });
}
