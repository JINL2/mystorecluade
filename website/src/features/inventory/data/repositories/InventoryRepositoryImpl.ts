/**
 * InventoryRepositoryImpl
 * Implementation of IInventoryRepository interface
 */

import {
  IInventoryRepository,
  InventoryResult,
  UpdateProductData,
} from '../../domain/repositories/IInventoryRepository';
import { InventoryItem } from '../../domain/entities/InventoryItem';
import { InventoryDataSource } from '../datasources/InventoryDataSource';

export class InventoryRepositoryImpl implements IInventoryRepository {
  private dataSource: InventoryDataSource;

  constructor() {
    this.dataSource = new InventoryDataSource();
  }

  async getInventory(
    companyId: string,
    storeId: string | null,
    page: number = 1,
    limit: number = 20,
    search?: string
  ): Promise<InventoryResult> {
    try {
      const response = await this.dataSource.getInventory(companyId, storeId, page, limit, search);
      const data = response.products;

      const items = data.map((item: any) => {
        // Extract nested values
        const currentStock = item.stock?.quantity_on_hand || 0;
        const unitPrice = item.price?.selling || 0;
        const costPrice = item.price?.cost || 0;
        const totalValue = currentStock * unitPrice;

        return new InventoryItem(
          item.product_id,
          item.sku || 'N/A', // product_code
          item.product_name || 'Unknown',
          item.category_name || 'Uncategorized',
          item.brand_name || 'No Brand',
          currentStock,
          0, // min_stock - not provided by API
          0, // max_stock - not provided by API
          unitPrice,
          totalValue,
          item.unit || 'piece',
          '₩', // currency_symbol - hardcoded for now
          // Additional fields for editing
          item.category_id || null,
          item.brand_id || null,
          item.sku || '',
          item.barcode || '',
          item.product_type || 'commodity',
          costPrice
        );
      });

      return {
        success: true,
        data: items,
        currency: response.currency,
      };
    } catch (error) {
      console.error('Repository error fetching inventory:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch inventory',
      };
    }
  }

  async updateProduct(
    productId: string,
    companyId: string,
    storeId: string,
    data: UpdateProductData
  ): Promise<{ success: boolean; error?: string }> {
    try {
      return await this.dataSource.updateProduct(productId, companyId, storeId, data);
    } catch (error) {
      console.error('Repository error updating product:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to update product',
      };
    }
  }
}
