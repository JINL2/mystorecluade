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

  /// Move product between stores
  Future<MoveProductResult?> moveProduct({
    required String companyId,
    required String fromStoreId,
    required String toStoreId,
    required String productId,
    required int quantity,
    required String updatedBy,
    required String notes,
  });

  /// Get product stock by stores
  Future<ProductStockByStoresResult?> getProductStockByStores({
    required String companyId,
    required List<String> productIds,
  });

  /// Get product history
  Future<ProductHistoryPageResult?> getProductHistory({
    required String companyId,
    required String storeId,
    required String productId,
    required int page,
    required int pageSize,
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

/// Move Product Result - result from inventory_move_product_v3 RPC
class MoveProductResult {
  final String transferId;
  final String transferNumber;
  final int itemsCount;
  final int totalQuantity;

  const MoveProductResult({
    required this.transferId,
    required this.transferNumber,
    required this.itemsCount,
    required this.totalQuantity,
  });

  factory MoveProductResult.fromJson(Map<String, dynamic> json) {
    return MoveProductResult(
      transferId: json['transfer_id'] as String? ?? '',
      transferNumber: json['transfer_number'] as String? ?? '',
      itemsCount: json['items_count'] as int? ?? 0,
      totalQuantity: json['total_quantity'] as int? ?? 0,
    );
  }
}

/// Product Stock By Stores Result - result from inventory_product_stock_stores RPC
class ProductStockByStoresResult {
  final List<ProductStoreStock> products;

  const ProductStockByStoresResult({
    required this.products,
  });
}

/// Product with store-specific stock information
class ProductStoreStock {
  final String productId;
  final String productName;
  final String sku;
  final int totalQuantity;
  final List<StoreStock> stores;

  const ProductStoreStock({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.totalQuantity,
    required this.stores,
  });
}

/// Store stock information
class StoreStock {
  final String storeId;
  final String storeName;
  final int quantityOnHand;

  const StoreStock({
    required this.storeId,
    required this.storeName,
    required this.quantityOnHand,
  });
}

/// Product History Page Result - paginated history from inventory_product_history RPC
class ProductHistoryPageResult {
  final List<ProductHistoryEntry> entries;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  const ProductHistoryPageResult({
    required this.entries,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });
}

/// Individual product history entry
class ProductHistoryEntry {
  final String eventType;
  final String eventDate;
  final String localEventDate;
  final int? quantityBefore;
  final int? quantityAfter;
  final int? quantityChange;
  final double? priceBefore;
  final double? priceAfter;
  final String? fromStoreName;
  final String? toStoreName;
  final String? referenceNumber;
  final String? notes;
  final String? userName;
  final String? userAvatar;

  const ProductHistoryEntry({
    required this.eventType,
    required this.eventDate,
    required this.localEventDate,
    this.quantityBefore,
    this.quantityAfter,
    this.quantityChange,
    this.priceBefore,
    this.priceAfter,
    this.fromStoreName,
    this.toStoreName,
    this.referenceNumber,
    this.notes,
    this.userName,
    this.userAvatar,
  });
}
