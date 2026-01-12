// Mapper: Inventory Metadata DTO ↔ Inventory Metadata Entity
// Converts between Data Transfer Objects and Domain Entities

import '../../domain/entities/inventory_metadata.dart';
import '../dtos/inventory_metadata_dto.dart';

/// Main Mapper
class InventoryMetadataMapper {
  // DTO → Entity
  static InventoryMetadata toEntity(InventoryMetadataDto dto) {
    return InventoryMetadata(
      stats: InventoryStatsMapper.toEntity(dto.stats),
      units: dto.units,
      brands: dto.brands.map((b) => BrandMapper.toEntity(b)).toList(),
      currency: CurrencyMapper.toEntity(dto.currency),
      categories: dto.categories.map((c) => CategoryMapper.toEntity(c)).toList(),
      storeInfo: StoreInfoMapper.toEntity(dto.storeInfo),
      lastUpdated: dto.lastUpdated,
      productTypes: dto.productTypes.map((pt) => ProductTypeMapper.toEntity(pt)).toList(),
      validationRules: ValidationRulesMapper.toEntity(dto.validationRules),
      allowCustomValues: AllowCustomValuesMapper.toEntity(dto.allowCustomValues),
      stockStatusLevels: dto.stockStatusLevels.map((ssl) => StockStatusLevelMapper.toEntity(ssl)).toList(),
      attributes: dto.attributes.map((a) => AttributeMapper.toEntity(a)).toList(),
    );
  }
}

/// Supporting Mappers

class InventoryStatsMapper {
  static InventoryStats toEntity(InventoryStatsDto dto) {
    return InventoryStats(
      totalBrands: dto.totalBrands,
      totalProducts: dto.totalProducts,
      activeProducts: dto.activeProducts,
      totalCategories: dto.totalCategories,
      inactiveProducts: dto.inactiveProducts,
    );
  }
}

class BrandMapper {
  static Brand toEntity(BrandDto dto) {
    return Brand(
      id: dto.id,
      name: dto.name,
      productCount: dto.productCount,
    );
  }
}

class CurrencyMapper {
  static Currency toEntity(CurrencyDto dto) {
    return Currency(
      code: dto.code,
      name: dto.name,
      symbol: dto.symbol,
    );
  }
}

class CategoryMapper {
  static Category toEntity(CategoryDto dto) {
    return Category(
      id: dto.id,
      name: dto.name,
      parentId: dto.parentId,
      productCount: dto.productCount,
      subcategories: dto.subcategories?.map((c) => toEntity(c)).toList(),
    );
  }
}

class StoreInfoMapper {
  static StoreInfo toEntity(StoreInfoDto dto) {
    return StoreInfo(
      storeId: dto.storeId,
      storeCode: dto.storeCode,
      storeName: dto.storeName,
    );
  }
}

class ProductTypeMapper {
  static ProductType toEntity(ProductTypeDto dto) {
    return ProductType(
      label: dto.label,
      value: dto.value,
      description: dto.description,
      productCount: dto.productCount,
    );
  }
}

class ValidationRulesMapper {
  static ValidationRules toEntity(ValidationRulesDto dto) {
    return ValidationRules(
      skuPattern: dto.skuPattern,
      barcodePattern: dto.barcodePattern,
      maxStockRequired: dto.maxStockRequired,
      minPriceRequired: dto.minPriceRequired,
    );
  }
}

class AllowCustomValuesMapper {
  static AllowCustomValues toEntity(AllowCustomValuesDto dto) {
    return AllowCustomValues(
      units: dto.units,
      brands: dto.brands,
      categories: dto.categories,
    );
  }
}

class StockStatusLevelMapper {
  static StockStatusLevel toEntity(StockStatusLevelDto dto) {
    return StockStatusLevel(
      icon: dto.icon,
      color: dto.color,
      label: dto.label,
      level: dto.level,
    );
  }
}

class AttributeMapper {
  static Attribute toEntity(AttributeDto dto) {
    return Attribute(
      id: dto.id,
      name: dto.name,
      sortOrder: dto.sortOrder,
      isActive: dto.isActive,
      optionCount: dto.optionCount,
      options: dto.options.map((o) => AttributeOptionMapper.toEntity(o)).toList(),
    );
  }
}

class AttributeOptionMapper {
  static AttributeOption toEntity(AttributeOptionDto dto) {
    return AttributeOption(
      id: dto.id,
      value: dto.value,
      sortOrder: dto.sortOrder,
      isActive: dto.isActive,
    );
  }
}
