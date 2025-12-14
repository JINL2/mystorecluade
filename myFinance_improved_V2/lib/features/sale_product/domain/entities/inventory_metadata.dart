/// Inventory metadata entity
class InventoryMetadata {
  final List<BrandMetadata> brands;
  final List<CategoryMetadata> categories;
  final List<ProductTypeMetadata> productTypes;
  final List<UnitMetadata> units;
  final StatsMetadata stats;
  final CurrencyMetadata? currency;
  final StoreInfoMetadata? storeInfo;

  const InventoryMetadata({
    required this.brands,
    required this.categories,
    required this.productTypes,
    required this.units,
    required this.stats,
    this.currency,
    this.storeInfo,
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
      );
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
}
