import '../repositories/product_repository.dart';

/// Use case for retrieving product list for invoice creation
///
/// Orchestrates product list retrieval with company and store context.
/// Contains business logic for product list management.
class GetProductListUseCase {
  final ProductRepository _productRepository;

  const GetProductListUseCase({
    required ProductRepository productRepository,
  }) : _productRepository = productRepository;

  /// Executes the get product list use case
  ///
  /// Parameters:
  /// - [companyId]: Company ID to filter products
  /// - [storeId]: Store ID to filter products
  ///
  /// Returns: ProductListResult containing products, company info, and summary
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
    final result = await _productRepository.getProductsForSales(
      companyId: companyId,
      storeId: storeId,
    );

    return result;
  }
}
