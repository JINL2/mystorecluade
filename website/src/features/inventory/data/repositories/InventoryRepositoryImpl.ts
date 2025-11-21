/**
 * InventoryRepositoryImpl
 * Implementation of IInventoryRepository interface
 */

import {
  IInventoryRepository,
  InventoryResult,
  UpdateProductData,
  ImportExcelResult,
} from '../../domain/repositories/IInventoryRepository';
import { InventoryItem } from '../../domain/entities/InventoryItem';
import { InventoryMetadata } from '../../domain/entities/InventoryMetadata';
import { InventoryDataSource } from '../datasources/InventoryDataSource';
import { InventoryItemModel } from '../models/InventoryItemModel';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

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

      // Use InventoryItemModel to convert raw data to domain entities
      const currencySymbol = response.currency?.symbol || '₩';
      const items = InventoryItemModel.fromJsonArray(data, currencySymbol);

      return {
        success: true,
        data: items,
        currency: response.currency,
        pagination: response.pagination,
      };
    } catch (error) {
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
    data: UpdateProductData,
    originalData?: any
  ): Promise<{ success: boolean; error?: string }> {
    try {
      return await this.dataSource.updateProduct(productId, companyId, storeId, data, originalData);
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to update product',
      };
    }
  }

  async getMetadata(
    companyId: string,
    storeId?: string
  ): Promise<{ success: boolean; data?: InventoryMetadata; error?: string }> {
    try {
      const response = await this.dataSource.getMetadata(companyId, storeId);

      if (response && response.success && response.data) {
        // Convert last_updated from UTC to Local Date, then back to ISO string for display
        const metadata = {
          ...response.data,
          last_updated: response.data.last_updated
            ? DateTimeUtils.toLocal(response.data.last_updated).toISOString()
            : response.data.last_updated,
        };

        return {
          success: true,
          data: metadata,
        };
      } else {
        return {
          success: false,
          error: 'Invalid metadata response format',
        };
      }
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch metadata',
      };
    }
  }

  async importExcel(
    companyId: string,
    storeId: string,
    userId: string,
    products: any[]
  ): Promise<ImportExcelResult> {
    try {
      return await this.dataSource.importExcel(companyId, storeId, userId, products);
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to import Excel data',
      };
    }
  }

  async validateProductEdit(
    productId: string,
    companyId: string,
    originalProductName?: string,
    newProductName?: string,
    originalSku?: string,
    newSku?: string
  ): Promise<{ success: boolean; error?: { code: string; message: string; details?: string } }> {
    try {
      return await this.dataSource.validateProductEdit(
        productId,
        companyId,
        originalProductName,
        newProductName,
        originalSku,
        newSku
      );
    } catch (error) {
      return {
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: error instanceof Error ? error.message : 'Failed to validate product edit',
        },
      };
    }
  }

  async moveProduct(
    companyId: string,
    fromStoreId: string,
    toStoreId: string,
    productId: string,
    quantity: number,
    notes: string,
    time: string,
    updatedBy: string
  ): Promise<{ success: boolean; data?: any; error?: string }> {
    try {
      return await this.dataSource.moveProduct(
        companyId,
        fromStoreId,
        toStoreId,
        productId,
        quantity,
        notes,
        time,
        updatedBy
      );
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to move product',
      };
    }
  }
}
