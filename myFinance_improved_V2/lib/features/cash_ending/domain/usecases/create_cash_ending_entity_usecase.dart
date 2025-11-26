// lib/features/cash_ending/domain/usecases/create_cash_ending_entity_usecase.dart

import '../entities/cash_ending.dart';
import '../entities/currency.dart';
import '../exceptions/validation_exception.dart';
import '../services/time_provider.dart';

/// UseCase: Create CashEnding entity with business rules
///
/// Business Logic:
/// - Apply timestamp from TimeProvider (testable)
/// - Validate required fields
/// - Filter out currencies without data
/// - Create immutable entity
///
/// This keeps entity creation logic out of Presentation layer
class CreateCashEndingEntityUseCase {
  final TimeProvider _timeProvider;

  CreateCashEndingEntityUseCase(this._timeProvider);

  /// Execute the use case
  ///
  /// Returns a valid CashEnding entity ready to be saved
  /// Throws [ValidationException] if validation fails
  CashEnding execute({
    required String companyId,
    required String locationId,
    required String userId,
    String? storeId,
    required List<Currency> currencies,
  }) {
    // Business Rule: Validate inputs
    _validate(
      companyId: companyId,
      locationId: locationId,
      userId: userId,
      currencies: currencies,
    );

    // Business Rule: Use TimeProvider for consistent, testable time
    final now = _timeProvider.now();

    // Business Rule: Filter currencies to only those with data
    final currenciesWithData = currencies.where((c) => c.hasData).toList();

    if (currenciesWithData.isEmpty) {
      throw ValidationException('At least one currency must have denomination data');
    }

    // Create entity
    return CashEnding(
      companyId: companyId,
      locationId: locationId,
      storeId: storeId,
      userId: userId,
      recordDate: now,
      createdAt: now,
      currencies: currenciesWithData,
    );
  }

  /// Validate business rules
  void _validate({
    required String companyId,
    required String locationId,
    required String userId,
    required List<Currency> currencies,
  }) {
    if (companyId.isEmpty) {
      throw ValidationException('Company ID is required');
    }

    if (locationId.isEmpty) {
      throw ValidationException('Location ID is required');
    }

    if (userId.isEmpty) {
      throw ValidationException('User ID is required');
    }

    if (currencies.isEmpty) {
      throw ValidationException('At least one currency is required');
    }
  }
}
