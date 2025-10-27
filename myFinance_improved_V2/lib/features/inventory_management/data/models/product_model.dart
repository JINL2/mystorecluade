// Data Model: Product Model (Compatibility Layer)
// This file maintains backward compatibility while delegating to DTO and Mapper
// New code should use ProductDto and ProductMapper directly

import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';
import '../mappers/product_mapper.dart';

/// @deprecated Use ProductDto and ProductMapper instead
/// This class is maintained for backward compatibility only
class ProductModel extends ProductDto {
  const ProductModel({
    required super.id,
    required super.name,
    super.sku,
    super.barcode,
    required super.price,
    super.cost,
    required super.stock,
    super.minStock,
    super.maxStock,
    super.unit,
    super.categoryId,
    super.categoryName,
    super.brandId,
    super.brandName,
    super.productType,
    super.description,
    super.imageUrl,
    super.isActive = true,
    super.stockStatus,
    super.quantityAvailable,
    super.quantityReserved,
    super.createdAt,
    super.updatedAt,
  });

  // From JSON - delegates to ProductDto
  factory ProductModel.fromJson(Map<String, dynamic> json) {
    final dto = ProductDto.fromJson(json);
    return ProductModel(
      id: dto.id,
      name: dto.name,
      sku: dto.sku,
      barcode: dto.barcode,
      price: dto.price,
      cost: dto.cost,
      stock: dto.stock,
      minStock: dto.minStock,
      maxStock: dto.maxStock,
      unit: dto.unit,
      categoryId: dto.categoryId,
      categoryName: dto.categoryName,
      brandId: dto.brandId,
      brandName: dto.brandName,
      productType: dto.productType,
      description: dto.description,
      imageUrl: dto.imageUrl,
      isActive: dto.isActive,
      stockStatus: dto.stockStatus,
      quantityAvailable: dto.quantityAvailable,
      quantityReserved: dto.quantityReserved,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }

  // Mapper: Model → Entity - delegates to ProductMapper
  Product toEntity() {
    return ProductMapper.toEntity(this);
  }

  // Mapper: Entity → Model - delegates to ProductMapper
  factory ProductModel.fromEntity(Product entity) {
    final dto = ProductMapper.fromEntity(entity);
    return ProductModel(
      id: dto.id,
      name: dto.name,
      sku: dto.sku,
      barcode: dto.barcode,
      price: dto.price,
      cost: dto.cost,
      stock: dto.stock,
      minStock: dto.minStock,
      maxStock: dto.maxStock,
      unit: dto.unit,
      categoryId: dto.categoryId,
      categoryName: dto.categoryName,
      brandId: dto.brandId,
      brandName: dto.brandName,
      productType: dto.productType,
      description: dto.description,
      imageUrl: dto.imageUrl,
      isActive: dto.isActive,
      stockStatus: dto.stockStatus,
      quantityAvailable: dto.quantityAvailable,
      quantityReserved: dto.quantityReserved,
      createdAt: dto.createdAt,
      updatedAt: dto.updatedAt,
    );
  }
}
