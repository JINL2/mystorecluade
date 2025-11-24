// lib/features/cash_ending/domain/usecases/load_stores_usecase.dart

import '../entities/store.dart';
import '../repositories/location_repository.dart';

/// UseCase: Load stores for a company
///
/// Business Logic:
/// - Load all stores for a given company
/// - Simple read operation, no complex business rules
class LoadStoresUseCase {
  final LocationRepository _locationRepository;

  LoadStoresUseCase(this._locationRepository);

  /// Execute the use case
  ///
  /// [companyId] - The company ID to load stores for
  ///
  /// Returns list of stores
  Future<List<Store>> execute(String companyId) async {
    return await _locationRepository.getStores(companyId);
  }
}
