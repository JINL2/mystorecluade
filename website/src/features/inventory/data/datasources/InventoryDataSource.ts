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
      return {
        products: data.data?.products || [],
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
    productData: any
  ): Promise<{ success: boolean; error?: string }> {
    const supabase = supabaseService.getClient();

    const params = {
      p_product_id: productId,
      p_company_id: companyId,
      p_store_id: storeId,
      p_sku: productData.sku,
      p_product_name: productData.productName,
      p_category_id: productData.category || null,
      p_brand_id: productData.brand || null,
      p_unit: productData.unit || 'piece',
      p_product_type: productData.productType || 'commodity',
      p_cost_price: productData.costPrice,
      p_selling_price: productData.sellingPrice,
      p_new_quantity: productData.currentStock,
      p_image_urls: productData.imageUrls || null, // Image URLs array (JSONB)
    };

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
}
