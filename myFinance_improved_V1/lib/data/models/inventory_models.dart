// Inventory Metadata Model
class InventoryMetadata {
  final InventoryStats stats;
  final List<String> units;
  final List<Brand> brands;
  final Currency currency;
  final List<Category> categories;
  final StoreInfo storeInfo;
  final DateTime? lastUpdated;
  final List<ProductType> productTypes;
  final ValidationRules validationRules;
  final AllowCustomValues allowCustomValues;
  final List<StockStatusLevel> stockStatusLevels;

  InventoryMetadata({
    required this.stats,
    required this.units,
    required this.brands,
    required this.currency,
    required this.categories,
    required this.storeInfo,
    this.lastUpdated,
    required this.productTypes,
    required this.validationRules,
    required this.allowCustomValues,
    required this.stockStatusLevels,
  });

  factory InventoryMetadata.fromJson(Map<String, dynamic> json) {
    try {
      print('📋 [INVENTORY_METADATA] Parsing JSON: $json');
      
      final stats = InventoryStats.fromJson(json['stats'] ?? {});
      print('✅ [INVENTORY_METADATA] Stats parsed');
      
      // Parse units - handle both string array and object array
      final List<String> units;
      if (json['units'] == null || (json['units'] as List).isEmpty) {
        units = [];
      } else {
        final unitsList = json['units'] as List;
        if (unitsList.first is String) {
          units = List<String>.from(unitsList);
        } else {
          // If units are objects, extract the name or value field
          units = unitsList.map((u) => 
            u is String ? u : (u['name'] ?? u['value'] ?? u['unit'] ?? u.toString())
          ).toList().cast<String>();
        }
      }
      print('✅ [INVENTORY_METADATA] Units parsed: ${units.length}');
      
      final brands = (json['brands'] as List? ?? [])
          .map((b) => Brand.fromJson(b))
          .toList();
      print('✅ [INVENTORY_METADATA] Brands parsed: ${brands.length}');
      
      final currency = Currency.fromJson(json['currency'] ?? {});
      print('✅ [INVENTORY_METADATA] Currency parsed');
      
      final categories = (json['categories'] as List? ?? [])
          .map((c) => Category.fromJson(c))
          .toList();
      print('✅ [INVENTORY_METADATA] Categories parsed: ${categories.length}');
      
      final storeInfo = StoreInfo.fromJson(json['store_info'] ?? {});
      print('✅ [INVENTORY_METADATA] Store info parsed');
      
      final lastUpdated = json['last_updated'] != null
          ? DateTime.parse(json['last_updated'])
          : null;
      print('✅ [INVENTORY_METADATA] Last updated parsed');
      
      final productTypes = (json['product_types'] as List? ?? [])
          .map((pt) => ProductType.fromJson(pt))
          .toList();
      print('✅ [INVENTORY_METADATA] Product types parsed: ${productTypes.length}');
      
      final validationRules = ValidationRules.fromJson(json['validation_rules'] ?? {});
      print('✅ [INVENTORY_METADATA] Validation rules parsed');
      
      final allowCustomValues = AllowCustomValues.fromJson(json['allow_custom_values'] ?? {});
      print('✅ [INVENTORY_METADATA] Allow custom values parsed');
      
      final stockStatusLevels = (json['stock_status_levels'] as List? ?? [])
          .map((ssl) => StockStatusLevel.fromJson(ssl))
          .toList();
      print('✅ [INVENTORY_METADATA] Stock status levels parsed: ${stockStatusLevels.length}');
      
      return InventoryMetadata(
        stats: stats,
        units: units,
        brands: brands,
        currency: currency,
        categories: categories,
        storeInfo: storeInfo,
        lastUpdated: lastUpdated,
        productTypes: productTypes,
        validationRules: validationRules,
        allowCustomValues: allowCustomValues,
        stockStatusLevels: stockStatusLevels,
      );
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_METADATA] Error parsing JSON: $e');
      print('📋 [INVENTORY_METADATA] Stack trace: $stackTrace');
      print('📋 [INVENTORY_METADATA] Input JSON: $json');
      rethrow;
    }
  }
}

