// lib/features/cash_ending/domain/usecases/select_store_usecase.dart

import '../entities/location.dart';
import '../repositories/location_repository.dart';

/// Result object for SelectStoreUseCase
class SelectStoreResult {
  final List<Location> cashLocations;
  final List<Location> bankLocations;
  final List<Location> vaultLocations;

  const SelectStoreResult({
    required this.cashLocations,
    required this.bankLocations,
    required this.vaultLocations,
  });
}

/// UseCase: Select a store and load all associated locations
///
/// Business Logic:
/// - When a user selects a store, automatically load all location types
/// - Load cash, bank, and vault locations in parallel for efficiency
/// - This is a coordinated operation across multiple location types
class SelectStoreUseCase {
  final LocationRepository _locationRepository;

  SelectStoreUseCase(this._locationRepository);

  /// Execute the use case
  ///
  /// [storeId] - The selected store ID
  /// [companyId] - The company ID for filtering
  ///
  /// Returns all location types for the selected store
  Future<SelectStoreResult> execute({
    required String storeId,
    required String companyId,
  }) async {
    // Business Rule: Load all location types in parallel
    // This improves performance and ensures consistency
    final results = await Future.wait([
      _locationRepository.getLocationsByType(
        companyId: companyId,
        locationType: 'cash',
        storeId: storeId,
      ),
      _locationRepository.getLocationsByType(
        companyId: companyId,
        locationType: 'bank',
        storeId: storeId,
      ),
      _locationRepository.getLocationsByType(
        companyId: companyId,
        locationType: 'vault',
        storeId: storeId,
      ),
    ]);

    return SelectStoreResult(
      cashLocations: results[0],
      bankLocations: results[1],
      vaultLocations: results[2],
    );
  }
}
