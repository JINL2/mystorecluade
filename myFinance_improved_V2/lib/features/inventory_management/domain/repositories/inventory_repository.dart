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

  /// Create new product with optional variant support
  /// v4: Added attributeId and variants for single-attribute variant support
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
    // v4: Variant support
    String? attributeId,
    List<Map<String, dynamic>>? variants,
  });

  /// Check if product edit is valid before updating
  Future<EditCheckResult> checkEditProduct({
    required String productId,
    required String companyId,
    String? sku,
    String? productName,
  });

  /// Check if product can be created (validates SKU/barcode before creation)
  Future<CreateCheckResult> checkCreateProduct({
    required String companyId,
    required String productName,
    String? storeId,
    String? sku,
    String? barcode,
    String? categoryId,
    String? brandId,
  });

  /// Update existing product
  /// Supports adding variants via attributeId and addVariants parameters
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
    String? variantId,
    String? attributeId,
    List<Map<String, dynamic>>? addVariants,
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
  /// For variant products, variantId is REQUIRED
  /// For non-variant products, variantId must be NULL
  Future<MoveProductResult?> moveProduct({
    required String companyId,
    required String fromStoreId,
    required String toStoreId,
    required String productId,
    String? variantId,
    required int quantity,
    required String updatedBy,
    required String notes,
  });

  /// Get product stock by stores
  Future<ProductStockByStoresResult?> getProductStockByStores({
    required String companyId,
    required List<String> productIds,
  });

  /// Get product history (v2 with variant support)
  Future<ProductHistoryPageResult?> getProductHistory({
    required String companyId,
    required String storeId,
    required String productId,
    String? variantId,
    required int page,
    required int pageSize,
  });

  /// Get base currency for company
  Future<BaseCurrencyResult?> getBaseCurrency({
    required String companyId,
  });

  /// Get inventory history for the entire store
  Future<InventoryHistoryPageResult?> getInventoryHistory({
    required String companyId,
    required String storeId,
    required int page,
    required int pageSize,
  });

  /// Create new attribute with optional options
  Future<CreateAttributeResult> createAttributeAndOption({
    required String companyId,
    required String attributeName,
    List<Map<String, dynamic>>? options,
  });

  /// Update attribute name and manage options (add, update, delete)
  Future<UpdateAttributeResult> updateAttributeAndOptions({
    required String companyId,
    required String attributeId,
    required String createdBy,
    String? attributeName,
    List<Map<String, dynamic>>? options,
  });
}

/// Product Page Result
/// v6.1: Added store-wide totals (not affected by filters)
class ProductPageResult {
  final List<Product> products;
  final PaginationResult pagination;
  final Currency currency;

  /// Filtered total value (selling price based) - affected by filters
  final double serverTotalValue;

  /// Filtered item count - affected by filters
  final int filteredCount;

  /// v6.1: Store-wide total cost value - NOT affected by filters
  final double totalInventoryCost;

  /// v6.1: Store-wide total retail value - NOT affected by filters
  final double totalInventoryRetail;

  /// v6.1: Store-wide total quantity - NOT affected by filters
  final int totalInventoryQuantity;

