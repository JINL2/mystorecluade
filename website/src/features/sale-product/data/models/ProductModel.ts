/**
 * ProductModel
 * DTO and Mapper for Product entity
 */

import { Product } from '../../domain/entities/Product';

export interface ProductDTO {
  product_id: string;
  sku: string;
  product_name: string;
  brand_name: string;
  category_name: string;
  unit: string;
  image_urls: string[];
  price: {
    selling: number;
  };
  stock: {
    quantity_available: number;
  };
}

/**
 * ProductForSale interface
 * Used in presentation layer for product listing
 */
export interface ProductForSale {
  product_id: string;
  product_name: string;
  sku: string;
  barcode: string;
  brand_name: string;
  category_name: string;
  unit: string;
  image_urls: string[];
  selling_price: number;
  quantity_available: number;
}

export class ProductModel {
  /**
   * Convert DTO to Domain Entity
   */
  static toDomain(dto: ProductDTO): Product {
    return Product.create({
      id: dto.product_id,
      sku: dto.sku,
      name: dto.product_name,
      brandName: dto.brand_name,
      categoryName: dto.category_name,
      unit: dto.unit,
      imageUrls: dto.image_urls || [],
      sellingPrice: dto.price?.selling || 0,
      quantityAvailable: dto.stock?.quantity_available || 0,
    });
  }

  /**
   * Convert Domain Entity to DTO
   */
  static fromDomain(product: Product): ProductDTO {
    return {
      product_id: product.id,
      sku: product.sku,
      product_name: product.name,
      brand_name: product.brandName,
      category_name: product.categoryName,
      unit: product.unit,
      image_urls: product.imageUrls,
      price: {
        selling: product.sellingPrice,
      },
      stock: {
        quantity_available: product.quantityAvailable,
      },
    };
  }

  /**
   * Convert array of DTOs to Domain Entities
   */
  static toDomainList(dtos: ProductDTO[]): Product[] {
    return dtos.map((dto) => ProductModel.toDomain(dto));
  }

  /**
   * Convert ProductForSale (presentation layer) to Domain Entity
   * Used when adding products to cart from the product list
   */
  static fromSaleProduct(saleProduct: ProductForSale): Product {
    return Product.create({
      id: saleProduct.product_id,
      sku: saleProduct.sku,
      name: saleProduct.product_name,
      brandName: saleProduct.brand_name,
      categoryName: saleProduct.category_name,
      unit: saleProduct.unit,
      imageUrls: saleProduct.image_urls || [],
      sellingPrice: saleProduct.selling_price,
      quantityAvailable: saleProduct.quantity_available,
    });
  }
}
