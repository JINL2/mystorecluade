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

export interface ProductHistoryItem {
  log_id: string;
  event_category: 'stock' | 'price' | 'product';
  event_type: string;
  // Stock fields
  quantity_before?: number;
  quantity_after?: number;
  quantity_change?: number;
  // Price fields
  cost_before?: number;
  cost_after?: number;
  selling_price_before?: number;
  selling_price_after?: number;
  min_price_before?: number;
  min_price_after?: number;
  // Product fields
  name_before?: string;
  name_after?: string;
  sku_before?: string;
  sku_after?: string;
  barcode_before?: string;
  barcode_after?: string;
  brand_id_before?: string;
  brand_id_after?: string;
  brand_name_before?: string;
  brand_name_after?: string;
  category_id_before?: string;
  category_id_after?: string;
  category_name_before?: string;
  category_name_after?: string;
  weight_before?: number;
  weight_after?: number;
  // Reference fields
  invoice_id?: string;
  invoice_number?: string;
  transfer_id?: string;
  from_store_id?: string;
  from_store_name?: string;
  to_store_id?: string;
  to_store_name?: string;
  // Other fields
  reason?: string;
  notes?: string;
  created_by?: string;
  created_user?: string;
  created_at: string;
}

export interface ProductHistoryResponse {
  success: boolean;
  message?: string;
  error?: string;
  detail?: string;
  data: ProductHistoryItem[];
  total_count: number;
  page: number;
  page_size: number;
  total_pages: number;
}

export class InventoryDataSource {
  /**
   * Transform v3 product response to flat structure for frontend compatibility
   */
  private transformV3Product(product: any): any {
    return {
      product_id: product.product_id,
      sku: product.sku,
      barcode: product.barcode,
      product_name: product.product_name,
      product_type: product.product_type,
      brand_name: product.brand_name,
      category_name: product.category_name,
      unit: product.unit,
      image_urls: product.image_urls || [],
      created_at: product.created_at,
      // Flatten stock object
      quantity_on_hand: product.stock?.quantity_on_hand ?? 0,
      quantity_available: product.stock?.quantity_available ?? 0,
      quantity_reserved: product.stock?.quantity_reserved ?? 0,
      // Flatten price object
      cost_price: product.price?.cost ?? 0,
      selling_price: product.price?.selling ?? 0,
      price_source: product.price?.source ?? 'default',
      // Flatten status object
      stock_level: product.status?.stock_level ?? 'normal',
      is_active: product.status?.is_active ?? true,
      // Recent changes (keep as-is for potential future use)
      recent_changes: product.recent_changes || [],
    };
  }

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

