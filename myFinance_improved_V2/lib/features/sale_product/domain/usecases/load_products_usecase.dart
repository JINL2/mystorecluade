import '../exceptions/sales_exceptions.dart';
import '../repositories/sales_product_repository.dart';

/// Load products use case
///
/// Business logic for loading products from repository.
/// Validates company and store selection before loading.
class LoadProductsUseCase {
  final SalesProductRepository _repository;

  const LoadProductsUseCase(this._repository);

  /// Execute the use case
  ///
  /// Throws [NoCompanyOrStoreSelectedException] if company or store is not selected.
  /// Throws [ProductsLoadFailedException] if loading fails.
  Future<ProductLoadResult> execute({
    required String companyId,
    required String storeId,
    int page = 1,
    int limit = 100,
    String? search,
  }) async {
    // Validate company and store selection
    if (companyId.isEmpty || storeId.isEmpty) {
      throw const NoCompanyOrStoreSelectedException();
    }

    try {
      // Load products from repository
      return await _repository.loadProducts(
        companyId: companyId,
        storeId: storeId,
        page: page,
        limit: limit,
        search: search,
      );
    } catch (e) {
      if (e is SalesException) {
        rethrow;
      }
      throw ProductsLoadFailedException(e.toString());
    }
  }
}
