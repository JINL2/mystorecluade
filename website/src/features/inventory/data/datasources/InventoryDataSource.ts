/**
 * InventoryDataSource
 * Data source for inventory operations
 */

import { supabaseService } from '@/core/services/supabase_service';

interface InventoryResponse {
  products: any[];
  currency?: {
    symbol?: string;
    code?: string;
    name?: string;
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
      console.error('Error fetching inventory:', error);
      throw new Error(error.message);
    }

    // Handle direct success wrapper format: { success: true, data: { products: [], pagination: {}, currency: {} } }
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      return {
        products: data.data?.products || [],
        currency: data.data?.currency,
      };
    }

    // Fallback
    console.error('Unexpected data format:', data);
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
    };

    console.log('🔍 Update Product RPC Call:', {
      productId,
      companyId,
      storeId,
      productData,
      params,
    });

    const { data, error } = await supabase.rpc('inventory_edit_product', params);

    console.log('📥 Update Product RPC Response:', { data, error });

    if (error) {
      console.error('❌ Error updating product:', error);
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      console.log('✅ Success wrapper detected:', data);
      if (data.success === true) {
        return {
          success: true,
        };
      } else {
        console.error('❌ RPC returned failure:', data.error);
        return {
          success: false,
          error: data.error?.message || 'Failed to update product',
        };
      }
    }

    console.log('✅ Update product successful (no wrapper)');
    return {
      success: true,
    };
  }
}
