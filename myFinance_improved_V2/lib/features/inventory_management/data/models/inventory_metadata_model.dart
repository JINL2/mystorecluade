// Data Model: Inventory Metadata Model (Compatibility Layer)
// This file maintains backward compatibility while delegating to DTO and Mapper
// New code should use InventoryMetadataDto and InventoryMetadataMapper directly

import '../../domain/entities/inventory_metadata.dart';
import '../dtos/inventory_metadata_dto.dart';
import '../mappers/inventory_metadata_mapper.dart';

/// @deprecated Use InventoryMetadataDto and InventoryMetadataMapper instead
/// This class is maintained for backward compatibility only
class InventoryMetadataModel extends InventoryMetadataDto {
  const InventoryMetadataModel({
    required super.stats,
    required super.units,
    required super.brands,
    required super.currency,
    required super.categories,
    required super.storeInfo,
    super.lastUpdated,
    required super.productTypes,
    required super.validationRules,
    required super.allowCustomValues,
    required super.stockStatusLevels,
  });

  factory InventoryMetadataModel.fromJson(Map<String, dynamic> json) {
    final dto = InventoryMetadataDto.fromJson(json);
    return InventoryMetadataModel(
      stats: dto.stats,
      units: dto.units,
      brands: dto.brands,
      currency: dto.currency,
      categories: dto.categories,
      storeInfo: dto.storeInfo,
      lastUpdated: dto.lastUpdated,
      productTypes: dto.productTypes,
      validationRules: dto.validationRules,
      allowCustomValues: dto.allowCustomValues,
      stockStatusLevels: dto.stockStatusLevels,
    );
  }

  // Mapper: Model → Entity - delegates to Mapper
  InventoryMetadata toEntity() {
    return InventoryMetadataMapper.toEntity(this);
  }
}

// Supporting Models - maintained for backward compatibility

/// @deprecated Use InventoryStatsDto instead
typedef InventoryStatsModel = InventoryStatsDto;

/// @deprecated Use BrandDto instead
typedef BrandModel = BrandDto;

/// @deprecated Use CurrencyDto instead
typedef CurrencyModel = CurrencyDto;

/// @deprecated Use CategoryDto instead
typedef CategoryModel = CategoryDto;

/// @deprecated Use StoreInfoDto instead
typedef StoreInfoModel = StoreInfoDto;

/// @deprecated Use ProductTypeDto instead
typedef ProductTypeModel = ProductTypeDto;

/// @deprecated Use ValidationRulesDto instead
typedef ValidationRulesModel = ValidationRulesDto;

/// @deprecated Use AllowCustomValuesDto instead
typedef AllowCustomValuesModel = AllowCustomValuesDto;

/// @deprecated Use StockStatusLevelDto instead
typedef StockStatusLevelModel = StockStatusLevelDto;
