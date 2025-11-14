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
  pagination?: {
    total_count?: number; // Frontend expects this
    total?: number;        // Backend returns this
    page?: number;
    limit?: number;
    total_pages?: number;
    has_next?: boolean;
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

export interface ImportExcelResult {
  success: boolean;
  summary?: {
    created: number;
    updated: number;
    skipped: number;
    errors: number;
  };
  errors?: Array<{
    row: number;
    error: string;
    data?: any;
  }>;
  error?: string;
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

  /**
   * Import products from Excel file data
   */
  importExcel(
    companyId: string,
    storeId: string,
    userId: string,
    products: any[]
  ): Promise<ImportExcelResult>;
}
