/**
 * ProductModel
 * DTO and Mapper for Product entity
 * v6: Added variant support
 */

import { Product } from '../../domain/entities/Product';

/**
 * ProductDTO - v6 response structure
 * Maps to get_inventory_page_v6 RPC response items
 */
export interface ProductDTO {
  product_id: string;
  product_sku: string;
  product_name: string;
  brand_name: string;
  category_name: string;
  unit: string;
  image_urls: string[];
  price: {
    cost: number;
    selling: number;
  };
  stock: {
    quantity_available: number;
    quantity_on_hand: number;
  };
  // v6: variant fields
  variant_id: string | null;
  variant_name: string | null;
  variant_sku: string | null;
  variant_barcode: string | null;
  // v6: display fields (pre-formatted for UI)
  display_name: string;
  display_sku: string;
  display_barcode: string;
  // v6: meta fields
  has_variants: boolean;
}

/**
 * ProductForSale interface
 * Used in presentation layer for product listing
 * v6: Added variant support
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
  cost_price: number;
  selling_price: number;
  quantity_available: number;
  // v6: variant fields
  variant_id: string | null;
  variant_name: string | null;
  display_name: string;
  display_sku: string;
  has_variants: boolean;
}

export class ProductModel {
  /**
   * Convert DTO to Domain Entity
   * v6: Added variant field mapping
   */
  static toDomain(dto: ProductDTO): Product {
    return Product.create({
      id: dto.product_id,
      sku: dto.product_sku,
      name: dto.product_name,
      brandName: dto.brand_name,
      categoryName: dto.category_name,
      unit: dto.unit,
      imageUrls: dto.image_urls || [],
      sellingPrice: dto.price?.selling || 0,
      costPrice: dto.price?.cost || 0,
      quantityAvailable: dto.stock?.quantity_available || 0,
      // v6: variant fields
      variantId: dto.variant_id,
      variantName: dto.variant_name,
      displayName: dto.display_name || dto.product_name,
      displaySku: dto.display_sku || dto.product_sku,
      hasVariants: dto.has_variants ?? false,
    });
  }

  /**
   * Convert Domain Entity to DTO
   * v6: Added variant field mapping
   */
  static fromDomain(product: Product): ProductDTO {
    return {
      product_id: product.id,
      product_sku: product.sku,
      product_name: product.name,
      brand_name: product.brandName,
      category_name: product.categoryName,
      unit: product.unit,
      image_urls: product.imageUrls,
      price: {
        cost: product.costPrice,
        selling: product.sellingPrice,
      },
      stock: {
        quantity_available: product.quantityAvailable,
        quantity_on_hand: product.quantityAvailable,
      },
      // v6: variant fields
      variant_id: product.variantId,
      variant_name: product.variantName,
      variant_sku: product.variantId ? product.sku : null,
      variant_barcode: null,
      display_name: product.displayName,
      display_sku: product.displaySku,
      display_barcode: product.displaySku,
      has_variants: product.hasVariants,
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
   * v6: Added variant field mapping
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
      costPrice: saleProduct.cost_price || 0,
      quantityAvailable: saleProduct.quantity_available,
      // v6: variant fields
      variantId: saleProduct.variant_id,
      variantName: saleProduct.variant_name,
      displayName: saleProduct.display_name || saleProduct.product_name,
      displaySku: saleProduct.display_sku || saleProduct.sku,
      hasVariants: saleProduct.has_variants ?? false,
    });
  }
}
