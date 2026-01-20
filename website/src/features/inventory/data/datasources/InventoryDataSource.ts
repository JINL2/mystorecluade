/**
 * InventoryDataSource
 * Data source for inventory operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryMetadataResponse } from '../../domain/entities/InventoryMetadata';

interface InventoryResponse {
  items: any[];  // v6 uses 'items' instead of 'products'
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
   * Transform v6 item response - keeps nested structure for InventoryItemModel
   * v6 returns items with variant fields expanded
   */
  private transformV6Item(item: any): any {
    return {
      product_id: item.product_id,
      product_name: item.product_name,
      product_sku: item.product_sku,
      product_barcode: item.product_barcode,
      product_type: item.product_type,
      brand_id: item.brand_id,
      brand_name: item.brand_name,
      category_id: item.category_id,
      category_name: item.category_name,
      unit: item.unit,
      image_urls: item.image_urls || [],
      created_at: item.created_at,
      // v6 variant fields
      variant_id: item.variant_id,
      variant_name: item.variant_name,
      variant_sku: item.variant_sku,
      variant_barcode: item.variant_barcode,
      display_name: item.display_name,
      display_sku: item.display_sku,
      display_barcode: item.display_barcode,
      has_variants: item.has_variants ?? false,
      // Keep nested structures for InventoryItemModel
      stock: item.stock,
      price: item.price,
      status: item.status,
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
      return { items: [] };
    }

    // v6 requires store_id - if null, return empty
    if (!storeId) {
      return { items: [] };
    }

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: search?.trim() || null,
      p_availability: null,
      p_brand_id: null,
      p_category_id: null,
      p_timezone: userTimezone,
    };

    // RPC 'get_inventory_page_v6' returns items with variant fields expanded
    const { data, error } = await supabase.rpc('get_inventory_page_v6', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    // Handle success wrapper format: { success: true, data: { items: [], pagination: {}, summary: {}, currency: {} } }
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      const rawItems = data.data?.items || [];
      // Transform v6 items
      const items = rawItems.map((item: any) => this.transformV6Item(item));

      return {
        items: items,
        currency: data.data?.currency,
        pagination: data.data?.pagination,
      };
    }

    // Fallback
    throw new Error('Invalid response format from get_inventory_page_v6');
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

    // Build params for v5 - supports variant products
    const params: any = {
      p_product_id: productId,
      p_company_id: companyId,
      p_store_id: storeId,
      p_created_by: userId || productData.userId,
      p_updated_at: new Date().toISOString(),
      p_timezone: userTimezone,
      p_default_price: productData.defaultPrice ?? false, // false = store price, true = default price
      // v5: variant support - p_variant_id is required for products with variants
      p_variant_id: productData.variantId || null,
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

    const { data, error } = await supabase.rpc('inventory_edit_product_v5', params);

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

    // v2: Added attributes with options for variant support
    const { data, error } = await supabase.rpc('get_inventory_metadata_v2', {
      p_company_id: companyId,
      p_store_id: storeId || null,
    });

    if (error) {
      throw new Error(error.message);
    }

    // v2 returns { success: true, data: {...} } wrapper format
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      return {
        success: true,
        data: data.data,
      };
    }

    // Handle error response from RPC
    if (data && typeof data === 'object' && 'success' in data && data.success === false) {
      throw new Error(data.error?.message || 'Failed to fetch metadata');
    }

    return data as InventoryMetadataResponse;
  }

  /**
   * Import products from Excel with variant support (v5)
   * @param companyId - Company ID
   * @param storeId - Store ID
   * @param userId - User performing the import
   * @param products - Array of products to import (supports variant_name field)
   * @param defaultPrice - false = store price, true = default price
   * @returns Import result with summary including variant_updates count
   */
  async importExcel(
    companyId: string,
    storeId: string,
    userId: string,
    products: any[],
    defaultPrice: boolean = false
  ): Promise<{
    success: boolean;
    summary?: {
      total_rows: number;
      created: number;
      updated: number;
      skipped: number;
      errors: number;
      logs_created: number;
      variant_updates: number;
    };
    errors?: Array<{
      row: number;
      error: string;
      code?: string;
      sku?: string;
      barcode?: string;
      variant_name?: string;
      product_name?: string;
    }>;
    message?: string;
    error?: string;
  }> {
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

    // v5: Now supports variant_name field for variant product stock updates
    const { data, error } = await supabase.rpc('inventory_import_excel_v5', rpcParams);

    if (error) {
      console.error('📦 [Import Excel v5] RPC error:', error);
      return {
        success: false,
        error: error.message,
      };
    }

    // Handle success wrapper response
    if (data && typeof data === 'object' && 'success' in data) {
      // Log errors with details if any
      if (data.errors && data.errors.length > 0) {
        console.error('📦 [Import Excel v5] Errors:', data.errors.map((e: any) =>
          `Row ${e.row}: ${e.error}${e.code ? ` [${e.code}]` : ''}${e.sku ? ` (SKU: ${e.sku})` : ''}${e.variant_name ? ` (Variant: ${e.variant_name})` : ''}${e.barcode ? ` (Barcode: ${e.barcode})` : ''}`
        ));
      }

      // Log variant updates if any
      if (data.summary?.variant_updates > 0) {
        console.log(`📦 [Import Excel v5] Variant updates: ${data.summary.variant_updates}`);
      }

      return {
        success: data.success,
        summary: data.summary,
        errors: data.errors,
        message: data.message,
      };
    }

    console.error('📦 [Import Excel v5] Invalid response format:', data);
    return {
      success: false,
      error: 'Invalid response format from inventory_import_excel_v5',
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
    updatedBy: string,
    variantId?: string | null // v4: variant support
  ): Promise<{ success: boolean; data?: any; error?: string }> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    // v4: Build item with optional variant_id
    const item: { product_id: string; quantity: number; variant_id?: string } = {
      product_id: productId,
      quantity: quantity,
    };

    // Only include variant_id if it's provided (for variant products)
    if (variantId) {
      item.variant_id = variantId;
    }

    const rpcParams = {
      p_company_id: companyId,
      p_from_store_id: fromStoreId,
      p_to_store_id: toStoreId,
      p_items: [item],
      p_updated_by: updatedBy,
      p_time: new Date().toISOString(),
      p_notes: notes || null,
      p_timezone: userTimezone,
    };

    const { data, error } = await supabase.rpc('inventory_move_product_v4', rpcParams);

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
      error: 'Invalid response format from inventory_move_product_v4',
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
   * Uses same RPC as getInventory but with high limit to fetch all items
   */
  async getAllInventoryForExport(
    companyId: string,
    storeId: string | null,
    search?: string
  ): Promise<InventoryResponse> {
    const supabase = supabaseService.getClient();

    // If no company ID, return empty result
    if (!companyId) {
      return { items: [] };
    }

    // v6 requires store_id - if null, return empty
    if (!storeId) {
      return { items: [] };
    }

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: 1,
      p_limit: 10000, // High limit to get all items
      p_search: search?.trim() || null,
      p_availability: null,
      p_brand_id: null,
      p_category_id: null,
      p_timezone: userTimezone,
    };

    const { data, error } = await supabase.rpc('get_inventory_page_v6', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    // Handle success wrapper format
    if (data && typeof data === 'object' && 'success' in data && data.success === true) {
      const rawItems = data.data?.items || [];
      // Transform v6 items
      const items = rawItems.map((item: any) => this.transformV6Item(item));

      return {
        items: items,
        currency: data.data?.currency,
        pagination: data.data?.pagination,
      };
    }

    // Fallback
    throw new Error('Invalid response format from get_inventory_page_v6');
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
   * Uses inventory_product_history_v2 RPC (supports variants)
   */
  async getProductHistory(
    companyId: string,
    storeId: string,
    productId: string,
    page: number = 1,
    pageSize: number = 5,
    variantId?: string | null // v2: variant support
  ): Promise<ProductHistoryResponse> {
    const supabase = supabaseService.getClient();

    // Get user's timezone
    const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

    const { data, error } = await supabase.rpc('inventory_product_history_v2', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_product_id: productId,
      p_variant_id: variantId || null, // v2: filter by variant
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
      message: 'Invalid response format from inventory_product_history_v2',
      data: [],
      total_count: 0,
      page: 1,
      page_size: pageSize,
      total_pages: 0,
    };
  }
}
