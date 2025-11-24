// lib/features/cash_ending/domain/usecases/save_cash_ending_usecase.dart

import '../entities/cash_ending.dart';
import '../exceptions/validation_exception.dart';
import '../repositories/cash_ending_repository.dart';

/// UseCase: Save cash ending with validation
///
/// Business Logic:
/// - Validate cash ending before saving
/// - Ensure all required fields are present
/// - Check that there is actual data to save
class SaveCashEndingUseCase {
  final CashEndingRepository _repository;

  SaveCashEndingUseCase(this._repository);

  /// Execute the use case
  ///
  /// [cashEnding] - The cash ending to save
  ///
  /// Returns the saved cash ending
  /// Throws [ValidationException] if validation fails
  Future<CashEnding> execute(CashEnding cashEnding) async {
    // Business Rule: Validate before saving
    _validate(cashEnding);

    // Save to repository
    return await _repository.saveCashEnding(cashEnding);
  }

  /// Validate cash ending business rules
  void _validate(CashEnding cashEnding) {
    // Rule 1: Must have valid company ID
    if (cashEnding.companyId.isEmpty) {
      throw ValidationException('Company ID is required');
    }

    // Rule 2: Must have valid location ID
    if (cashEnding.locationId.isEmpty) {
      throw ValidationException('Location ID is required');
    }

    // Rule 3: Must have valid user ID
    if (cashEnding.userId.isEmpty) {
      throw ValidationException('User ID is required');
    }

    // Rule 4: Must have actual data (at least one denomination with quantity)
    if (!cashEnding.hasData) {
      throw ValidationException('Cash ending must have at least one denomination with quantity');
    }
  }
}