class InventoryStats {
  final int totalBrands;
  final int totalProducts;
  final int activeProducts;
  final int totalCategories;
  final int inactiveProducts;

  InventoryStats({
    required this.totalBrands,
    required this.totalProducts,
    required this.activeProducts,
    required this.totalCategories,
    required this.inactiveProducts,
  });

  factory InventoryStats.fromJson(Map<String, dynamic> json) {
    return InventoryStats(
      totalBrands: json['total_brands'] ?? 0,
      totalProducts: json['total_products'] ?? 0,
      activeProducts: json['active_products'] ?? 0,
      totalCategories: json['total_categories'] ?? 0,
      inactiveProducts: json['inactive_products'] ?? 0,
    );
  }
}

class Brand {
  final String id;
  final String name;
  final int? productCount;

  Brand({
    required this.id,
    required this.name,
    this.productCount,
  });

  factory Brand.fromJson(Map<String, dynamic> json) {
    return Brand(
      id: json['id'] ?? json['brand_id'] ?? '',
      name: json['name'] ?? json['brand_name'] ?? '',
      productCount: json['product_count'],
    );
  }
}

class Currency {
  final String? code;
  final String? name;
  final String? symbol;

  Currency({
    this.code,
    this.name,
    this.symbol,
  });

  factory Currency.fromJson(Map<String, dynamic> json) {
    return Currency(
      code: json['code'],
      name: json['name'],
      symbol: json['symbol'],
    );
  }
}

class Category {
  final String id;
  final String name;
  final String? parentId;
  final int? productCount;
  final List<Category>? subcategories;

  Category({
    required this.id,
    required this.name,
    this.parentId,
    this.productCount,
    this.subcategories,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? json['category_id'] ?? '',
      name: json['name'] ?? json['category_name'] ?? '',
      parentId: json['parent_id'],
      productCount: json['product_count'],
      subcategories: (json['subcategories'] as List?)
          ?.map((c) => Category.fromJson(c))
          .toList(),
    );
  }
}

class StoreInfo {
  final String storeId;
  final String storeCode;
  final String storeName;

  StoreInfo({
    required this.storeId,
    required this.storeCode,
    required this.storeName,
  });

  factory StoreInfo.fromJson(Map<String, dynamic> json) {
    return StoreInfo(
      storeId: json['store_id'] ?? '',
      storeCode: json['store_code'] ?? '',
      storeName: json['store_name'] ?? '',
    );
  }
}

class ProductType {
  final String label;
  final String value;
  final String? description;
  final int productCount;

  ProductType({
    required this.label,
    required this.value,
    this.description,
    required this.productCount,
  });

  factory ProductType.fromJson(Map<String, dynamic> json) {
    return ProductType(
      label: json['label'] ?? '',
      value: json['value'] ?? '',
      description: json['description'],
      productCount: json['product_count'] ?? 0,
    );
  }
}

class ValidationRules {
  final String? skuPattern;
  final String? barcodePattern;
  final bool maxStockRequired;
  final bool minPriceRequired;

  ValidationRules({
    this.skuPattern,
    this.barcodePattern,
    required this.maxStockRequired,
    required this.minPriceRequired,
  });

  factory ValidationRules.fromJson(Map<String, dynamic> json) {
    return ValidationRules(
      skuPattern: json['sku_pattern'],
      barcodePattern: json['barcode_pattern'],
      maxStockRequired: json['max_stock_required'] ?? false,
      minPriceRequired: json['min_price_required'] ?? false,
    );
  }
}

class AllowCustomValues {
  final bool units;
  final bool brands;
  final bool categories;

  AllowCustomValues({
    required this.units,
    required this.brands,
    required this.categories,
  });

  factory AllowCustomValues.fromJson(Map<String, dynamic> json) {
    return AllowCustomValues(
      units: json['units'] ?? true,
      brands: json['brands'] ?? true,
      categories: json['categories'] ?? true,
    );
  }
}

