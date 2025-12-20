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
  total_participants?: number;
}

// Participant DTO for session items
export interface SessionParticipantDTO {
  user_id: string;
  user_name: string;
  user_profile_image: string | null;
  product_count: number;
  total_scanned: number;
}

// Extended session items result with participants
export interface SessionItemsFullDTO {
  session_id: string;
  items: SessionItemDTO[];
  participants: SessionParticipantDTO[];
  summary: SessionItemsSummaryDTO;
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

// Stock change item for v2 submit
export interface StockChangeDTO {
  product_id: string;
  sku: string;
  product_name: string;
  quantity_before: number;
  quantity_received: number;
  quantity_after: number;
  needs_display: boolean;
}

export interface SubmitResultDTO {
  receiving_number?: string;
  items_count?: number;
  total_quantity?: number;
  // v2 fields
  stock_changes?: StockChangeDTO[];
  new_display_count?: number;
  total_cost?: number;
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

// Merge Sessions Result DTO
export interface MergeSessionsResultDTO {
  target_session: {
    session_id: string;
    session_name: string;
    items_before: number;
    items_after: number;
    quantity_before: number;
    quantity_after: number;
  };
  source_session: {
    session_id: string;
    session_name: string;
    items_copied: number;
    quantity_copied: number;
    deactivated: boolean;
  };
  summary: {
    total_items_copied: number;
    total_quantity_copied: number;
    unique_products_copied: number;
  };
}

// Compare Sessions DTOs
export interface CompareSessionInfoDTO {
  session_id: string;
  session_name: string;
  session_type: string;
  store_id: string;
  store_name: string;
  created_by: string;
  created_by_name: string;
  total_products: number;
  total_quantity: number;
}

export interface CompareMatchedItemDTO {
  product_id: string;
  sku: string;
  product_name: string;
  quantity_a: number;
  quantity_b: number;
  quantity_diff: number;
  is_match: boolean;
}

export interface CompareOnlyItemDTO {
  product_id: string;
  sku: string;
  product_name: string;
  quantity: number;
}

export interface CompareSessionsSummaryDTO {
  total_matched: number;
  quantity_same_count: number;
  quantity_diff_count: number;
  only_in_a_count: number;
  only_in_b_count: number;
}

export interface CompareSessionsResultDTO {
  session_a: CompareSessionInfoDTO;
  session_b: CompareSessionInfoDTO;
  comparison: {
    matched: CompareMatchedItemDTO[];
    only_in_a: CompareOnlyItemDTO[];
    only_in_b: CompareOnlyItemDTO[];
  };
  summary: CompareSessionsSummaryDTO;
}

// Session History DTOs (inventory_get_session_history_v2)
// Updated to match actual RPC response structure

export interface SessionHistoryUserDTO {
  user_id: string;
  first_name: string;
  last_name: string;
  profile_image: string | null;
}

export interface SessionHistoryMemberDTO {
  user_id: string;
  first_name: string;
  last_name: string;
  profile_image: string | null;
  joined_at: string;
  is_active: boolean;
}

export interface SessionHistoryScannedByDTO {
  user_id: string;
  first_name: string;
  last_name: string;
  profile_image: string | null;
  quantity: number;
  quantity_rejected: number;
}

export interface SessionHistoryItemDTO {
  product_id: string;
  product_name: string;
  sku: string | null;
  scanned_quantity: number;
  scanned_rejected: number;
  scanned_by: SessionHistoryScannedByDTO[];
  confirmed_quantity: number | null;
  confirmed_rejected: number | null;
  quantity_expected: number | null;
  quantity_difference: number | null;
}

export interface SessionMergeInfoDTO {
  original_session: {
    items: Array<{
      product_id: string;
      sku: string;
      product_name: string;
      quantity: number;
      quantity_rejected: number;
      scanned_by: SessionHistoryUserDTO;
    }>;
    items_count: number;
    total_quantity: number;
    total_rejected: number;
  };
  merged_sessions: Array<{
    source_session_id: string;
    source_session_name: string;
    source_created_at: string;
    source_created_by: SessionHistoryUserDTO;
    items: Array<{
      product_id: string;
      sku: string;
      product_name: string;
      quantity: number;
      quantity_rejected: number;
      scanned_by: SessionHistoryUserDTO;
    }>;
    items_count: number;
    total_quantity: number;
    total_rejected: number;
  }>;
  total_merged_sessions_count: number;
}

export interface StockSnapshotDTO {
  product_id: string;
  sku: string;
  product_name: string;
  quantity_before: number;
  quantity_received: number;
  quantity_after: number;
  needs_display: boolean;
}

export interface SessionReceivingInfoDTO {
  receiving_id: string;
  receiving_number: string;
  received_at: string;
  stock_snapshot: StockSnapshotDTO[];
  new_products_count: number;
  restock_products_count: number;
}

export interface SessionHistoryEntryDTO {
  session_id: string;
  session_name: string;
  session_type: 'counting' | 'receiving';
  is_active: boolean;
  is_final: boolean;
  store_id: string;
  store_name: string;
  shipment_id: string | null;
  shipment_number: string | null;
  created_at: string;
  completed_at: string | null;
  duration_minutes: number | null;
  created_by: SessionHistoryUserDTO;
  members: SessionHistoryMemberDTO[];
  member_count: number;
  items: SessionHistoryItemDTO[];
  total_scanned_quantity: number;
  total_scanned_rejected: number;
  total_confirmed_quantity: number | null;
  total_confirmed_rejected: number | null;
  total_difference: number | null;
  is_merged_session: boolean;
  merge_info: SessionMergeInfoDTO | null;
  receiving_info: SessionReceivingInfoDTO | null;
}

export interface SessionHistoryPaginationDTO {
  total: number;
  limit: number;
  offset: number;
  has_more: boolean;
}

export interface SessionHistoryResponseDTO {
  sessions: SessionHistoryEntryDTO[];
  pagination: SessionHistoryPaginationDTO;
}

export interface SessionHistoryParamsDTO {
  p_company_id: string;
  p_store_id: string;
  p_session_type?: 'counting' | 'receiving' | null;
  p_is_active?: boolean;
  p_start_date?: string | null;
  p_end_date?: string | null;
  p_timezone: string;
  p_limit?: number;
  p_offset?: number;
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
    isFinal: boolean,
    notes?: string
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

