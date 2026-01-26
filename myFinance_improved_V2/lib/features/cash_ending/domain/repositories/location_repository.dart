// lib/features/cash_ending/domain/repositories/location_repository.dart

import '../entities/location.dart';

/// Repository interface for Location operations (Domain Layer)
///
/// This is the contract that data layer must implement.
/// NO dependencies on infrastructure or external libraries.
///
/// NOTE: Store data is available from AppState (loaded at app startup via
/// get_user_companies_with_salary RPC). Use appState.user['companies'][n]['stores']
/// instead of making a separate network call.
abstract class LocationRepository {
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
