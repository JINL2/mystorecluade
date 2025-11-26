// lib/features/cash_ending/domain/usecases/save_vault_transaction_usecase.dart

import '../entities/vault_transaction.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/vault_repository.dart';

/// UseCase: Save vault transaction with validation
///
/// Business Logic:
/// - Validate vault transaction before saving
/// - Ensure all required fields are present
/// - Verify transaction type (credit/debit) is valid
class SaveVaultTransactionUseCase {
  final VaultRepository _repository;

  SaveVaultTransactionUseCase(this._repository);

  /// Execute the use case
  ///
  /// [transaction] - The vault transaction to save
  ///
  /// Throws [ValidationException] if validation fails
  Future<void> execute(VaultTransaction transaction) async {
    // Business Rule: Validate before saving
    _validate(transaction);

    // Save to repository
    await _repository.saveVaultTransaction(transaction);
  }

  /// Validate vault transaction business rules
  void _validate(VaultTransaction transaction) {
    // Rule 1: Must have valid company ID
    if (transaction.companyId.isEmpty) {
      throw ValidationException('Company ID is required');
    }

    // Rule 2: Must have valid location ID
    if (transaction.locationId.isEmpty) {
      throw ValidationException('Location ID is required');
    }

    // Rule 3: Must have valid user ID
    if (transaction.userId.isEmpty) {
      throw ValidationException('User ID is required');
    }

    // Rule 4: Must have at least one currency
    if (transaction.currencies.isEmpty) {
      throw ValidationException('Vault transaction must have at least one currency');
    }

    // Rule 5: Must have actual data
    if (!transaction.hasData) {
      throw ValidationException('Vault transaction must have data (at least one currency with amount > 0)');
    }

    // Rule 6: Total amount must be greater than 0
    if (transaction.totalAmount <= 0) {
      throw ValidationException('Vault transaction amount must be greater than 0');
    }
  }
}