  getSessionItemsFull(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsFullDTO>;

  mergeSessions(params: {
    targetSessionId: string;
    sourceSessionId: string;
    userId: string;
  }): Promise<MergeSessionsResultDTO>;

  compareSessions(params: {
    sessionIdA: string;
    sessionIdB: string;
    userId: string;
  }): Promise<CompareSessionsResultDTO>;

  getSessionHistory(params: {
    companyId: string;
    storeId: string;
    sessionType?: 'counting' | 'receiving' | null;
    isActive?: boolean;
    startDate?: string | null;
    endDate?: string | null;
    timezone?: string;
    limit?: number;
    offset?: number;
  }): Promise<SessionHistoryResponseDTO>;
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
    const localTime = new Date().toISOString();

    const { data, error } = await client.rpc('inventory_add_session_items', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_time: localTime,
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
    isFinal: boolean,
    notes?: string
  ): Promise<SubmitResultDTO> {
    const client = supabaseService.getClient();
    const localTime = new Date().toISOString();

    // Use inventory_submit_session_v2 for stock_changes and needs_display support
    const { data, error } = await client.rpc('inventory_submit_session_v2', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_is_final: isFinal,
      p_time: localTime,
      p_timezone: this.getTimezone(),
      p_notes: notes || null,
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
      // v2 fields
      stock_changes: data.data?.stock_changes || [],
      new_display_count: data.data?.new_display_count || 0,
      total_cost: data.data?.total_cost || 0,
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

  async getSessionItemsFull(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsFullDTO> {
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
      session_id: data.data?.session_id || sessionId,
      items: data.data?.items || [],
      participants: data.data?.participants || [],
      summary: data.data?.summary || {
        total_products: 0,
        total_quantity: 0,
        total_rejected: 0,
        total_participants: 0,
      },
    };
  }

  async mergeSessions(params: {
    targetSessionId: string;
    sourceSessionId: string;
    userId: string;
  }): Promise<MergeSessionsResultDTO> {
    const client = supabaseService.getClient();
    const localTime = new Date().toISOString();

    const { data, error } = await client.rpc('inventory_merge_sessions', {
      p_target_session_id: params.targetSessionId,
      p_source_session_id: params.sourceSessionId,
      p_user_id: params.userId,
      p_time: localTime,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Failed to merge sessions: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Failed to merge sessions');
    }

    return {
      target_session: {
        session_id: data.data?.target_session?.session_id || params.targetSessionId,
        session_name: data.data?.target_session?.session_name || '',
        items_before: data.data?.target_session?.items_before || 0,
        items_after: data.data?.target_session?.items_after || 0,
        quantity_before: data.data?.target_session?.quantity_before || 0,
        quantity_after: data.data?.target_session?.quantity_after || 0,
      },
      source_session: {
        session_id: data.data?.source_session?.session_id || params.sourceSessionId,
        session_name: data.data?.source_session?.session_name || '',
        items_copied: data.data?.source_session?.items_copied || 0,
        quantity_copied: data.data?.source_session?.quantity_copied || 0,
        deactivated: data.data?.source_session?.deactivated || false,
      },
      summary: {
        total_items_copied: data.data?.summary?.total_items_copied || 0,
        total_quantity_copied: data.data?.summary?.total_quantity_copied || 0,
        unique_products_copied: data.data?.summary?.unique_products_copied || 0,
      },
    };
  }

  async compareSessions(params: {
    sessionIdA: string;
    sessionIdB: string;
    userId: string;
  }): Promise<CompareSessionsResultDTO> {
    const client = supabaseService.getClient();

    const { data, error } = await client.rpc('inventory_compare_sessions', {
      p_session_id_a: params.sessionIdA,
      p_session_id_b: params.sessionIdB,
      p_user_id: params.userId,
      p_timezone: this.getTimezone(),
    });

    if (error) {
      throw new Error(`Failed to compare sessions: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Failed to compare sessions');
    }

    return {
      session_a: data.data?.session_a || {
        session_id: params.sessionIdA,
        session_name: '',
        session_type: '',
        store_id: '',
        store_name: '',
        created_by: '',
        created_by_name: '',
        total_products: 0,
        total_quantity: 0,
      },
      session_b: data.data?.session_b || {
        session_id: params.sessionIdB,
        session_name: '',
        session_type: '',
        store_id: '',
        store_name: '',
        created_by: '',
        created_by_name: '',
        total_products: 0,
        total_quantity: 0,
      },
      comparison: {
        matched: data.data?.comparison?.matched || [],
        only_in_a: data.data?.comparison?.only_in_a || [],
        only_in_b: data.data?.comparison?.only_in_b || [],
      },
      summary: data.data?.summary || {
        total_matched: 0,
        quantity_same_count: 0,
        quantity_diff_count: 0,
        only_in_a_count: 0,
        only_in_b_count: 0,
      },
    };
  }

  async getSessionHistory(params: {
    companyId: string;
    storeId?: string; // Optional - if not provided, get sessions for all stores
    sessionType?: 'counting' | 'receiving' | null;
    isActive?: boolean;
    startDate?: string | null;
    endDate?: string | null;
    timezone?: string;
    limit?: number;
    offset?: number;
  }): Promise<SessionHistoryResponseDTO> {
    const client = supabaseService.getClient();
    const timezone = params.timezone || this.getTimezone();

    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_timezone: timezone,
    };

    // Store ID is optional - if provided, filter by store
    if (params.storeId) {
      rpcParams.p_store_id = params.storeId;
    }

    if (params.sessionType) {
      rpcParams.p_session_type = params.sessionType;
    }
    if (params.isActive !== undefined) {
      rpcParams.p_is_active = params.isActive;
    }
    if (params.startDate) {
      rpcParams.p_start_date = params.startDate;
    }
    if (params.endDate) {
      rpcParams.p_end_date = params.endDate;
    }
    if (params.limit !== undefined) {
      rpcParams.p_limit = params.limit;
    }
    if (params.offset !== undefined) {
      rpcParams.p_offset = params.offset;
    }

    const { data, error } = await client.rpc('inventory_get_session_history_v2', rpcParams);

    if (error) {
      throw new Error(`Failed to get session history: ${error.message}`);
    }

    if (!data?.success) {
      throw new Error(data?.error || 'Failed to get session history');
    }

    // RPC returns: { success, data: [...sessions], total_count, limit, offset }

    // The sessions array is directly in data.data (not data.data.sessions)
    const sessions = Array.isArray(data.data) ? data.data : [];
    const totalCount = data.total_count || 0;
    const limit = data.limit || params.limit || 20;
    const offset = data.offset || params.offset || 0;
    const hasMore = offset + sessions.length < totalCount;

    return {
      sessions,
      pagination: {
        total: totalCount,
        limit,
        offset,
        has_more: hasMore,
      },
    };
  }
}

// Singleton instance
export const productReceiveDataSource = new ProductReceiveDataSource();
