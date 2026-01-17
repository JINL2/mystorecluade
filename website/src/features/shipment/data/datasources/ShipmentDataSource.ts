/**
 * ShipmentDataSource
 * Data source for shipment operations
 * Handles all Supabase RPC calls for shipment feature
 */

import { supabaseService } from '@/core/services/supabase_service';
import type {
  ShipmentListItem,
  ShipmentDetail,
  Counterparty,
  OrderInfo,
  InventoryProduct,
  Currency,
  OneTimeSupplier,
} from '../../domain/types';

// ===== RPC Response Types =====

interface ShipmentListRpcResponse {
  success: boolean;
  data?: ShipmentListItem[];
  totalCount?: number;
  error?: string;
}

interface ShipmentDetailRpcResponse {
  success: boolean;
  data?: ShipmentDetail;
  error?: string;
}

interface CounterpartyRpcResponse {
  success: boolean;
  data?: Counterparty[];
  error?: string;
}

interface OrderInfoRpcResponse {
  success: boolean;
  data?: OrderInfo[];
  error?: string;
}

interface CurrencyRpcResponse {
  base_currency?: {
    symbol?: string;
    currency_code?: string;
  };
}

// v6 response structure: data.items instead of data.products
interface InventoryRpcResponse {
  success: boolean;
  data?: {
    items: InventoryProduct[];
    currency?: Currency;
  };
  error?: string;
}

interface CreateShipmentRpcResponse {
  success: boolean;
  shipment_number?: string;
  message?: string;
  error?: string;
}

// Generic RPC data type for type assertions
interface GenericRpcData {
  success?: boolean;
  data?: unknown;
  error?: string;
  message?: string;
  shipment_number?: string;
  total_count?: number;
  base_currency?: {
    symbol?: string;
    currency_code?: string;
  };
}

// ===== Data Source Class =====

export class ShipmentDataSource {
  private getClient() {
    return supabaseService.getClient();
  }

  // ===== Shipment Operations =====

  /**
   * Get list of shipments with filters
   */
  async getShipmentList(params: {
    companyId: string;
    timezone: string;
    fromDate?: string;
    toDate?: string;
    statusFilter?: string;
    supplierFilter?: string;
    orderFilter?: string;
  }): Promise<ShipmentListRpcResponse> {
    try {
      const supabase = this.getClient();

      const rpcParams: Record<string, unknown> = {
        p_company_id: params.companyId,
        p_timezone: params.timezone,
      };

      if (params.fromDate) {
        rpcParams.p_start_date = params.fromDate;
      }
      if (params.toDate) {
        rpcParams.p_end_date = params.toDate;
      }
      if (params.statusFilter) {
        rpcParams.p_status = params.statusFilter;
      }
      if (params.supplierFilter) {
        rpcParams.p_supplier_id = params.supplierFilter;
      }
      if (params.orderFilter) {
        rpcParams.p_order_id = params.orderFilter;
      }

      console.log('📦 Calling inventory_get_shipment_list with:', rpcParams);

      const { data, error } = await supabase.rpc(
        'inventory_get_shipment_list' as never,
        rpcParams as never
      );

      console.log('📦 inventory_get_shipment_list response:', { data, error });

      if (error) {
        return { success: false, error: error.message };
      }

      const rpcData = data as GenericRpcData;
      return {
        success: rpcData?.success ?? false,
        data: (rpcData?.data as ShipmentListItem[]) ?? [],
        totalCount: rpcData?.total_count ?? 0,
        error: rpcData?.error,
      };
    } catch (err) {
      console.error('📦 getShipmentList error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch shipments',
      };
    }
  }

