// lib/features/cash_ending/domain/usecases/save_bank_balance_usecase.dart

import '../entities/bank_balance.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/bank_repository.dart';

/// UseCase: Save bank balance with validation
///
/// Business Logic:
/// - Validate bank balance before saving
/// - Ensure all required fields are present
/// - Check that there is actual data to save
class SaveBankBalanceUseCase {
  final BankRepository _repository;

  SaveBankBalanceUseCase(this._repository);

  /// Execute the use case
  ///
  /// [bankBalance] - The bank balance to save
  ///
  /// Throws [ValidationException] if validation fails
  Future<void> execute(BankBalance bankBalance) async {
    // Business Rule: Validate before saving
    _validate(bankBalance);

    // Save to repository
    await _repository.saveBankBalance(bankBalance);
  }

  /// Validate bank balance business rules
  void _validate(BankBalance bankBalance) {
    // Rule 1: Must have valid company ID
    if (bankBalance.companyId.isEmpty) {
      throw ValidationException('Company ID is required');
    }

    // Rule 2: Must have valid location ID
    if (bankBalance.locationId.isEmpty) {
      throw ValidationException('Location ID is required');
    }

    // Rule 3: Must have valid user ID
    if (bankBalance.userId.isEmpty) {
      throw ValidationException('User ID is required');
    }

    // Rule 4: Must have at least one currency
    if (bankBalance.currencies.isEmpty) {
      throw ValidationException('At least one currency is required');
    }

    // Rule 5: User must have explicitly entered a value (including 0)
    // This distinguishes between "not entered" vs "explicitly set to 0"
    if (!bankBalance.hasInput) {
      throw ValidationException('Please enter a bank balance amount');
    }
  }
}
