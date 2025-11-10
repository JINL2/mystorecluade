// lib/features/cash_ending/domain/repositories/currency_repository.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../entities/currency.dart';
import '../entities/denomination.dart';

/// Repository interface for Currency operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
///
/// ✅ Strong Typing:
/// - Uses Result<T, Failure> for type-safe error handling
/// - Compile-time guarantee of error handling
/// - Clear distinction between success and failure cases
abstract class CurrencyRepository {
  /// Get all active currencies for a company
  ///
  /// Returns:
  /// - Success<List<Currency>>: List of currencies with their denominations
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid company ID
  Future<result_type.Result<List<Currency>, Failure>> getCompanyCurrencies(String companyId);

  /// Get denominations for a specific currency
  ///
  /// Returns:
  /// - Success<List<Denomination>>: List of denominations ordered by value descending
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid parameters
  Future<result_type.Result<List<Denomination>, Failure>> getDenominationsByCurrency({
    required String companyId,
    required String currencyId,
  });

  /// Get all currency types available in the system
  ///
  /// This fetches the master list of currency types (KRW, USD, etc.)
  ///
  /// Returns:
  /// - Success<List<Currency>>: List of all currency types
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  Future<result_type.Result<List<Currency>, Failure>> getAllCurrencyTypes();
}
