/**
 * ProductModel
 * DTO and Mapper for Product entity (order context)
 */

import { ProductDTO } from '../datasources/ProductDataSource';

/**
 * Product entity for order context
 */
export interface Product {
  product_id: string;
  product_name: string;
  sku?: string;
  barcode?: string;
  unit_of_measure?: string;
  selling_price: number;
  quantity_on_hand: number;
  is_active: boolean;
  is_deleted: boolean;
}

export class ProductModel {
  /**
   * Convert ProductDTO to Product entity
   */
  static fromJson(dto: ProductDTO): Product {
    return {
      product_id: dto.product_id,
      product_name: dto.product_name,
      sku: dto.sku,
      barcode: dto.barcode,
      unit_of_measure: dto.unit_of_measure,
      selling_price: dto.pricing?.selling_price ?? 0,
      quantity_on_hand: dto.total_stock_summary?.total_quantity_on_hand ?? 0,
      is_active: dto.status?.is_active ?? true,
      is_deleted: dto.status?.is_deleted ?? false,
    };
  }

  /**
   * Batch convert multiple products
   */
  static fromJsonArray(dtoArray: ProductDTO[]): Product[] {
    return dtoArray.map((dto) => ProductModel.fromJson(dto));
  }
}