    // v3 requires store_id - if null, return empty
    if (!storeId) {
      return { products: [] };
    }

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_timezone: userTimezone,
    };

    // Add search parameter if search term exists
    if (search && search.trim() !== '') {
      rpcParams.p_search = search.trim();
    }

    // RPC 'get_inventory_page_v3' returns products with nested stock/price/status objects
    const { data, error } = await supabase.rpc('get_inventory_page_v3', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    // Handle success wrapper format: { success: true, data: { products: [], pagination: {}, currency: {} } }
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      const rawProducts = data.data?.products || [];
      // Transform v3 nested structure to flat structure
      const products = rawProducts.map((p: any) => this.transformV3Product(p));

      return {
        products: products,
        currency: data.data?.currency,
        pagination: data.data?.pagination,
      };
    }

    // Fallback
    throw new Error('Invalid response format from get_inventory_page_v3');
  }

  async updateProduct(
    productId: string,
    companyId: string,
    storeId: string,
    productData: any,
    originalData?: any,
    userId?: string
  ): Promise<{ success: boolean; error?: string; data?: any }> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    // Build params for v4 - p_created_by is required
    const params: any = {
      p_product_id: productId,
      p_company_id: companyId,
      p_store_id: storeId,
      p_created_by: userId || productData.userId, // Required for v4
      p_updated_at: new Date().toISOString(),
      p_timezone: userTimezone,
      p_default_price: productData.defaultPrice ?? false, // false = store price, true = default price
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
      params.p_flow_type = productData.flowType || 'adjust'; // Flow type for stock changes
    }

    // Always include image URLs if provided (array comparison is complex)
    if (productData.imageUrls !== undefined) {
      params.p_image_urls = productData.imageUrls || null;
    }

    const { data, error } = await supabase.rpc('inventory_edit_product_v4', params);

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
          data: data.data, // Include response data (updated_fields, stock_change, logs_created)
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
    products: any[],
    defaultPrice: boolean = false
  ): Promise<{ success: boolean; summary?: any; errors?: any[]; message?: string; error?: string }> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_user_id: userId,
      p_products: products,
      p_default_price: defaultPrice, // false = store price, true = default price
      p_time: new Date().toISOString(),
      p_timezone: userTimezone,
    };

    const { data, error } = await supabase.rpc('inventory_import_excel_v4', rpcParams);

    if (error) {
      console.error('📦 [Import Excel] RPC error:', error);
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      // Log errors with details if any
      if (data.errors && data.errors.length > 0) {
        console.error('📦 [Import Excel] Errors:', data.errors.map((e: any) =>
          `Row ${e.row}: ${e.error}${e.sku ? ` (SKU: ${e.sku})` : ''}${e.barcode ? ` (Barcode: ${e.barcode})` : ''}`
        ));
      }
      return {
        success: data.success,
        summary: data.summary,
        errors: data.errors,
        message: data.message,
      };
    }

    console.error('📦 [Import Excel] Invalid response format:', data);
    return {
      success: false,
      error: 'Invalid response format from inventory_import_excel_v4',
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
    _time: string, // Unused - we use current time with timezone
    updatedBy: string
  ): Promise<{ success: boolean; data?: any; error?: string }> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams = {
      p_company_id: companyId,
      p_from_store_id: fromStoreId,
      p_to_store_id: toStoreId,
      p_items: [
        {
          product_id: productId,
          quantity: quantity,
        },
      ],
      p_updated_by: updatedBy,
      p_time: new Date().toISOString(),
      p_notes: notes || null,
      p_timezone: userTimezone,
    };

    const { data, error } = await supabase.rpc('inventory_move_product_v3', rpcParams);

    if (error) {
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      const response = data as { success: boolean; data?: any; error?: { code: string; details: string } };
      // Convert error object to string for consistent return type
      if (!response.success && response.error) {
        return {
          success: false,
          data: response.data,
          error: response.error.details || response.error.code || 'Move product failed',
        };
      }
      return {
        success: response.success,
        data: response.data,
      };
    }

    return {
      success: false,
      error: 'Invalid response format from inventory_move_product_v3',
    };
  }

  async getBaseCurrency(companyId: string): Promise<{
    symbol: string;
    code: string;
  }> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    // Extract base_currency from response
    if (data && data.base_currency) {
      return {
        symbol: data.base_currency.symbol || '₫',
        code: data.base_currency.currency_code || 'VND',
      };
    }

    // Fallback to VND if no base currency found
    return {
      symbol: '₫',
      code: 'VND',
    };
  }

  /**
   * Get all inventory for Excel export
   * Uses same RPC as getInventory but with high limit to fetch all products
   */
  async getAllInventoryForExport(
    companyId: string,
    storeId: string | null,
    search?: string
  ): Promise<InventoryResponse> {
    const supabase = supabaseService.getClient();

    // If no company ID, return empty result
    if (!companyId) {
      return { products: [] };
    }

    // v3 requires store_id - if null, return empty
    if (!storeId) {
      return { products: [] };
    }

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: 1,
      p_limit: 10000, // High limit to get all products
      p_timezone: userTimezone,
    };

    // Add search parameter if search term exists
    if (search && search.trim() !== '') {
      rpcParams.p_search = search.trim();
    }

    const { data, error } = await supabase.rpc('get_inventory_page_v3', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    // Handle success wrapper format
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      const rawProducts = data.data?.products || [];
      // Transform v3 nested structure to flat structure
      const products = rawProducts.map((p: any) => this.transformV3Product(p));

      return {
        products: products,
        currency: data.data?.currency,
        pagination: data.data?.pagination,
      };
    }

    // Fallback
    throw new Error('Invalid response format from get_inventory_page_v3');
  }

  /**
   * Delete products (soft delete)
   * Uses inventory_delete_product_v3 RPC
   */
  async deleteProducts(
    productIds: string[],
    companyId: string
  ): Promise<{
    success: boolean;
    message?: string;
    data?: {
      total_requested: number;
      successfully_deleted: number;
      already_deleted: number;
      not_found: number;
      results: any[];
    };
    error?: string;
    code?: string;
  }> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const { data, error } = await supabase.rpc('inventory_delete_product_v3', {
      p_product_ids: productIds,
      p_company_id: companyId,
      p_time: new Date().toISOString(),
      p_timezone: userTimezone,
    });

    if (error) {
      return {
        success: false,
        error: error.message,
        code: 'RPC_ERROR',
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      return data as {
        success: boolean;
        message?: string;
        data?: {
          total_requested: number;
          successfully_deleted: number;
          already_deleted: number;
          not_found: number;
          results: any[];
        };
        error?: string;
        code?: string;
      };
    }

    return {
      success: false,
      error: 'Invalid response format from inventory_delete_product_v3',
      code: 'INVALID_RESPONSE',
    };
  }

  /**
   * Get product history (inventory logs)
   * Uses inventory_product_history RPC
   */
  async getProductHistory(
    companyId: string,
    storeId: string,
    productId: string,
    page: number = 1,
    pageSize: number = 5
  ): Promise<ProductHistoryResponse> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const { data, error } = await supabase.rpc('inventory_product_history', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_product_id: productId,
      p_timezone: userTimezone,
      p_page: page,
      p_page_size: pageSize,
    });

    if (error) {
      return {
        success: false,
        message: error.message,
        data: [],
        total_count: 0,
        page: 1,
        page_size: pageSize,
        total_pages: 0,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      return data as ProductHistoryResponse;
    }

    return {
      success: false,
      message: 'Invalid response format from inventory_product_history',
      data: [],
      total_count: 0,
      page: 1,
      page_size: pageSize,
      total_pages: 0,
    };
  }
}
