/**
 * ProductReceiveDataSource
 * Handles Supabase RPC calls for product receiving
 */

import { supabaseService } from '@/core/services/supabase_service';

// Types for RPC responses
export interface SearchProductDTO {
  product_id: string;
  product_name: string;
  sku: string;
  barcode?: string;
  image_urls?: string[];
  stock: {
    quantity_on_hand: number;
    quantity_available: number;
    quantity_reserved: number;
  };
  price: {
    cost: number;
    selling: number;
    source: string;
  };
}

export interface SessionItemUserDTO {
  user_id: string;
  user_name: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SessionItemDTO {
  product_id: string;
  product_name: string;
  total_quantity: number;
  total_rejected: number;
  scanned_by: SessionItemUserDTO[];
}

export interface SessionItemsSummaryDTO {
  total_products: number;
  total_quantity: number;
  total_rejected: number;
}

export interface CurrencyDTO {
  symbol: string;
  code: string;
}

export interface SaveItemDTO {
  product_id: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SubmitItemDTO {
  product_id: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SubmitResultDTO {
  receiving_number?: string;
  items_count?: number;
  total_quantity?: number;
}

// Counterparty DTO
export interface CounterpartyDTO {
  counterparty_id: string;
  name: string;
  is_internal?: boolean;
}

// Shipment DTO for list
export interface ShipmentDTO {
  shipment_id: string;
  shipment_number: string;
  supplier_name: string;
  status: string;
  shipped_date: string;
  total_items: number;
  total_quantity: number;
  total_cost: number;
}

// Shipment Detail DTO
export interface ShipmentDetailDTO {
  shipment_id: string;
  shipment_number: string;
  supplier_id?: string;
  supplier_name: string;
  status: string;
  shipped_date: string;
  tracking_number?: string;
  notes?: string;
  items: ShipmentItemDTO[];
  receiving_summary?: ReceivingSummaryDTO;
}

export interface ShipmentItemDTO {
  item_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  quantity_shipped: number;
  quantity_received: number;
  quantity_accepted: number;
  quantity_rejected: number;
  quantity_remaining: number;
  unit_cost: number;
}

export interface ReceivingSummaryDTO {
  total_shipped: number;
  total_received: number;
  total_accepted: number;
  total_rejected: number;
  total_remaining: number;
  progress_percentage: number;
}

// Session DTO
export interface SessionDTO {
  session_id: string;
  session_name?: string;
  session_type: string;
  store_id: string;
  store_name: string;
  shipment_id?: string;
  shipment_number?: string;
  is_active: boolean;
  is_final: boolean;
  created_by: string;
  created_by_name: string;
  created_at: string;
  completed_at?: string;
  member_count?: number;
}

// Create Session Result DTO
export interface CreateSessionResultDTO {
  session_id: string;
  [key: string]: unknown;
}

// Join Session Result DTO
export interface JoinSessionResultDTO {
  member_id?: string;
  created_by?: string;
  created_by_name?: string;
}

// DataSource interface
export interface IProductReceiveDataSource {
  searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page?: number,
    limit?: number
  ): Promise<{ products: SearchProductDTO[]; currency: CurrencyDTO }>;

  addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItemDTO[]
  ): Promise<void>;

  getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<{ items: SessionItemDTO[]; summary: SessionItemsSummaryDTO }>;

  submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItemDTO[],
    isFinal: boolean
  ): Promise<SubmitResultDTO>;

  // New methods for useProductReceiveList and useReceiveSessionModal
  getBaseCurrency(companyId: string): Promise<CurrencyDTO>;

  getCounterparties(companyId: string): Promise<CounterpartyDTO[]>;

  getShipmentList(params: {
    companyId: string;
    timezone: string;
    searchQuery?: string;
    fromDate?: string;
    toDate?: string;
    statusFilter?: string;
    supplierFilter?: string;
  }): Promise<{ shipments: ShipmentDTO[]; totalCount: number }>;

  getShipmentDetail(params: {
    shipmentId: string;
    companyId: string;
    timezone: string;
  }): Promise<ShipmentDetailDTO>;

  getSessionList(params: {
    companyId: string;
    shipmentId?: string;
    sessionType?: string;
    isActive?: boolean;
    timezone: string;
  }): Promise<{ sessions: SessionDTO[]; totalCount: number }>;

  createSession(params: {
    companyId: string;
    storeId: string;
    userId: string;
    sessionType: string;
    shipmentId?: string;
    sessionName?: string;
    time: string;
    timezone: string;
  }): Promise<CreateSessionResultDTO>;

  joinSession(params: {
    sessionId: string;
    userId: string;
    time: string;
    timezone: string;
  }): Promise<JoinSessionResultDTO>;
}

// DataSource implementation
export class ProductReceiveDataSource implements IProductReceiveDataSource {
  private getTimezone(): string {
    return Intl.DateTimeFormat().resolvedOptions().timeZone;
  }

