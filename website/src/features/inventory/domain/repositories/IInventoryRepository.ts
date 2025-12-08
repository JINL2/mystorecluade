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
  imageUrls?: string[]; // Image URLs array for product images
}

export interface ImportExcelResult {
  success: boolean;
  summary?: {
    total_rows: number;
    created: number;
    updated: number;
    skipped: number;
    errors: number;
    logs_created: number;
  };
  errors?: Array<{
    row: number;
    error: string;
    barcode?: string;
    image_count?: number;
    unit?: string;
    data?: any;
  }>;
  message?: string;
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
    data: UpdateProductData,
    originalData?: any
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
   * @param defaultPrice - false = store price, true = default price (for existing products)
   */
  importExcel(
    companyId: string,
    storeId: string,
    userId: string,
    products: any[],
    defaultPrice?: boolean
  ): Promise<ImportExcelResult>;

  /**
   * Validate product edit before updating
   * Only validates fields that have changed
   */
  validateProductEdit(
    productId: string,
    companyId: string,
    originalProductName?: string,
    newProductName?: string,
    originalSku?: string,
    newSku?: string
  ): Promise<{ success: boolean; error?: { code: string; message: string; details?: string } }>;

  /**
   * Move product between stores
   */
  moveProduct(
    companyId: string,
    fromStoreId: string,
    toStoreId: string,
    productId: string,
    quantity: number,
    notes: string,
    time: string,
    updatedBy: string
  ): Promise<{ success: boolean; data?: any; error?: string }>;

  /**
   * Get base currency for the company
   */
  getBaseCurrency(companyId: string): Promise<{
    symbol: string;
    code: string;
  }>;

  /**
   * Get all inventory items for Excel export (no pagination)
   */
  getAllInventoryForExport(
    companyId: string,
    storeId: string | null,
    search?: string
  ): Promise<InventoryResult>;
}
