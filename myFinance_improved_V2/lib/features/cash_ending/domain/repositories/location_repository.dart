// lib/features/cash_ending/domain/repositories/location_repository.dart

import '../entities/location.dart';
import '../entities/store.dart';

/// Repository interface for Location operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
abstract class LocationRepository {
  /// Get all stores for a company
  ///
  /// Returns list of stores
  /// Returns empty list if no stores found
  Future<List<Store>> getStores(String companyId);

  /// Get locations by type (cash, bank, vault)
  ///
  /// [companyId] - Required company identifier
  /// [locationType] - Type of location: 'cash', 'bank', or 'vault'
  /// [storeId] - Optional store filter (null for headquarter)
  ///
  /// Returns list of locations matching criteria
  /// Returns empty list if no locations found
  Future<List<Location>> getLocationsByType({
    required String companyId,
    required String locationType,
    String? storeId,
  });
}
