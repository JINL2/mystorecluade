import '../../domain/entities/inventory_metadata.dart';

/// Model for parsing inventory metadata from JSON
class InventoryMetadataModel {
  /// Parse JSON response to domain entity
  static InventoryMetadata fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return InventoryMetadata(
      brands: (data['brands'] as List<dynamic>? ?? [])
          .map((e) => _parseBrandMetadata(e as Map<String, dynamic>))
          .toList(),
      categories: (data['categories'] as List<dynamic>? ?? [])
          .map((e) => _parseCategoryMetadata(e as Map<String, dynamic>))
          .toList(),
      productTypes: (data['product_types'] as List<dynamic>? ?? [])
          .map((e) => _parseProductTypeMetadata(e as Map<String, dynamic>))
          .toList(),
      units: (data['units'] as List<dynamic>? ?? [])
          .map((e) => _parseUnitMetadata(e as Map<String, dynamic>))
          .toList(),
      stats: _parseStatsMetadata(data['stats'] as Map<String, dynamic>? ?? {}),
      currency: data['currency'] != null
          ? _parseCurrencyMetadata(data['currency'] as Map<String, dynamic>)
          : null,
      storeInfo: data['store_info'] != null
          ? _parseStoreInfoMetadata(data['store_info'] as Map<String, dynamic>)
          : null,
    );
  }

  static BrandMetadata _parseBrandMetadata(Map<String, dynamic> json) {
    return BrandMetadata(
      brandId: json['brand_id']?.toString() ?? '',
      brandName: json['brand_name']?.toString() ?? '',
      description: json['description']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );
  }

  static CategoryMetadata _parseCategoryMetadata(Map<String, dynamic> json) {
    return CategoryMetadata(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      description: json['description']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
      canHaveSubcategory: json['can_have_subcategory'] as bool? ?? false,
    );
  }

  static ProductTypeMetadata _parseProductTypeMetadata(
    Map<String, dynamic> json,
  ) {
    return ProductTypeMetadata(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      description: json['description']?.toString(),
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );
  }

  static UnitMetadata _parseUnitMetadata(Map<String, dynamic> json) {
    return UnitMetadata(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      symbol: json['symbol']?.toString(),
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );
  }

  static StatsMetadata _parseStatsMetadata(Map<String, dynamic> json) {
    return StatsMetadata(
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      activeProducts: (json['active_products'] as num?)?.toInt() ?? 0,
      inactiveProducts: (json['inactive_products'] as num?)?.toInt() ?? 0,
      totalCategories: (json['total_categories'] as num?)?.toInt() ?? 0,
      totalBrands: (json['total_brands'] as num?)?.toInt() ?? 0,
    );
  }

  static CurrencyMetadata _parseCurrencyMetadata(Map<String, dynamic> json) {
    return CurrencyMetadata(
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      symbol: json['symbol']?.toString(),
    );
  }

  static StoreInfoMetadata _parseStoreInfoMetadata(Map<String, dynamic> json) {
    return StoreInfoMetadata(
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString(),
      storeCode: json['store_code']?.toString(),
    );
  }
}
