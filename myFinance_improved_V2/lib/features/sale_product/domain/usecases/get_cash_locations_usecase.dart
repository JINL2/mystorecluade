import '../entities/cash_location.dart';
import '../repositories/payment_repository.dart';

/// Use case for getting cash locations
///
/// Orchestrates cash location retrieval with validation.
class GetCashLocationsUseCase {
  final PaymentRepository _repository;

  const GetCashLocationsUseCase({
    required PaymentRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Parameters:
  /// - [companyId]: Company ID
  /// - [storeId]: Store ID
  ///
  /// Returns: List of available cash locations
  Future<List<CashLocation>> execute({
    required String companyId,
    required String storeId,
  }) async {
    // Validate input parameters
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }

    if (storeId.isEmpty) {
      throw ArgumentError('Store ID cannot be empty');
    }

    // Fetch cash locations from repository
    final locations = await _repository.getCashLocations(
      companyId: companyId,
      storeId: storeId,
    );

    return locations;
  }
}
