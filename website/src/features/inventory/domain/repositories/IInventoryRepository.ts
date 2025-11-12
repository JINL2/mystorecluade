/**
 * IInventoryRepository Interface
 * Repository interface for inventory operations
 */

import { InventoryItem } from '../entities/InventoryItem';
import { InventoryMetadata } from '../entities/InventoryMetadata';

export interface InventoryResult {
  success: boolean;
  data?: InventoryItem[];
  currency?: {
    symbol?: string;
    code?: string;
    name?: string;
  };
  error?: string;
}

export interface UpdateProductData {
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

export interface IInventoryRepository {
  /**
   * Get inventory items for a store with pagination
   */
  getInventory(
    companyId: string,
    storeId: string | null,
    page?: number,
    limit?: number,
    search?: string
  ): Promise<InventoryResult>;

  /**
   * Update product information
   */
  updateProduct(
    productId: string,
    companyId: string,
    storeId: string,
    data: UpdateProductData
  ): Promise<{ success: boolean; error?: string }>;

  /**
   * Get inventory metadata (categories, brands, units, product types)
   */
  getMetadata(
    companyId: string,
    storeId?: string
  ): Promise<{ success: boolean; data?: InventoryMetadata; error?: string }>;
}
