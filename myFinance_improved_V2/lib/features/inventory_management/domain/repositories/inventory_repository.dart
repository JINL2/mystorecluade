// Repository Interface: Inventory Repository
// Defines contract for inventory data operations

import '../entities/inventory_metadata.dart';
import '../entities/product.dart';
import '../value_objects/image_file.dart';
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
    required String createdBy,
    required String name,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
    String? unit,
    double? costPrice,
    double? sellingPrice,
    int? initialQuantity,
    int? minStock,
    int? maxStock,
    List<String>? imageUrls,
  });

  /// Check if product edit is valid before updating
  Future<EditCheckResult> checkEditProduct({
    required String productId,
    required String companyId,
    String? sku,
    String? productName,
  });

  /// Update existing product
  Future<Product?> updateProduct({
    required String productId,
    required String companyId,
    required String storeId,
    required String createdBy,
    String? sku,
    String? name,
    String? categoryId,
    String? brandId,
    String? unit,
    String? productType,
    double? costPrice,
    double? salePrice,
    int? onHand,
    String? flowType,
    List<String>? imageUrls,
    bool defaultPrice = false,
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

  /// Upload product images to storage
  /// Returns list of public URLs for uploaded images
  Future<List<String>> uploadProductImages({
    required String companyId,
    required List<ImageFile> images,
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

/// Edit Check Result - validation result before product update
class EditCheckResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;
  final bool productExists;
  final bool nameAvailable;
  final bool skuAvailable;

  const EditCheckResult({
    required this.success,
    this.errorCode,
    this.errorMessage,
    required this.productExists,
    required this.nameAvailable,
    required this.skuAvailable,
  });
}
