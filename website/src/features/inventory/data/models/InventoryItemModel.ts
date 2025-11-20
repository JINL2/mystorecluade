/**
 * InventoryItemModel
 * DTO (Data Transfer Object) and Mapper for InventoryItem entity
 * Handles conversion between database schema and domain entity
 */

import { InventoryItem } from '../../domain/entities/InventoryItem';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * Raw inventory item data from database/RPC
 * Represents the data structure returned by get_inventory_page RPC
 */
export interface InventoryItemDTO {
  product_id: string;
  sku: string;
  barcode?: string;
  product_name: string;
  category_id?: string | null;
  category_name?: string;
  brand_id?: string | null;
  brand_name?: string;
  unit?: string;
  product_type?: string;
  stock?: {
    quantity_on_hand?: number;
  };
  price?: {
    cost?: number;
    selling?: number;
  };
  image_urls?: string[];  // 제품 이미지 URL 배열
  created_at?: string;
  updated_at?: string;
}

/**
 * InventoryItemModel class - handles data transformation
 */
export class InventoryItemModel {
  /**
   * Convert raw database/RPC data to InventoryItem entity
   * @param json - Raw data from database
   * @param defaultCurrencySymbol - Default currency symbol to use
   * @returns InventoryItem domain entity
   */
  static fromJson(json: InventoryItemDTO, defaultCurrencySymbol: string = '₩'): InventoryItem {
    // Extract nested values with fallbacks
    const currentStock = json.stock?.quantity_on_hand ?? 0;
    const unitPrice = json.price?.selling ?? 0;
    const costPrice = json.price?.cost ?? 0;
    const totalValue = currentStock * unitPrice;

    // Convert UTC created_at to Local Date object
    const createdAt = json.created_at ? DateTimeUtils.toLocalSafe(json.created_at) : undefined;

    return new InventoryItem(
      json.product_id,
      json.sku || 'N/A',
      json.product_name || 'Unknown Product',
      json.category_name || 'Uncategorized',
      json.brand_name || 'No Brand',
      currentStock,
      0, // min_stock - not provided by API currently
      0, // max_stock - not provided by API currently
      unitPrice,
      totalValue,
      json.unit || 'piece',
      defaultCurrencySymbol,
      // Additional fields for editing
      json.category_id || null,
      json.brand_id || null,
      json.sku || '',
      json.barcode || '',
      json.product_type || 'commodity',
      costPrice,
      createdAt ?? undefined,  // Local Date 객체 또는 undefined
      json.image_urls || []  // 제품 이미지 URL 배열
    );
  }

  /**
   * Convert InventoryItem entity to database format (for create/update operations)
   * @param item - InventoryItem domain entity
   * @returns InventoryItemDTO for database operations
   */
  static toJson(item: InventoryItem): InventoryItemDTO {
    return {
      product_id: item.productId,
      sku: item.sku,
      barcode: item.barcode,
      product_name: item.productName,
      category_id: item.categoryId,
      category_name: item.categoryName,
      brand_id: item.brandId,
      brand_name: item.brandName,
      unit: item.unit,
      product_type: item.productType,
      stock: {
        quantity_on_hand: item.currentStock,
      },
      price: {
        cost: item.costPrice,
        selling: item.unitPrice,
      },
    };
  }

  /**
   * Batch convert multiple inventory items from JSON
   * @param jsonArray - Array of raw data from database
   * @param defaultCurrencySymbol - Default currency symbol to use
   * @returns Array of InventoryItem domain entities
   */
  static fromJsonArray(
    jsonArray: InventoryItemDTO[],
    defaultCurrencySymbol: string = '₩'
  ): InventoryItem[] {
    return jsonArray.map((json) => InventoryItemModel.fromJson(json, defaultCurrencySymbol));
  }

  /**
   * Convert update data format to RPC parameters
   * Used for inventory_edit_product RPC call
   * @param productId - Product ID to update
   * @param companyId - Company ID
   * @param storeId - Store ID
   * @param data - Update data
   * @returns RPC parameters object
   */
  static toUpdateParams(
    productId: string,
    companyId: string,
    storeId: string,
    data: {
      productName: string;
      category: string;
      brand: string;
      productType: string;
      barcode: string;
      sku: string;
      currentStock: number;
      unit: string;
      costPrice: number;
      sellingPrice: number;
    }
  ) {
    return {
      p_product_id: productId,
      p_company_id: companyId,
      p_store_id: storeId,
      p_sku: data.sku,
      p_product_name: data.productName,
      p_category_id: data.category || null,
      p_brand_id: data.brand || null,
      p_unit: data.unit || 'piece',
      p_product_type: data.productType || 'commodity',
      p_cost_price: data.costPrice,
      p_selling_price: data.sellingPrice,
      p_new_quantity: data.currentStock,
    };
  }
}
