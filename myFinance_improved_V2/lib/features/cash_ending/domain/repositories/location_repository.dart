// lib/features/cash_ending/domain/repositories/location_repository.dart

import '../../../../core/errors/failures.dart';
import '../../../../core/types/result.dart' as result_type;
import '../entities/location.dart';
import '../entities/store.dart';

/// Repository interface for Location operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
///
/// ✅ Strong Typing:
/// - Uses Result<T, Failure> for type-safe error handling
/// - Compile-time guarantee of error handling
/// - Clear distinction between success and failure cases
abstract class LocationRepository {
  /// Get all stores for a company
  ///
  /// Returns:
  /// - Success<List<Store>>: List of stores
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid company ID
  Future<result_type.Result<List<Store>, Failure>> getStores(String companyId);

  /// Get locations by type (cash, bank, vault)
  ///
  /// [companyId] - Required company identifier
  /// [locationType] - Type of location: 'cash', 'bank', or 'vault'
  /// [storeId] - Optional store filter (null for headquarter)
  ///
  /// Returns:
  /// - Success<List<Location>>: List of locations matching criteria
  /// - Failure<NetworkFailure>: Network connection issues
  /// - Failure<ServerFailure>: Database/server errors
  /// - Failure<ValidationFailure>: Invalid parameters
  Future<result_type.Result<List<Location>, Failure>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  });
}
