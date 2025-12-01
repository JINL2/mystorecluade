// Repository Interface: Inventory Repository
// Defines contract for inventory data operations

import '../entities/inventory_metadata.dart';
import '../entities/product.dart';
import '../value_objects/pagination_params.dart';
import '../value_objects/product_filter.dart';
import '../value_objects/sort_option.dart';

abstract class InventoryRepository {
  /// Get inventory metadata (categories, brands, units, etc.)
  Future<InventoryMetadata?> getMetadata({
    required String companyId,
    required String storeId,
  });

  /// Get paginated list of products
  Future<ProductPageResult?> getProducts({
    required String companyId,
    required String storeId,
    required PaginationParams pagination,
    ProductFilter? filter,
    SortOption? sortOption,
  });

  /// Create new product
  Future<Product?> createProduct({
    required String companyId,
    required String storeId,
    required String name,
    required String sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    double? costPrice,
    double? sellingPrice,
    int? initialQuantity,
    String? imageUrl,
    String? thumbnailUrl,
    List<String>? imageUrls,
  });

  /// Update existing product
  Future<Product?> updateProduct({
    required String productId,
    required String companyId,
    required String storeId,
    required String sku,
    required String name,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    String? productType,
    double? costPrice,
    double? salePrice,
    int? onHand,
    int? minStock,
    int? maxStock,
    bool? isActive,
    String? description,
  });

  /// Delete products
  Future<bool> deleteProducts({
    required List<String> productIds,
    required String companyId,
  });

  /// Create new category
  Future<Category?> createCategory({
    required String companyId,
    required String categoryName,
    String? parentCategoryId,
  });

  /// Create new brand
  Future<Brand?> createBrand({
    required String companyId,
    required String brandName,
    String? brandCode,
  });

}

/// Product Page Result
class ProductPageResult {
  final List<Product> products;
  final PaginationResult pagination;
  final Currency currency;

  const ProductPageResult({
    required this.products,
    required this.pagination,
    required this.currency,
  });
}
