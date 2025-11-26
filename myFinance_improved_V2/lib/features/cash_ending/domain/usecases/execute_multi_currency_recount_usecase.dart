// lib/features/cash_ending/domain/usecases/execute_multi_currency_recount_usecase.dart

import '../entities/multi_currency_recount.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/vault_repository.dart';

/// UseCase: Execute multi-currency vault recount
///
/// Business Logic:
/// - Validate MultiCurrencyRecount entity
/// - Ensure all required fields are present
/// - Verify currency recounts are not empty
/// - Execute multi-currency recount via repository
///
/// ✅ Now uses type-safe MultiCurrencyRecount entity instead of Map
///
/// This is more efficient than calling RecountVaultUseCase multiple times
/// as it performs all currency recounts in a single RPC call
class ExecuteMultiCurrencyRecountUseCase {
  final VaultRepository _repository;

  ExecuteMultiCurrencyRecountUseCase(this._repository);

  /// Execute the use case
  ///
  /// [recount] - MultiCurrencyRecount entity containing all currencies
  ///
  /// Returns void (RPC returns null on success)
  /// Throws [ValidationException] if validation fails
  Future<void> execute(MultiCurrencyRecount recount) async {
    // Business Rule: Validate entity
    final validationError = recount.validate();
    if (validationError != null) {
      throw ValidationException(validationError);
    }

    // Execute multi-currency recount via repository
    await _repository.executeMultiCurrencyRecount(recount);
  }
}
