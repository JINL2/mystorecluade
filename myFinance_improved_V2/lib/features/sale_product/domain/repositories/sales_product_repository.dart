import '../entities/sales_product.dart';

/// Response containing products and pagination info
class ProductLoadResult {
  final List<SalesProduct> products;
  final int totalCount;
  final bool hasNextPage;

  ProductLoadResult({
    required this.products,
    required this.totalCount,
    required this.hasNextPage,
  });
}

/// Repository interface for sales product operations
abstract class SalesProductRepository {
  /// Load products for sale
  ///
  /// Returns [ProductLoadResult] with products and pagination info
  Future<ProductLoadResult> loadProducts({
    required String companyId,
    required String storeId,
    int page = 1,
    int limit = 100,
    String? search,
  });

  /// Refresh product list
  Future<ProductLoadResult> refreshProducts({
    required String companyId,
    required String storeId,
  });
}
