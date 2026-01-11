// Mapper: Product DTO ↔ Product Entity
// Converts between Data Transfer Object and Domain Entity

import '../../domain/entities/product.dart';
import '../dtos/product_dto.dart';

class ProductMapper {
  // DTO → Entity
  static Product toEntity(ProductDto dto) {
    return Product(
      id: dto.id,
      sku: dto.sku ?? '',
      barcode: dto.barcode,
      name: dto.name,
      nameEn: null,
      description: dto.description,
      images: dto.imageUrls,
      categoryId: dto.categoryId,
      categoryName: dto.categoryName,
      brandId: dto.brandId,
      brandName: dto.brandName,
      productType: dto.productType ?? 'simple',
      tags: [],
      unit: dto.unit ?? 'piece',
      costPrice: dto.cost ?? 0.0,
      salePrice: dto.price,
      compareAtPrice: null,
      minPrice: null,
      currency: '',
      onHand: dto.stock,
      available: dto.quantityAvailable ?? dto.stock,
      reserved: dto.quantityReserved ?? 0,
      reorderPoint: null,
      reorderQuantity: null,
      minStock: dto.minStock,
      maxStock: dto.maxStock,
      location: null,
      warehouse: null,
      weight: null,
      averageDailySales: null,
      daysOnHand: null,
      turnoverRate: null,
      lastSold: null,
      lastReceived: null,
      lastCounted: null,
      countDiscrepancy: null,
      createdAt: dto.createdAt ?? DateTime.now(),
      updatedAt: dto.updatedAt ?? DateTime.now(),
      isActive: dto.isActive,
      sellInStore: true,
      sellOnline: false,
      attributes: null,
      // v6 variant fields
      variantId: dto.variantId,
      variantName: dto.variantName,
      variantSku: dto.variantSku,
      variantBarcode: dto.variantBarcode,
      displayName: dto.displayName,
      displaySku: dto.displaySku,
      displayBarcode: dto.displayBarcode,
      hasVariants: dto.hasVariants,
    );
  }

  // Entity → DTO
  static ProductDto fromEntity(Product entity) {
    return ProductDto(
      id: entity.id,
      name: entity.name,
      sku: entity.sku,
      barcode: entity.barcode,
      price: entity.salePrice,
      cost: entity.costPrice,
      stock: entity.onHand,
      minStock: entity.minStock,
      maxStock: entity.maxStock,
      unit: entity.unit,
      categoryId: entity.categoryId,
      categoryName: entity.categoryName,
      brandId: entity.brandId,
      brandName: entity.brandName,
      productType: entity.productType,
      description: entity.description,
      imageUrls: entity.images,
      isActive: entity.isActive,
      stockStatus: entity.getStockStatus().name,
      quantityAvailable: entity.available,
      quantityReserved: entity.reserved,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      // v6 variant fields
      variantId: entity.variantId,
      variantName: entity.variantName,
      variantSku: entity.variantSku,
      variantBarcode: entity.variantBarcode,
      displayName: entity.displayName,
      displaySku: entity.displaySku,
      displayBarcode: entity.displayBarcode,
      hasVariants: entity.hasVariants,
    );
  }
}
