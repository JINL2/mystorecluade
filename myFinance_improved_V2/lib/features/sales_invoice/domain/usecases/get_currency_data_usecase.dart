import '../repositories/product_repository.dart';

/// Use case for getting currency data for payment
///
/// Orchestrates currency data retrieval with validation.
class GetCurrencyDataUseCase {
  final ProductRepository _repository;

  const GetCurrencyDataUseCase({
    required ProductRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Parameters:
  /// - [companyId]: Company ID
  ///
  /// Returns: CurrencyDataResult with base and company currencies
  Future<CurrencyDataResult> execute({
    required String companyId,
  }) async {
    // Validate input parameters
    if (companyId.isEmpty) {
      throw ArgumentError('Company ID cannot be empty');
    }

    // Fetch currency data from repository
    final result = await _repository.getCurrencyData(
      companyId: companyId,
    );

    return result;
  }
}