  async searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page: number = 1,
    limit: number = 10
  ): Promise<{ products: SearchProductDTO[]; currency: CurrencyDTO }> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('get_inventory_page_v4', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: query,
      p_availability: null,
      p_brand_id: null,
      p_category_id: null,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Search failed: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Search failed');
    }

    return {
      products: data.data?.products || [],
      currency: {
        symbol: data.data?.currency?.symbol || '₫',
        code: data.data?.currency?.code || 'VND',
      },
    };
  }

  async addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItemDTO[]
  ): Promise<void> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_add_session_items', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Save failed: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Save failed');
    }
  }

  async getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<{ items: SessionItemDTO[]; summary: SessionItemsSummaryDTO }> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_get_session_items', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Failed to load session items: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Failed to load session items');
    }

    return {
      items: data.data?.items || [],
      summary: data.data?.summary || {
        total_products: 0,
        total_quantity: 0,
        total_rejected: 0,
      },
    };
  }

  async submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItemDTO[],
    isFinal: boolean
  ): Promise<SubmitResultDTO> {
    const client = supabaseService.getClient();
    const localTime = new Date().toISOString();

    const { data, error } = await client.rpc('inventory_submit_session', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_is_final: isFinal,
      p_time: localTime,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Submit failed: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Submit failed');
    }

    return {
      receiving_number: data.data?.receiving_number,
      items_count: data.data?.items_count,
      total_quantity: data.data?.total_quantity,
    };
  }

  async getBaseCurrency(companyId: string): Promise<CurrencyDTO> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(`Failed to get currency: ${error.message}`);
    }

    return {
      symbol: data?.base_currency?.symbol || '₩',
      code: data?.base_currency?.currency_code || 'KRW',
    };
  }

  async getCounterparties(companyId: string): Promise<CounterpartyDTO[]> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('get_counterparty_info', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(`Failed to get counterparties: ${error.message}`);
    }

    if (!data?.success || !data?.data) {
      return [];
    }

    return data.data;
  }

  async getShipmentList(params: {
    companyId: string;
    timezone: string;
    searchQuery?: string;
    fromDate?: string;
    toDate?: string;
    statusFilter?: string;
    supplierFilter?: string;
  }): Promise<{ shipments: ShipmentDTO[]; totalCount: number }> {
    const client = supabaseService.getClient();

    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_timezone: params.timezone,
      p_limit: 50,
      p_offset: 0,
    };

    if (params.searchQuery?.trim()) {
      rpcParams.p_search = params.searchQuery.trim();
    }
    if (params.statusFilter) {
      rpcParams.p_status = params.statusFilter;
    }
    if (params.supplierFilter) {
      rpcParams.p_supplier_id = params.supplierFilter;
    }
    if (params.fromDate) {
      rpcParams.p_start_date = `${params.fromDate} 00:00:00`;
    }
    if (params.toDate) {
      rpcParams.p_end_date = `${params.toDate} 23:59:59`;
    }

    const { data, error } = await client.rpc('inventory_get_shipment_list', rpcParams);

    if (error) {
      throw new Error(`Failed to get shipments: ${error.message}`);
    }

    if (!data?.success || !data?.data) {
      return { shipments: [], totalCount: 0 };
    }

    return {
      shipments: data.data,
      totalCount: data.total_count || 0,
    };
  }

  async getShipmentDetail(params: {
    shipmentId: string;
    companyId: string;
    timezone: string;
  }): Promise<ShipmentDetailDTO> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_get_shipment_detail', {
      p_shipment_id: params.shipmentId,
      p_company_id: params.companyId,
      p_timezone: params.timezone,
    });

    if (error) {
      throw new Error(`Failed to get shipment detail: ${error.message}`);
    }

    if (!data?.success || !data?.data) {
      throw new Error(data?.error || 'Failed to load shipment detail');
    }

    return data.data;
  }

  async getSessionList(params: {
    companyId: string;
    shipmentId?: string;
    sessionType?: string;
    isActive?: boolean;
    timezone: string;
  }): Promise<{ sessions: SessionDTO[]; totalCount: number }> {
    const client = supabaseService.getClient();

    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_timezone: params.timezone,
    };

    if (params.shipmentId) {
      rpcParams.p_shipment_id = params.shipmentId;
    }
    if (params.sessionType) {
      rpcParams.p_session_type = params.sessionType;
    }
    if (params.isActive !== undefined) {
      rpcParams.p_is_active = params.isActive;
    }

    const { data, error } = await client.rpc('inventory_get_session_list', rpcParams);

    if (error) {
      throw new Error(`Failed to get sessions: ${error.message}`);
    }

    if (!data?.success || !data?.data) {
      return { sessions: [], totalCount: 0 };
    }

    return {
      sessions: data.data,
      totalCount: data.total_count || 0,
    };
  }

  async createSession(params: {
    companyId: string;
    storeId: string;
    userId: string;
    sessionType: string;
    shipmentId?: string;
    sessionName?: string;
    time: string;
    timezone: string;
  }): Promise<CreateSessionResultDTO> {
    const client = supabaseService.getClient();

    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_store_id: params.storeId,
      p_user_id: params.userId,
      p_session_type: params.sessionType,
      p_time: params.time,
      p_timezone: params.timezone,
    };

    // shipmentId is optional (only for receiving sessions linked to shipments)
    if (params.shipmentId) {
      rpcParams.p_shipment_id = params.shipmentId;
    }

    if (params.sessionName) {
      rpcParams.p_session_name = params.sessionName;
    }

    const { data, error } = await client.rpc('inventory_create_session', rpcParams);

    if (error) {
      throw new Error(`Failed to create session: ${error.message}`);
    }

    if (!data?.success || !data?.data) {
      throw new Error(data?.error || 'Failed to create session');
    }

    return data.data;
  }

  async joinSession(params: {
    sessionId: string;
    userId: string;
    time: string;
    timezone: string;
  }): Promise<JoinSessionResultDTO> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_join_session', {
      p_session_id: params.sessionId,
      p_user_id: params.userId,
      p_time: params.time,
      p_timezone: params.timezone,
    });

    if (error) {
      throw new Error(`Failed to join session: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Failed to join session');
    }

    return {
      member_id: data.data?.member_id,
      created_by: data.data?.created_by,
      created_by_name: data.data?.created_by_name,
    };
  }
}

// Singleton instance
export const productReceiveDataSource = new ProductReceiveDataSource();