class StockStatusLevel {
  final String icon;
  final String color;
  final String label;
  final String level;

  StockStatusLevel({
    required this.icon,
    required this.color,
    required this.label,
    required this.level,
  });

  factory StockStatusLevel.fromJson(Map<String, dynamic> json) {
    return StockStatusLevel(
      icon: json['icon'] ?? '',
      color: json['color'] ?? '',
      label: json['label'] ?? '',
      level: json['level'] ?? '',
    );
  }
}

// Inventory Page Result Model
class InventoryPageResult {
  final Currency currency;
  final List<InventoryProduct> products;
  final Pagination pagination;

  InventoryPageResult({
    required this.currency,
    required this.products,
    required this.pagination,
  });

  factory InventoryPageResult.fromJson(Map<String, dynamic> json) {
    try {
      print('📋 [INVENTORY_PAGE_RESULT] Parsing JSON keys: ${json.keys.toList()}');
      
      final currency = Currency.fromJson(json['currency'] ?? {});
      print('✅ [INVENTORY_PAGE_RESULT] Currency parsed');
      
      final productsJson = json['products'] as List? ?? [];
      print('📦 [INVENTORY_PAGE_RESULT] Products array length: ${productsJson.length}');
      
      final products = productsJson
          .map((p) => InventoryProduct.fromJson(p))
          .toList();
      print('✅ [INVENTORY_PAGE_RESULT] Products parsed: ${products.length}');
      
      final pagination = Pagination.fromJson(json['pagination'] ?? {});
      print('✅ [INVENTORY_PAGE_RESULT] Pagination parsed');
      
      return InventoryPageResult(
        currency: currency,
        products: products,
        pagination: pagination,
      );
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_PAGE_RESULT] Error parsing JSON: $e');
      print('📋 [INVENTORY_PAGE_RESULT] Stack trace: $stackTrace');
      print('📋 [INVENTORY_PAGE_RESULT] Input JSON: $json');
      rethrow;
    }
  }
}

class InventoryProduct {
  final String id;
  final String name;
  final String? sku;
  final String? barcode;
  final double price;
  final double? cost;
  final int stock;
  final int? minStock;
  final int? maxStock;
  final String? unit;
  final String? categoryId;
  final String? categoryName;
  final String? brandId;
  final String? brandName;
  final String? description;
  final String? imageUrl;
  final bool isActive;
  final String? stockStatus;
  final int? quantityAvailable;
  final int? quantityReserved;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  InventoryProduct({
    required this.id,
    required this.name,
    this.sku,
    this.barcode,
    required this.price,
    this.cost,
    required this.stock,
    this.minStock,
    this.maxStock,
    this.unit,
    this.categoryId,
    this.categoryName,
    this.brandId,
    this.brandName,
    this.description,
    this.imageUrl,
    this.isActive = true,
    this.stockStatus,
    this.quantityAvailable,
    this.quantityReserved,
    this.createdAt,
    this.updatedAt,
  });

