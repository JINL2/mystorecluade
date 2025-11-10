// lib/features/cash_ending/domain/repositories/bank_repository.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../entities/bank_balance.dart';

/// Repository interface for bank balance operations
///
/// This is a domain layer contract that defines how bank balance data
/// should be accessed. The actual implementation is in the data layer.
///
/// ✅ Strong Typing:
/// - Uses Result<T, Failure> for type-safe error handling
/// - Compile-time guarantee of error handling
/// - Clear distinction between success and failure cases
abstract class BankRepository {
  /// Save bank balance record
  ///
  /// [bankBalance] The bank balance entity to save
  ///
  /// Returns:
  /// - Success<BankBalance>: Saved bank balance entity
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid data
  Future<result_type.Result<BankBalance, Failure>> saveBankBalance(BankBalance bankBalance);
}