  /**
   * Get shipment detail by ID (v2: variant support)
   */
  async getShipmentDetail(params: {
    shipmentId: string;
    companyId: string;
    timezone: string;
  }): Promise<ShipmentDetailRpcResponse> {
    try {
      const supabase = this.getClient();

      console.log('📦 Calling inventory_get_shipment_detail_v2 with:', {
        p_shipment_id: params.shipmentId,
        p_company_id: params.companyId,
        p_timezone: params.timezone,
      });

      // v2: supports variant_id, variant_name, display_name, has_variants in items
      // v2: receiving progress now matches by (product_id, variant_id)
      const { data, error } = await supabase.rpc(
        'inventory_get_shipment_detail_v2' as never,
        {
          p_shipment_id: params.shipmentId,
          p_company_id: params.companyId,
          p_timezone: params.timezone,
        } as never
      );

      console.log('📦 inventory_get_shipment_detail_v2 response:', { data, error });

      if (error) {
        return { success: false, error: error.message };
      }

      const rpcData = data as GenericRpcData;
      return {
        success: rpcData?.success ?? false,
        data: rpcData?.data as ShipmentDetail | undefined,
        error: rpcData?.error,
      };
    } catch (err) {
      console.error('📦 getShipmentDetail error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch shipment detail',
      };
    }
  }

  /**
   * Create a new shipment (v3: variant support)
   */
  async createShipment(params: {
    companyId: string;
    userId: string;
    // v3: items now include variant_id (null for non-variant products)
    items: Array<{ sku: string; variant_id: string | null; quantity_shipped: number; unit_cost: number }>;
    time: string;
    timezone: string;
    orderIds?: string[];
    counterpartyId?: string;
    supplierInfo?: Partial<OneTimeSupplier>;
    trackingNumber?: string;
    notes?: string;
    shipmentNumber?: string;
  }): Promise<CreateShipmentRpcResponse> {
    try {
      const supabase = this.getClient();

      const rpcParams: Record<string, unknown> = {
        p_company_id: params.companyId,
        p_user_id: params.userId,
        p_items: params.items,
        p_time: params.time,
        p_timezone: params.timezone,
      };

      // Add optional parameters
      if (params.orderIds && params.orderIds.length > 0) {
        rpcParams.p_order_ids = params.orderIds;
      }
      if (params.counterpartyId) {
        rpcParams.p_counterparty_id = params.counterpartyId;
      }
      if (params.supplierInfo) {
        rpcParams.p_supplier_info = params.supplierInfo;
      }
      if (params.trackingNumber) {
        rpcParams.p_tracking_number = params.trackingNumber;
      }
      if (params.notes) {
        rpcParams.p_notes = params.notes;
      }
      if (params.shipmentNumber) {
        rpcParams.p_shipment_number = params.shipmentNumber;
      }

      console.log('📦 Creating shipment with params:', rpcParams);

      // v3: supports variant_id in items
      const { data, error } = await supabase.rpc(
        'inventory_create_shipment_v3' as never,
        rpcParams as never
      );

      console.log('📦 inventory_create_shipment_v3 response:', { data, error });

      if (error) {
        return { success: false, error: error.message };
      }

      const rpcData = data as GenericRpcData;
      return {
        success: rpcData?.success ?? false,
        shipment_number: rpcData?.shipment_number,
        message: rpcData?.message,
        error: rpcData?.error,
      };
    } catch (err) {
      console.error('📦 createShipment error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to create shipment',
      };
    }
  }

  // ===== Supporting Data Operations =====

  /**
   * Get list of counterparties (suppliers)
   */
  async getCounterparties(companyId: string): Promise<CounterpartyRpcResponse> {
    try {
      const supabase = this.getClient();

      const { data, error } = await supabase.rpc(
        'get_counterparty_info' as never,
        { p_company_id: companyId } as never
      );

      if (error) {
        return { success: false, error: error.message };
      }

      const rpcData = data as GenericRpcData;
      return {
        success: rpcData?.success ?? false,
        data: (rpcData?.data as Counterparty[]) ?? [],
        error: rpcData?.error,
      };
    } catch (err) {
      console.error('🏢 getCounterparties error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch counterparties',
      };
    }
  }

