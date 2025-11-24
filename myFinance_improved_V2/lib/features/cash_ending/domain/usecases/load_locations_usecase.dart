// lib/features/cash_ending/domain/usecases/load_locations_usecase.dart

import '../entities/location.dart';
import '../repositories/location_repository.dart';

/// Parameters for LoadLocationsUseCase
class LoadLocationsParams {
  final String companyId;
  final String locationType;
  final String? storeId;

  const LoadLocationsParams({
    required this.companyId,
    required this.locationType,
    this.storeId,
  });
}

/// Result object for LoadLocationsUseCase
class LoadLocationsResult {
  final List<Location> locations;
  final String locationType;

  const LoadLocationsResult({
    required this.locations,
    required this.locationType,
  });
}

/// UseCase: Load locations by type
///
/// Business Logic:
/// - Load locations filtered by type (cash, bank, vault)
/// - Optionally filter by store
/// - Returns typed result for easier state management
class LoadLocationsUseCase {
  final LocationRepository _locationRepository;

  LoadLocationsUseCase(this._locationRepository);

  /// Execute the use case
  ///
  /// [params] - Parameters including company, type, and optional store filter
  ///
  /// Returns locations with their type for proper state updates
  Future<LoadLocationsResult> execute(LoadLocationsParams params) async {
    final locations = await _locationRepository.getLocationsByType(
      companyId: params.companyId,
      locationType: params.locationType,
      storeId: params.storeId,
    );

    return LoadLocationsResult(
      locations: locations,
      locationType: params.locationType,
    );
  }
}
