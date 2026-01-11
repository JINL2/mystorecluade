import 'package:supabase_flutter/supabase_flutter.dart';

/// Inventory metadata from get_inventory_metadata_v2 RPC
class InventoryMetadata {
  final List<BrandMetadata> brands;
  final List<CategoryMetadata> categories;
  final List<ProductTypeMetadata> productTypes;
  final List<UnitMetadata> units;
  final StatsMetadata stats;
  final CurrencyMetadata? currency;
  final StoreInfoMetadata? storeInfo;
  final List<AttributeMetadata> attributes;

  const InventoryMetadata({
    required this.brands,
    required this.categories,
    required this.productTypes,
    required this.units,
    required this.stats,
    this.currency,
    this.storeInfo,
    required this.attributes,
  });

  factory InventoryMetadata.empty() => const InventoryMetadata(
        brands: [],
        categories: [],
        productTypes: [],
        units: [],
        stats: StatsMetadata(
          totalProducts: 0,
          activeProducts: 0,
          inactiveProducts: 0,
          totalCategories: 0,
          totalBrands: 0,
        ),
        attributes: [],
      );

  factory InventoryMetadata.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? json;

    return InventoryMetadata(
      brands: (data['brands'] as List<dynamic>? ?? [])
          .map((e) => BrandMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
      categories: (data['categories'] as List<dynamic>? ?? [])
          .map((e) => CategoryMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
      productTypes: (data['product_types'] as List<dynamic>? ?? [])
          .map((e) => ProductTypeMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
      units: (data['units'] as List<dynamic>? ?? [])
          .map((e) => UnitMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
      stats: StatsMetadata.fromJson(
          data['stats'] as Map<String, dynamic>? ?? {}),
      currency: data['currency'] != null
          ? CurrencyMetadata.fromJson(data['currency'] as Map<String, dynamic>)
          : null,
      storeInfo: data['store_info'] != null
          ? StoreInfoMetadata.fromJson(
              data['store_info'] as Map<String, dynamic>)
          : null,
      attributes: (data['attributes'] as List<dynamic>? ?? [])
          .map((e) => AttributeMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class BrandMetadata {
  final String brandId;
  final String brandName;
  final String? description;
  final bool isActive;
  final int productCount;

  const BrandMetadata({
    required this.brandId,
    required this.brandName,
    this.description,
    required this.isActive,
    required this.productCount,
  });

  factory BrandMetadata.fromJson(Map<String, dynamic> json) {
    return BrandMetadata(
      brandId: json['brand_id']?.toString() ?? '',
      brandName: json['brand_name']?.toString() ?? '',
      description: json['description']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class CategoryMetadata {
  final String categoryId;
  final String categoryName;
  final String? description;
  final bool isActive;
  final int productCount;
  final bool canHaveSubcategory;

  const CategoryMetadata({
    required this.categoryId,
    required this.categoryName,
    this.description,
    required this.isActive,
    required this.productCount,
    required this.canHaveSubcategory,
  });

  factory CategoryMetadata.fromJson(Map<String, dynamic> json) {
    return CategoryMetadata(
      categoryId: json['category_id']?.toString() ?? '',
      categoryName: json['category_name']?.toString() ?? '',
      description: json['description']?.toString(),
      isActive: json['is_active'] as bool? ?? true,
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
      canHaveSubcategory: json['can_have_subcategory'] as bool? ?? false,
    );
  }
}

class ProductTypeMetadata {
  final String value;
  final String label;
  final String? description;
  final int productCount;

  const ProductTypeMetadata({
    required this.value,
    required this.label,
    this.description,
    required this.productCount,
  });

  factory ProductTypeMetadata.fromJson(Map<String, dynamic> json) {
    return ProductTypeMetadata(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      description: json['description']?.toString(),
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class UnitMetadata {
  final String value;
  final String label;
  final String? symbol;
  final int productCount;

  const UnitMetadata({
    required this.value,
    required this.label,
    this.symbol,
    required this.productCount,
  });

  factory UnitMetadata.fromJson(Map<String, dynamic> json) {
    return UnitMetadata(
      value: json['value']?.toString() ?? '',
      label: json['label']?.toString() ?? '',
      symbol: json['symbol']?.toString(),
      productCount: (json['product_count'] as num?)?.toInt() ?? 0,
    );
  }
}

class StatsMetadata {
  final int totalProducts;
  final int activeProducts;
  final int inactiveProducts;
  final int totalCategories;
  final int totalBrands;

  const StatsMetadata({
    required this.totalProducts,
    required this.activeProducts,
    required this.inactiveProducts,
    required this.totalCategories,
    required this.totalBrands,
  });

  factory StatsMetadata.fromJson(Map<String, dynamic> json) {
    return StatsMetadata(
      totalProducts: (json['total_products'] as num?)?.toInt() ?? 0,
      activeProducts: (json['active_products'] as num?)?.toInt() ?? 0,
      inactiveProducts: (json['inactive_products'] as num?)?.toInt() ?? 0,
      totalCategories: (json['total_categories'] as num?)?.toInt() ?? 0,
      totalBrands: (json['total_brands'] as num?)?.toInt() ?? 0,
    );
  }
}

class CurrencyMetadata {
  final String? code;
  final String? name;
  final String? symbol;

  const CurrencyMetadata({
    this.code,
    this.name,
    this.symbol,
  });

  factory CurrencyMetadata.fromJson(Map<String, dynamic> json) {
    return CurrencyMetadata(
      code: json['code']?.toString(),
      name: json['name']?.toString(),
      symbol: json['symbol']?.toString(),
    );
  }
}

class StoreInfoMetadata {
  final String storeId;
  final String? storeName;
  final String? storeCode;

  const StoreInfoMetadata({
    required this.storeId,
    this.storeName,
    this.storeCode,
  });

  factory StoreInfoMetadata.fromJson(Map<String, dynamic> json) {
    return StoreInfoMetadata(
      storeId: json['store_id']?.toString() ?? '',
      storeName: json['store_name']?.toString(),
      storeCode: json['store_code']?.toString(),
    );
  }
}

class AttributeMetadata {
  final String attributeId;
  final String attributeName;
  final int sortOrder;
  final bool isActive;
  final int optionCount;
  final List<AttributeOptionMetadata> options;

  const AttributeMetadata({
    required this.attributeId,
    required this.attributeName,
    required this.sortOrder,
    required this.isActive,
    required this.optionCount,
    required this.options,
  });

  factory AttributeMetadata.fromJson(Map<String, dynamic> json) {
    return AttributeMetadata(
      attributeId: json['attribute_id']?.toString() ?? '',
      attributeName: json['attribute_name']?.toString() ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
      optionCount: (json['option_count'] as num?)?.toInt() ?? 0,
      options: (json['options'] as List<dynamic>? ?? [])
          .map((e) => AttributeOptionMetadata.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}

class AttributeOptionMetadata {
  final String optionId;
  final String optionValue;
  final int sortOrder;
  final bool isActive;

  const AttributeOptionMetadata({
    required this.optionId,
    required this.optionValue,
    required this.sortOrder,
    required this.isActive,
  });

  factory AttributeOptionMetadata.fromJson(Map<String, dynamic> json) {
    return AttributeOptionMetadata(
      optionId: json['option_id']?.toString() ?? '',
      optionValue: json['option_value']?.toString() ?? '',
      sortOrder: (json['sort_order'] as num?)?.toInt() ?? 0,
      isActive: json['is_active'] as bool? ?? true,
    );
  }
}

/// Remote data source for inventory metadata
class InventoryMetadataDataSource {
  final SupabaseClient _client;

  InventoryMetadataDataSource(this._client);

  /// Get inventory metadata from RPC (returns raw JSON)
  Future<Map<String, dynamic>> getInventoryMetadataRaw({
    required String companyId,
    required String storeId,
  }) async {
    final response = await _client.rpc<Map<String, dynamic>>(
      'get_inventory_metadata_v2',
      params: {
        'p_company_id': companyId,
        'p_store_id': storeId,
      },
    ).single();

    if (response.containsKey('success') && response['success'] == false) {
      throw Exception(response['error'] ?? 'Failed to load inventory metadata');
    }

    return response;
  }

  /// Get inventory metadata from RPC (legacy - returns parsed object)
  @Deprecated('Use Repository with getInventoryMetadataRaw instead')
  Future<InventoryMetadata> getInventoryMetadata({
    required String companyId,
    required String storeId,
  }) async {
    final response = await getInventoryMetadataRaw(
      companyId: companyId,
      storeId: storeId,
    );
    return InventoryMetadata.fromJson(response);
  }
}
