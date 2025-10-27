import '../entities/sales_product.dart';

/// Repository interface for sales product operations
abstract class SalesProductRepository {
  /// Load products for sale
  ///
  /// Returns list of [SalesProduct] available for sale based on filters
  Future<List<SalesProduct>> loadProducts({
    required String companyId,
    required String storeId,
    int page = 1,
    int limit = 100,
    String? search,
  });

  /// Refresh product list
  Future<List<SalesProduct>> refreshProducts({
    required String companyId,
    required String storeId,
  });
}
