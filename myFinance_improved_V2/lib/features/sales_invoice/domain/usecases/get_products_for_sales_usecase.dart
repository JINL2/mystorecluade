import '../repositories/product_repository.dart';

/// Use case for getting products available for sales
///
/// Orchestrates product retrieval with validation and business rules.
class GetProductsForSalesUseCase {
  final ProductRepository _repository;

  const GetProductsForSalesUseCase({
    required ProductRepository repository,
  }) : _repository = repository;

  /// Execute the use case
  ///
  /// Parameters:
  /// - [companyId]: Company ID
  /// - [storeId]: Store ID
  ///
  /// Returns: ProductListResult with available products
  Future<ProductListResult> execute({
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

    // Fetch products from repository
    final result = await _repository.getProductsForSales(
      companyId: companyId,
      storeId: storeId,
    );

    return result;
  }
}
