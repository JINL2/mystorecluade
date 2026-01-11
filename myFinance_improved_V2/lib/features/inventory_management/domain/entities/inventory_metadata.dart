// Domain Entity: Inventory Metadata
// Contains reference data for inventory management

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

  String get displaySymbol => symbol ?? code ?? '';
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

  bool get hasSubcategories =>
      subcategories != null && subcategories!.isNotEmpty;
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

  static StockStatusLevel mock() => StockStatusLevel(
        icon: 'info',
        color: 'blue',
        label: 'Normal',
        level: 'normal',
      );
}