  factory InventoryProduct.fromJson(Map<String, dynamic> json) {
    try {
      print('🔍 [INVENTORY_PRODUCT] Parsing product JSON: ${json.keys.toList()}');
      
      // Parse price - handle both nested object and flat value
      double parsedPrice = 0.0;
      if (json['price'] != null) {
        if (json['price'] is Map) {
          // Nested price object from RPC
          parsedPrice = (json['price']['selling'] ?? 0).toDouble();
          print('✅ [INVENTORY_PRODUCT] Parsed nested price.selling: $parsedPrice');
        } else {
          // Flat price value
          parsedPrice = (json['price']).toDouble();
          print('✅ [INVENTORY_PRODUCT] Parsed flat price: $parsedPrice');
        }
      }
      
      // Parse cost - handle both nested price.cost and flat cost
      double? parsedCost;
      if (json['price'] != null && json['price'] is Map && json['price']['cost'] != null) {
        parsedCost = json['price']['cost'].toDouble();
        print('✅ [INVENTORY_PRODUCT] Parsed nested price.cost: $parsedCost');
      } else if (json['cost'] != null) {
        parsedCost = json['cost'].toDouble();
        print('✅ [INVENTORY_PRODUCT] Parsed flat cost: $parsedCost');
      }
      
      // Parse stock - handle both nested object and flat value
      int parsedStock = 0;
      int? parsedQuantityAvailable;
      int? parsedQuantityReserved;
      if (json['stock'] != null) {
        if (json['stock'] is Map) {
          // Nested stock object from RPC - convert double to int
          parsedStock = (json['stock']['quantity_on_hand'] ?? 0).toDouble().toInt();
          parsedQuantityAvailable = json['stock']['quantity_available']?.toDouble()?.toInt();
          parsedQuantityReserved = json['stock']['quantity_reserved']?.toDouble()?.toInt();
          print('✅ [INVENTORY_PRODUCT] Parsed nested stock: on_hand=$parsedStock, available=$parsedQuantityAvailable, reserved=$parsedQuantityReserved');
        } else {
          // Flat stock value
          parsedStock = json['stock'] is double ? json['stock'].toInt() : json['stock'];
          print('✅ [INVENTORY_PRODUCT] Parsed flat stock: $parsedStock');
        }
      } else if (json['current_stock'] != null) {
        parsedStock = json['current_stock'] is double ? json['current_stock'].toInt() : json['current_stock'];
        print('✅ [INVENTORY_PRODUCT] Parsed current_stock: $parsedStock');
      }
      
      return InventoryProduct(
        id: json['id'] ?? json['product_id'] ?? '',
        name: json['name'] ?? json['product_name'] ?? '',
        sku: json['sku'],
        barcode: json['barcode'],
        price: parsedPrice,
        cost: parsedCost,
        stock: parsedStock,
        minStock: json['min_stock'],
        maxStock: json['max_stock'],
        unit: json['unit'],
        categoryId: json['category_id'],
        categoryName: json['category_name'],
        brandId: json['brand_id'],
        brandName: json['brand_name'],
        description: json['description'],
        imageUrl: json['image_url'],
        isActive: json['is_active'] ?? true,
        stockStatus: json['stock_status'],
        quantityAvailable: parsedQuantityAvailable,
        quantityReserved: parsedQuantityReserved,
        createdAt: json['created_at'] != null
            ? DateTime.parse(json['created_at'])
            : null,
        updatedAt: json['updated_at'] != null
            ? DateTime.parse(json['updated_at'])
            : null,
      );
    } catch (e, stackTrace) {
      print('❌ [INVENTORY_PRODUCT] Error parsing product JSON: $e');
      print('📋 [INVENTORY_PRODUCT] Stack trace: $stackTrace');
      print('📋 [INVENTORY_PRODUCT] Input JSON: $json');
      rethrow;
    }
  }

  // Helper method to get stock status color
  String getStockStatusColor() {
    if (stock == 0) return '#FF0000'; // Red for out of stock
    final minStockValue = minStock;
    if (minStockValue != null && stock <= minStockValue) return '#FFA500'; // Orange for low stock
    final maxStockValue = maxStock;
    if (maxStockValue != null && stock >= maxStockValue) return '#0000FF'; // Blue for overstock
    return '#00FF00'; // Green for normal
  }

  // Helper method to get stock status label
  String getStockStatusLabel() {
    if (stock == 0) return '품절';
    final minStockValue = minStock;
    if (minStockValue != null && stock <= minStockValue) return '재고 부족';
    final maxStockValue = maxStock;
    if (maxStockValue != null && stock >= maxStockValue) return '과재고';
    return '정상';
  }
}

class Pagination {
  final int page;
  final int limit;
  final int total;
  final bool hasNext;
  final int totalPages;

  Pagination({
    required this.page,
    required this.limit,
    required this.total,
    required this.hasNext,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      page: json['page'] ?? 1,
      limit: json['limit'] ?? 10,
      total: json['total'] ?? 0,
      hasNext: json['has_next'] ?? false,
      totalPages: json['total_pages'] ?? 1,
    );
  }
}