  const ProductPageResult({
    required this.products,
    required this.pagination,
    required this.currency,
    this.serverTotalValue = 0.0,
    this.filteredCount = 0,
    this.totalInventoryCost = 0.0,
    this.totalInventoryRetail = 0.0,
    this.totalInventoryQuantity = 0,
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

/// Create Check Result - validation result before product creation
class CreateCheckResult {
  final bool success;
  final String? errorCode;
  final String? errorMessage;
  final String? sku;
  final String? barcode;
  final bool skuAutoGenerated;
  final bool barcodeAutoGenerated;

  const CreateCheckResult({
    required this.success,
    this.errorCode,
    this.errorMessage,
    this.sku,
    this.barcode,
    this.skuAutoGenerated = false,
    this.barcodeAutoGenerated = false,
  });
}

/// Move Product Result - result from inventory_move_product_v4 RPC
class MoveProductResult {
  final String transferId;
  final String transferNumber;
  final MoveStoreInfo fromStore;
  final MoveStoreInfo toStore;
  final int itemsCount;
  final int totalQuantity;
  final int logsCreated;
  final List<MoveProductItemResult> items;
  final String timestampLocal;
  final String timestampUtc;

  const MoveProductResult({
    required this.transferId,
    required this.transferNumber,
    required this.fromStore,
    required this.toStore,
    required this.itemsCount,
    required this.totalQuantity,
    required this.logsCreated,
    required this.items,
    required this.timestampLocal,
    required this.timestampUtc,
  });

  factory MoveProductResult.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? [];
    return MoveProductResult(
      transferId: json['transfer_id'] as String? ?? '',
      transferNumber: json['transfer_number'] as String? ?? '',
      fromStore: MoveStoreInfo.fromJson(json['from_store'] as Map<String, dynamic>? ?? {}),
      toStore: MoveStoreInfo.fromJson(json['to_store'] as Map<String, dynamic>? ?? {}),
      itemsCount: (json['items_count'] as num?)?.toInt() ?? 0,
      totalQuantity: (json['total_quantity'] as num?)?.toInt() ?? 0,
      logsCreated: (json['logs_created'] as num?)?.toInt() ?? 0,
      items: itemsJson
          .map((i) => MoveProductItemResult.fromJson(i as Map<String, dynamic>))
          .toList(),
      timestampLocal: json['timestamp_local']?.toString() ?? '',
      timestampUtc: json['timestamp_utc']?.toString() ?? '',
    );
  }
}

/// Store info in move product result
class MoveStoreInfo {
  final String storeId;
  final String storeName;

  const MoveStoreInfo({
    required this.storeId,
    required this.storeName,
  });

  factory MoveStoreInfo.fromJson(Map<String, dynamic> json) {
    return MoveStoreInfo(
      storeId: json['store_id'] as String? ?? '',
      storeName: json['store_name'] as String? ?? '',
    );
  }
}

/// Individual item result in move product response
class MoveProductItemResult {
  final String productId;
  final String productName;
  final String? variantId;
  final String? variantName;
  final int quantity;
  final double unitCost;
  final int fromStockBefore;
  final int fromStockAfter;
  final int toStockBefore;
  final int toStockAfter;

  const MoveProductItemResult({
    required this.productId,
    required this.productName,
    this.variantId,
    this.variantName,
    required this.quantity,
    required this.unitCost,
    required this.fromStockBefore,
    required this.fromStockAfter,
    required this.toStockBefore,
    required this.toStockAfter,
  });

  factory MoveProductItemResult.fromJson(Map<String, dynamic> json) {
    return MoveProductItemResult(
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      variantId: json['variant_id'] as String?,
      variantName: json['variant_name'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 0,
      unitCost: (json['unit_cost'] as num?)?.toDouble() ?? 0.0,
      fromStockBefore: (json['from_stock_before'] as num?)?.toInt() ?? 0,
      fromStockAfter: (json['from_stock_after'] as num?)?.toInt() ?? 0,
      toStockBefore: (json['to_stock_before'] as num?)?.toInt() ?? 0,
      toStockAfter: (json['to_stock_after'] as num?)?.toInt() ?? 0,
    );
  }
}

/// Product Stock By Stores Result - result from inventory_product_stock_stores_v2 RPC
class ProductStockByStoresResult {
  final List<ProductStoreStock> products;

  const ProductStockByStoresResult({
    required this.products,
  });
}

/// Product with store-specific stock information (v2 supports variants)
class ProductStoreStock {
  final String productId;
  final String productName;
  final String sku;
  final bool hasVariants;
  final int totalQuantity;
  final List<VariantStoreStock> variants; // For products WITH variants
  final List<StoreStock> stores; // For products WITHOUT variants

  const ProductStoreStock({
    required this.productId,
    required this.productName,
    required this.sku,
    required this.hasVariants,
    required this.totalQuantity,
    required this.variants,
    required this.stores,
  });

  /// Get stores for a specific variant (by variantId)
  List<StoreStock> getStoresForVariant(String variantId) {
    final variant = variants.cast<VariantStoreStock?>().firstWhere(
      (v) => v?.variantId == variantId,
      orElse: () => null,
    );
    return variant?.stores ?? [];
  }
}

/// Variant with store-specific stock information
class VariantStoreStock {
  final String variantId;
  final String variantName;
  final String variantSku;
  final int totalQuantity;
  final List<StoreStock> stores;

  const VariantStoreStock({
    required this.variantId,
    required this.variantName,
    required this.variantSku,
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
  final String logId;
  final String eventCategory;
  final String eventType;
  // Variant info (v2)
  final String? variantId;
  final String? variantName;
  final String? displayName;
  // Stock changes
  final int? quantityBefore;
  final int? quantityAfter;
  final int? quantityChange;
  // Price fields
  final double? costBefore;
  final double? costAfter;
  final double? sellingPriceBefore;
  final double? sellingPriceAfter;
  final double? minPriceBefore;
  final double? minPriceAfter;
  // Product fields
  final String? nameBefore;
  final String? nameAfter;
  final String? skuBefore;
  final String? skuAfter;
  final String? barcodeBefore;
  final String? barcodeAfter;
  final String? brandIdBefore;
  final String? brandIdAfter;
  final String? brandNameBefore;
  final String? brandNameAfter;
  final String? categoryIdBefore;
  final String? categoryIdAfter;
  final String? categoryNameBefore;
  final String? categoryNameAfter;
  final double? weightBefore;
  final double? weightAfter;
  // Reference fields
  final String? invoiceId;
  final String? invoiceNumber;
  final String? transferId;
  final String? fromStoreId;
  final String? fromStoreName;
  final String? toStoreId;
  final String? toStoreName;
  // Other fields
  final String? reason;
  final String? notes;
  final String? createdBy;
  final String? createdUser;
  final String? createdUserProfileImage;
  final String createdAt;

  const ProductHistoryEntry({
    required this.logId,
    required this.eventCategory,
    required this.eventType,
    this.variantId,
    this.variantName,
    this.displayName,
    this.quantityBefore,
    this.quantityAfter,
    this.quantityChange,
    this.costBefore,
    this.costAfter,
    this.sellingPriceBefore,
    this.sellingPriceAfter,
    this.minPriceBefore,
    this.minPriceAfter,
    this.nameBefore,
    this.nameAfter,
    this.skuBefore,
    this.skuAfter,
    this.barcodeBefore,
    this.barcodeAfter,
    this.brandIdBefore,
    this.brandIdAfter,
    this.brandNameBefore,
    this.brandNameAfter,
    this.categoryIdBefore,
    this.categoryIdAfter,
    this.categoryNameBefore,
    this.categoryNameAfter,
    this.weightBefore,
    this.weightAfter,
    this.invoiceId,
    this.invoiceNumber,
    this.transferId,
    this.fromStoreId,
    this.fromStoreName,
    this.toStoreId,
    this.toStoreName,
    this.reason,
    this.notes,
    this.createdBy,
    this.createdUser,
    this.createdUserProfileImage,
    required this.createdAt,
  });
}

/// Base Currency Result - result from get_base_currency RPC
class BaseCurrencyResult {
  final BaseCurrencyInfo baseCurrency;
  final List<CompanyCurrencyInfo> companyCurrencies;

  const BaseCurrencyResult({
    required this.baseCurrency,
    required this.companyCurrencies,
  });
}

/// Base Currency Info
class BaseCurrencyInfo {
  final String? currencyId;
  final String? currencyCode;
  final String? currencyName;
  final String? symbol;
  final String? flagEmoji;

  const BaseCurrencyInfo({
    this.currencyId,
    this.currencyCode,
    this.currencyName,
    this.symbol,
    this.flagEmoji,
  });

  String get displaySymbol => symbol ?? currencyCode ?? '';
}

/// Company Currency Info with exchange rate
class CompanyCurrencyInfo {
  final String? currencyId;
  final String? currencyCode;
  final String? currencyName;
  final String? symbol;
  final String? flagEmoji;
  final double? exchangeRateToBase;
  final String? rateDate;

  const CompanyCurrencyInfo({
    this.currencyId,
    this.currencyCode,
    this.currencyName,
    this.symbol,
    this.flagEmoji,
    this.exchangeRateToBase,
    this.rateDate,
  });
}

/// Inventory History Page Result - paginated history from inventory_history RPC
class InventoryHistoryPageResult {
  final List<InventoryHistoryEntry> entries;
  final int totalCount;
  final int page;
  final int pageSize;
  final int totalPages;

  const InventoryHistoryPageResult({
    required this.entries,
    required this.totalCount,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });
}

/// Individual inventory history entry (includes product info)
/// v2: Added variant_id, variant_name, display_name for variant support
class InventoryHistoryEntry {
  final String logId;
  final String eventCategory;
  final String eventType;
  // Product info
  final String? productId;
  final String? productName;
  final String? productSku;
  final String? productImage;
  // Variant info (v2)
  final String? variantId;
  final String? variantName;
  final String? displayName;
  // Store info
  final String? storeId;
  final String? storeName;
  // Quantity fields
  final int? quantityBefore;
  final int? quantityAfter;
  final int? quantityChange;
  // Price fields
  final double? costBefore;
  final double? costAfter;
  final double? sellingPriceBefore;
  final double? sellingPriceAfter;
  final double? minPriceBefore;
  final double? minPriceAfter;
  // Product change fields
  final String? nameBefore;
  final String? nameAfter;
  final String? skuBefore;
  final String? skuAfter;
  final String? barcodeBefore;
  final String? barcodeAfter;
  final String? brandIdBefore;
  final String? brandIdAfter;
  final String? brandNameBefore;
  final String? brandNameAfter;
  final String? categoryIdBefore;
  final String? categoryIdAfter;
  final String? categoryNameBefore;
  final String? categoryNameAfter;
  final double? weightBefore;
  final double? weightAfter;
  // Reference fields
  final String? invoiceId;
  final String? invoiceNumber;
  final String? transferId;
  final String? fromStoreId;
  final String? fromStoreName;
  final String? toStoreId;
  final String? toStoreName;
  // Other fields
  final String? reason;
  final String? notes;
  final String? createdBy;
  final String? createdUser;
  final String? createdUserProfileImage;
  final String createdAt;

  const InventoryHistoryEntry({
    required this.logId,
    required this.eventCategory,
    required this.eventType,
    this.productId,
    this.productName,
    this.productSku,
    this.productImage,
    this.variantId,
    this.variantName,
    this.displayName,
    this.storeId,
    this.storeName,
    this.quantityBefore,
    this.quantityAfter,
    this.quantityChange,
    this.costBefore,
    this.costAfter,
    this.sellingPriceBefore,
    this.sellingPriceAfter,
    this.minPriceBefore,
    this.minPriceAfter,
    this.nameBefore,
    this.nameAfter,
    this.skuBefore,
    this.skuAfter,
    this.barcodeBefore,
    this.barcodeAfter,
    this.brandIdBefore,
    this.brandIdAfter,
    this.brandNameBefore,
    this.brandNameAfter,
    this.categoryIdBefore,
    this.categoryIdAfter,
    this.categoryNameBefore,
    this.categoryNameAfter,
    this.weightBefore,
    this.weightAfter,
    this.invoiceId,
    this.invoiceNumber,
    this.transferId,
    this.fromStoreId,
    this.fromStoreName,
    this.toStoreId,
    this.toStoreName,
    this.reason,
    this.notes,
    this.createdBy,
    this.createdUser,
    this.createdUserProfileImage,
    required this.createdAt,
  });
}

/// Result from inventory_create_attribute_and_option RPC
class CreateAttributeResult {
  final String attributeId;
  final String attributeName;
  final int optionsCreated;
  final List<CreatedAttributeOption> options;

  const CreateAttributeResult({
    required this.attributeId,
    required this.attributeName,
    required this.optionsCreated,
    required this.options,
  });
}

/// Created option data
class CreatedAttributeOption {
  final String optionId;
  final String optionValue;
  final int sortOrder;

  const CreatedAttributeOption({
    required this.optionId,
    required this.optionValue,
    required this.sortOrder,
  });
}

/// Result from inventory_update_attribute_and_options RPC
class UpdateAttributeResult {
  final String attributeId;
  final String attributeName;
  final int optionsUpdated;
  final int optionsAdded;
  final int optionsDeleted;
  final List<UpdatedAttributeOption> options;

  const UpdateAttributeResult({
    required this.attributeId,
    required this.attributeName,
    required this.optionsUpdated,
    required this.optionsAdded,
    required this.optionsDeleted,
    required this.options,
  });
}

/// Updated option data
class UpdatedAttributeOption {
  final String optionId;
  final String optionValue;
  final int sortOrder;
  final String action; // 'updated', 'added', 'deleted'

  const UpdatedAttributeOption({
    required this.optionId,
    required this.optionValue,
    required this.sortOrder,
    required this.action,
  });
}
