// lib/features/cash_ending/domain/usecases/recount_vault_usecase.dart

import '../entities/vault_recount.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/vault_repository.dart';

/// UseCase: Perform vault recount (Stock to Flow conversion)
///
/// Business Logic:
/// - Validate recount data before processing
/// - Ensure all required fields are present
/// - Verify that denominations are provided
/// - Execute recount operation via repository
class RecountVaultUseCase {
  final VaultRepository _repository;

  RecountVaultUseCase(this._repository);

  /// Execute the use case
  ///
  /// [recount] - The vault recount data (stock count)
  ///
  /// Returns a map with adjustment details:
  /// - success: bool
  /// - adjustment_count: int
  /// - total_variance: num
  /// - adjustments: List<Map>
  ///
  /// Throws [ValidationException] if validation fails
  Future<Map<String, dynamic>> execute(VaultRecount recount) async {
    // Business Rule: Validate before recount
    _validate(recount);

    // Execute recount via repository
    return await _repository.recountVault(recount);
  }

  /// Validate vault recount business rules
  void _validate(VaultRecount recount) {
    // Rule 1: Must have valid company ID
    if (recount.companyId.isEmpty) {
      throw ValidationException('Company ID is required');
    }

    // Rule 2: Must have valid location ID
    if (recount.locationId.isEmpty) {
      throw ValidationException('Location ID is required');
    }

    // Rule 3: Must have valid user ID
    if (recount.userId.isEmpty) {
      throw ValidationException('User ID is required');
    }

    // Rule 4: Must have valid currency ID
    if (recount.currencyId.isEmpty) {
      throw ValidationException('Currency ID is required');
    }

    // Rule 5: Must have denominations
    if (recount.denominations.isEmpty) {
      throw ValidationException('Recount must have at least one denomination');
    }

    // Rule 6: At least one denomination must have quantity > 0
    final hasValidDenomination = recount.denominations.any(
      (d) => d.quantity > 0,
    );

    if (!hasValidDenomination) {
      throw ValidationException('Recount must have at least one denomination with quantity > 0');
    }
  }
}