  /**
   * Get list of orders available for shipment
   */
  async getOrders(params: {
    companyId: string;
    timezone: string;
  }): Promise<OrderInfoRpcResponse> {
    try {
      const supabase = this.getClient();

      console.log('📋 Calling inventory_get_order_info with:', {
        p_company_id: params.companyId,
        p_timezone: params.timezone,
      });

      const { data, error } = await supabase.rpc(
        'inventory_get_order_info' as never,
        {
          p_company_id: params.companyId,
          p_timezone: params.timezone,
        } as never
      );

      console.log('📋 inventory_get_order_info response:', { data, error });

      if (error) {
        return { success: false, error: error.message };
      }

      const rpcData = data as GenericRpcData;
      return {
        success: rpcData?.success ?? false,
        data: (rpcData?.data as OrderInfo[]) ?? [],
        error: rpcData?.error,
      };
    } catch (err) {
      console.error('📋 getOrders error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch orders',
      };
    }
  }

  /**
   * Get base currency for company
   */
  async getBaseCurrency(companyId: string): Promise<CurrencyRpcResponse> {
    try {
      const supabase = this.getClient();

      const { data, error } = await supabase.rpc('get_base_currency', {
        p_company_id: companyId,
      });

      if (error) {
        console.error('💰 getBaseCurrency error:', error);
        return {};
      }

      const rpcData = data as GenericRpcData;
      return {
        base_currency: rpcData?.base_currency,
      };
    } catch (err) {
      console.error('💰 getBaseCurrency error:', err);
      return {};
    }
  }

  /**
   * Search products by query (v6: variant support)
   */
  async searchProducts(params: {
    companyId: string;
    storeId: string;
    query: string;
    timezone: string;
    limit?: number;
  }): Promise<InventoryRpcResponse> {
    try {
      const supabase = this.getClient();

      // v6: variant expansion support
      const { data, error } = await supabase.rpc(
        'get_inventory_page_v6' as never,
        {
          p_company_id: params.companyId,
          p_store_id: params.storeId,
          p_page: 1,
          p_limit: params.limit ?? 10,
          p_search: params.query.trim(),
          p_availability: null,
          p_brand_id: null,
          p_category_id: null,
          p_timezone: params.timezone,
        } as never
      );

      if (error) {
        console.error('🔍 searchProducts error:', error);
        return { success: false, error: error.message };
      }

      // v6 response structure: data.items instead of data.products
      const rpcData = data as GenericRpcData & {
        data?: { items?: InventoryProduct[]; currency?: Currency };
      };
      return {
        success: rpcData?.success ?? false,
        data: {
          items: rpcData?.data?.items ?? [],
          currency: rpcData?.data?.currency,
        },
        error: rpcData?.error,
      };
    } catch (err) {
      console.error('🔍 searchProducts error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to search products',
      };
    }
  }

  /**
   * Search product by exact SKU (v6: checks display_sku, product_sku, variant_sku)
   */
  async searchProductBySku(params: {
    companyId: string;
    storeId: string;
    sku: string;
    timezone: string;
  }): Promise<InventoryProduct | null> {
    try {
      const result = await this.searchProducts({
        ...params,
        query: params.sku,
        limit: 10, // v6: search more to find exact match
      });

      // v6: response uses data.items instead of data.products
      if (!result.success || !result.data?.items) {
        return null;
      }

      // v6: Find exact SKU match (check display_sku, product_sku, variant_sku)
      const exactMatch = result.data.items.find(
        (p) =>
          p.display_sku?.toLowerCase() === params.sku.trim().toLowerCase() ||
          p.product_sku?.toLowerCase() === params.sku.trim().toLowerCase() ||
          p.variant_sku?.toLowerCase() === params.sku.trim().toLowerCase()
      );

      return exactMatch || null;
    } catch (err) {
      console.error('📦 searchProductBySku error:', err);
      return null;
    }
  }

  /**
   * Get current user ID from auth
   */
  async getCurrentUserId(): Promise<string | null> {
    try {
      const supabase = this.getClient();
      const { data: { user } } = await supabase.auth.getUser();
      return user?.id || null;
    } catch (err) {
      console.error('👤 getCurrentUserId error:', err);
      return null;
    }
  }
}

// ===== Singleton Instance =====

let dataSourceInstance: ShipmentDataSource | null = null;

export const getShipmentDataSource = (): ShipmentDataSource => {
  if (!dataSourceInstance) {
    dataSourceInstance = new ShipmentDataSource();
  }
  return dataSourceInstance;
};
