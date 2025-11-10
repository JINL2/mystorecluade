// lib/features/cash_ending/domain/repositories/vault_repository.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../entities/vault_transaction.dart';

/// Repository interface for vault transaction operations
///
/// This is a domain layer contract that defines how vault transaction data
/// should be accessed. The actual implementation is in the data layer.
///
/// ✅ Strong Typing:
/// - Uses Result<T, Failure> for type-safe error handling
/// - Compile-time guarantee of error handling
/// - Clear distinction between success and failure cases
abstract class VaultRepository {
  /// Save vault transaction record
  ///
  /// [vaultTransaction] The vault transaction entity to save
  ///
  /// Returns:
  /// - Success<VaultTransaction>: Saved vault transaction entity
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid data
  Future<result_type.Result<VaultTransaction, Failure>> saveVaultTransaction(VaultTransaction vaultTransaction);
}
