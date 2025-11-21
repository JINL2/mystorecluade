/**
 * InventoryDataSource
 * Data source for inventory operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryMetadataResponse } from '../../domain/entities/InventoryMetadata';

interface InventoryResponse {
  products: any[];
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
}

export class InventoryDataSource {
  async getInventory(
    companyId: string,
    storeId: string | null,
    page: number = 1,
    limit: number = 20,
    search?: string
  ): Promise<InventoryResponse> {
    const supabase = supabaseService.getClient();

    // If no company ID, return empty result
    if (!companyId) {
      return { products: [] };
    }

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
    };

    // Add search parameter if search term exists
    if (search && search.trim() !== '') {
      rpcParams.p_search = search.trim();
    }

    // RPC 'get_inventory_page' should return products ordered by created_at DESC (newest first)
    // If ordering is incorrect, check the database function definition
    const { data, error } = await supabase.rpc('get_inventory_page', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    // Handle direct success wrapper format: { success: true, data: { products: [], pagination: {}, currency: {} } }
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      const products = data.data?.products || [];

      return {
        products: products,
        currency: data.data?.currency,
        pagination: data.data?.pagination,
      };
    }

    // Fallback
    throw new Error('Invalid response format from get_inventory_page');
  }

  async updateProduct(
    productId: string,
    companyId: string,
    storeId: string,
    productData: any,
    originalData?: any
  ): Promise<{ success: boolean; error?: string }> {
    const supabase = supabaseService.getClient();

    // Build params - only include fields that changed or are always required
    const params: any = {
      p_product_id: productId,
      p_company_id: companyId,
      p_store_id: storeId,
    };

    // Only include product name if it changed
    if (!originalData || productData.productName !== originalData.productName) {
      params.p_product_name = productData.productName;
    }

    // Only include SKU if it changed
    if (!originalData || productData.sku !== originalData.sku) {
      params.p_sku = productData.sku;
    }

    // Include other fields if they changed or are new
    if (!originalData || productData.category !== originalData.categoryId) {
      params.p_category_id = productData.category || null;
    }

    if (!originalData || productData.brand !== originalData.brandId) {
      params.p_brand_id = productData.brand || null;
    }

    if (!originalData || productData.unit !== originalData.unit) {
      params.p_unit = productData.unit || 'piece';
    }

    if (!originalData || productData.productType !== originalData.productType) {
      params.p_product_type = productData.productType || 'commodity';
    }

    if (!originalData || productData.costPrice !== originalData.costPrice) {
      params.p_cost_price = productData.costPrice;
    }

    if (!originalData || productData.sellingPrice !== originalData.unitPrice) {
      params.p_selling_price = productData.sellingPrice;
    }

    if (!originalData || productData.currentStock !== originalData.currentStock) {
      params.p_new_quantity = productData.currentStock;
    }

    // Always include image URLs if provided (array comparison is complex)
    if (productData.imageUrls !== undefined) {
      params.p_image_urls = productData.imageUrls || null;
    }

    const { data, error } = await supabase.rpc('inventory_edit_product', params);

    if (error) {
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      if (data.success === true) {
        return {
          success: true,
        };
      } else {
        return {
          success: false,
          error: data.error?.message || 'Failed to update product',
        };
      }
    }

    return {
      success: true,
    };
  }

  async getMetadata(
    companyId: string,
    storeId?: string
  ): Promise<InventoryMetadataResponse> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_inventory_metadata', {
      p_company_id: companyId,
      p_store_id: storeId || null,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data as InventoryMetadataResponse;
  }

  async importExcel(
    companyId: string,
    storeId: string,
    userId: string,
    products: any[]
  ): Promise<{ success: boolean; summary?: any; errors?: any[]; error?: string }> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('inventory_import_excel', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_user_id: userId,
      p_products: products,
    });

    if (error) {
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      return {
        success: data.success,
        summary: data.summary,
        errors: data.errors,
      };
    }

    return {
      success: false,
      error: 'Invalid response format from inventory_import_excel',
    };
  }

  async validateProductEdit(
    productId: string,
    companyId: string,
    originalProductName?: string,
    newProductName?: string,
    originalSku?: string,
    newSku?: string
  ): Promise<{ success: boolean; error?: { code: string; message: string; details?: string } }> {
    const supabase = supabaseService.getClient();

    // Build validation params - only include fields that changed
    const validationParams: any = {
      p_product_id: productId,
      p_company_id: companyId,
    };

    // Only validate product name if it changed
    if (newProductName && newProductName.trim() !== originalProductName) {
      validationParams.p_product_name = newProductName.trim();
    }

    // Only validate SKU if it changed
    if (newSku && newSku.trim() !== originalSku) {
      validationParams.p_sku = newSku.trim();
    }

    const { data, error } = await supabase.rpc('inventory_check_edit', validationParams);

    if (error) {
      return {
        success: false,
        error: {
          code: 'RPC_ERROR',
          message: error.message,
        },
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      return data as { success: boolean; error?: { code: string; message: string; details?: string } };
    }

    return {
      success: false,
      error: {
        code: 'INVALID_RESPONSE',
        message: 'Invalid response format from inventory_check_edit',
      },
    };
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
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('inventory_move_product', {
      p_company_id: companyId,
      p_from_store_id: fromStoreId,
      p_to_store_id: toStoreId,
      p_items: [
        {
          product_id: productId,
          quantity: quantity,
        },
      ],
      p_notes: notes || null,
      p_time: time,
      p_updated_by: updatedBy,
    });

    if (error) {
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      return data as { success: boolean; data?: any; error?: string };
    }

    return {
      success: false,
      error: 'Invalid response format from inventory_move_product',
    };
  }
}
