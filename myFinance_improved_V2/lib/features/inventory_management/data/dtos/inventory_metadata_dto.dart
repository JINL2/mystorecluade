// Data Transfer Object: Inventory Metadata DTO
// Handles JSON serialization/deserialization for Inventory Metadata

/// Main DTO
class InventoryMetadataDto {
  final InventoryStatsDto stats;
  final List<String> units;
  final List<BrandDto> brands;
  final CurrencyDto currency;
  final List<CategoryDto> categories;
  final StoreInfoDto storeInfo;
  final DateTime? lastUpdated;
  final List<ProductTypeDto> productTypes;
  final ValidationRulesDto validationRules;
  final AllowCustomValuesDto allowCustomValues;
  final List<StockStatusLevelDto> stockStatusLevels;

  const InventoryMetadataDto({
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

  factory InventoryMetadataDto.fromJson(Map<String, dynamic> json) {
    final stats = InventoryStatsDto.fromJson(
      json['stats'] as Map<String, dynamic>? ?? {},
    );

    // Parse units - handle both string array and object array
    final List<String> units;
    if (json['units'] == null || (json['units'] as List).isEmpty) {
      units = [];
    } else {
      final unitsList = json['units'] as List;
      if (unitsList.first is String) {
        units = List<String>.from(unitsList);
      } else {
        units = unitsList
            .map((u) => u is String
                ? u
                : ((u['name'] ?? u['value'] ?? u['unit'] ?? u.toString())
                    as String),)
            .toList();
      }
    }

    final brands = (json['brands'] as List? ?? [])
        .map((b) => BrandDto.fromJson(b as Map<String, dynamic>))
        .toList();

    final currency = CurrencyDto.fromJson(
      json['currency'] as Map<String, dynamic>? ?? {},
    );

    final categories = (json['categories'] as List? ?? [])
        .map((c) => CategoryDto.fromJson(c as Map<String, dynamic>))
        .toList();

    final storeInfo = StoreInfoDto.fromJson(
      json['store_info'] as Map<String, dynamic>? ?? {},
    );

    final lastUpdated = json['last_updated'] != null
        ? DateTime.parse(json['last_updated'] as String)
        : null;

    final productTypes = (json['product_types'] as List? ?? [])
        .map((pt) => ProductTypeDto.fromJson(pt as Map<String, dynamic>))
        .toList();

    final validationRules = ValidationRulesDto.fromJson(
      json['validation_rules'] as Map<String, dynamic>? ?? {},
    );

    final allowCustomValues = AllowCustomValuesDto.fromJson(
      json['allow_custom_values'] as Map<String, dynamic>? ?? {},
    );

    final stockStatusLevels = (json['stock_status_levels'] as List? ?? [])
        .map((ssl) => StockStatusLevelDto.fromJson(ssl as Map<String, dynamic>))
        .toList();

    return InventoryMetadataDto(
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
  }
}

/// Supporting DTOs

class InventoryStatsDto {
  final int totalBrands;
  final int totalProducts;
  final int activeProducts;
  final int totalCategories;
  final int inactiveProducts;

  const InventoryStatsDto({
    required this.totalBrands,
    required this.totalProducts,
    required this.activeProducts,
    required this.totalCategories,
    required this.inactiveProducts,
  });

  factory InventoryStatsDto.fromJson(Map<String, dynamic> json) {
    return InventoryStatsDto(
      totalBrands: (json['total_brands'] ?? 0) as int,
      totalProducts: (json['total_products'] ?? 0) as int,
      activeProducts: (json['active_products'] ?? 0) as int,
      totalCategories: (json['total_categories'] ?? 0) as int,
      inactiveProducts: (json['inactive_products'] ?? 0) as int,
    );
  }
}

class BrandDto {
  final String id;
  final String name;
  final int? productCount;

  const BrandDto({
    required this.id,
    required this.name,
    this.productCount,
  });

  factory BrandDto.fromJson(Map<String, dynamic> json) {
    return BrandDto(
      id: (json['id'] ?? json['brand_id'] ?? '') as String,
      name: (json['name'] ?? json['brand_name'] ?? '') as String,
      productCount: json['product_count'] as int?,
    );
  }
}

class CurrencyDto {
  final String? code;
  final String? name;
  final String? symbol;

  const CurrencyDto({
    this.code,
    this.name,
    this.symbol,
  });

  factory CurrencyDto.fromJson(Map<String, dynamic> json) {
    return CurrencyDto(
      code: json['code'] as String?,
      name: json['name'] as String?,
      symbol: json['symbol'] as String?,
    );
  }
}

class CategoryDto {
  final String id;
  final String name;
  final String? parentId;
  final int? productCount;
  final List<CategoryDto>? subcategories;

  const CategoryDto({
    required this.id,
    required this.name,
    this.parentId,
    this.productCount,
    this.subcategories,
  });

  factory CategoryDto.fromJson(Map<String, dynamic> json) {
    return CategoryDto(
      id: (json['id'] ?? json['category_id'] ?? '') as String,
      name: (json['name'] ?? json['category_name'] ?? '') as String,
      parentId: json['parent_id'] as String?,
      productCount: json['product_count'] as int?,
      subcategories: (json['subcategories'] as List?)
          ?.map((c) => CategoryDto.fromJson(c as Map<String, dynamic>))
          .toList(),
    );
  }
}

class StoreInfoDto {
  final String storeId;
  final String storeCode;
  final String storeName;

  const StoreInfoDto({
    required this.storeId,
    required this.storeCode,
    required this.storeName,
  });

  factory StoreInfoDto.fromJson(Map<String, dynamic> json) {
    return StoreInfoDto(
      storeId: (json['store_id'] ?? '') as String,
      storeCode: (json['store_code'] ?? '') as String,
      storeName: (json['store_name'] ?? '') as String,
    );
  }
}

class ProductTypeDto {
  final String label;
  final String value;
  final String? description;
  final int productCount;

  const ProductTypeDto({
    required this.label,
    required this.value,
    this.description,
    required this.productCount,
  });

  factory ProductTypeDto.fromJson(Map<String, dynamic> json) {
    return ProductTypeDto(
      label: (json['label'] ?? '') as String,
      value: (json['value'] ?? '') as String,
      description: json['description'] as String?,
      productCount: (json['product_count'] ?? 0) as int,
    );
  }
}

class ValidationRulesDto {
  final String? skuPattern;
  final String? barcodePattern;
  final bool maxStockRequired;
  final bool minPriceRequired;

  const ValidationRulesDto({
    this.skuPattern,
    this.barcodePattern,
    required this.maxStockRequired,
    required this.minPriceRequired,
  });

  factory ValidationRulesDto.fromJson(Map<String, dynamic> json) {
    return ValidationRulesDto(
      skuPattern: json['sku_pattern'] as String?,
      barcodePattern: json['barcode_pattern'] as String?,
      maxStockRequired: (json['max_stock_required'] ?? false) as bool,
      minPriceRequired: (json['min_price_required'] ?? false) as bool,
    );
  }
}

class AllowCustomValuesDto {
  final bool units;
  final bool brands;
  final bool categories;

  const AllowCustomValuesDto({
    required this.units,
    required this.brands,
    required this.categories,
  });

  factory AllowCustomValuesDto.fromJson(Map<String, dynamic> json) {
    return AllowCustomValuesDto(
      units: (json['units'] ?? true) as bool,
      brands: (json['brands'] ?? true) as bool,
      categories: (json['categories'] ?? true) as bool,
    );
  }
}

class StockStatusLevelDto {
  final String icon;
  final String color;
  final String label;
  final String level;

  const StockStatusLevelDto({
    required this.icon,
    required this.color,
    required this.label,
    required this.level,
  });

  factory StockStatusLevelDto.fromJson(Map<String, dynamic> json) {
    return StockStatusLevelDto(
      icon: (json['icon'] ?? '') as String,
      color: (json['color'] ?? '') as String,
      label: (json['label'] ?? '') as String,
      level: (json['level'] ?? '') as String,
    );
  }
}
