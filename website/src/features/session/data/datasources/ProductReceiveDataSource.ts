/**
 * ProductReceiveDataSource
 * Handles Supabase RPC calls for product receiving
 */

import { supabaseService } from '@/core/services/supabase_service';

// Import all DTO types from separate file
export type {
  SearchProductDTO,
  SessionItemUserDTO,
  SessionItemDTO,
  SessionItemsSummaryDTO,
  SessionParticipantDTO,
  SessionItemsFullDTO,
  CurrencyDTO,
  SaveItemDTO,
  SubmitItemDTO,
  StockChangeDTO,
  SubmitResultDTO,
  CounterpartyDTO,
  ShipmentDTO,
  ShipmentDetailDTO,
  ShipmentItemDTO,
  ReceivingSummaryDTO,
  SessionDTO,
  CreateSessionResultDTO,
  JoinSessionResultDTO,
  MergedItemDTO,
  MergeSessionsResultDTO,
  CompareSessionInfoDTO,
  CompareMatchedItemDTO,
  CompareOnlyItemDTO,
  CompareSessionsSummaryDTO,
  CompareSessionsResultDTO,
  SessionHistoryUserDTO,
  SessionHistoryMemberDTO,
  SessionHistoryScannedByDTO,
  SessionHistoryItemDTO,
  SessionMergeInfoDTO,
  StockSnapshotDTO,
  SessionReceivingInfoDTO,
  SessionHistoryEntryDTO,
  SessionHistoryPaginationDTO,
  SessionHistoryResponseDTO,
  SessionHistoryParamsDTO,
} from './ProductReceiveDataSource.types';

import type {
  SearchProductDTO,
  SessionItemDTO,
  SessionItemsSummaryDTO,
  SessionItemsFullDTO,
  CurrencyDTO,
  SaveItemDTO,
  SubmitItemDTO,
  SubmitResultDTO,
  CounterpartyDTO,
  ShipmentDTO,
  ShipmentDetailDTO,
  SessionDTO,
  CreateSessionResultDTO,
  JoinSessionResultDTO,
  MergedItemDTO,
  MergeSessionsResultDTO,
  CompareSessionsResultDTO,
  SessionHistoryResponseDTO,
} from './ProductReceiveDataSource.types';

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
    startDate?: string;
    endDate?: string;
    timezone: string;
    // v2 parameters
    status?: 'pending' | 'process' | 'complete' | 'cancelled';
    supplierId?: string;
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

  // Get local time string in 'YYYY-MM-DD HH:mm:ss' format (user's device local time)
  // This is the format expected by RPC functions
  private getLocalTimeString(): string {
    const now = new Date();
    const year = now.getFullYear();
    const month = String(now.getMonth() + 1).padStart(2, '0');
    const day = String(now.getDate()).padStart(2, '0');
    const hours = String(now.getHours()).padStart(2, '0');
    const minutes = String(now.getMinutes()).padStart(2, '0');
    const seconds = String(now.getSeconds()).padStart(2, '0');
    return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
  }

  // Transform RPC item to SearchProductDTO format
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  private transformSearchItem(item: any): SearchProductDTO {
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
      // v6 variant fields
      variant_id: item.variant_id,
      variant_name: item.variant_name,
      variant_sku: item.variant_sku,
      variant_barcode: item.variant_barcode,
      display_name: item.display_name || item.product_name,
      display_sku: item.display_sku || item.product_sku,
      display_barcode: item.display_barcode || item.product_barcode,
      has_variants: item.has_variants ?? false,
      created_at: item.created_at,
      // Nested structures
      stock: item.stock || { quantity_on_hand: 0, quantity_available: 0, quantity_reserved: 0 },
      price: item.price || { cost: 0, selling: 0, source: 'default' },
      status: item.status || { stock_level: 'normal', is_active: true },
    };
  }

  async searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page: number = 1,
    limit: number = 10
  ): Promise<{ products: SearchProductDTO[]; currency: CurrencyDTO }> {
    const client = supabaseService.getClient();

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await client.rpc('get_inventory_page_v6' as any, {
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

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const response = data as any;
    if (!response?.success) {
      throw new Error(response?.error || 'Search failed');
    }

    // Transform items to ensure consistent format
    const rawItems = response.data?.items || [];
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const products = rawItems.map((item: any) => this.transformSearchItem(item));

    return {
      products,
      currency: {
        symbol: response.data?.currency?.symbol || '₫',
        code: response.data?.currency?.code || 'VND',
      },
    };
  }

  async addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItemDTO[]
  ): Promise<void> {
    const client = supabaseService.getClient();
    const localTime = this.getLocalTimeString();

    const { data, error } = await client.rpc('inventory_add_session_items_v2', {
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

    const { data, error } = await client.rpc('inventory_get_session_items_v2', {
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
    const localTime = this.getLocalTimeString();
    const timezone = this.getTimezone();

    // Debug: Log submit parameters
    console.log('🕐 [submitSession] Time Debug:', {
      localTime,
      timezone,
      browserDate: new Date().toString(),
      browserTimezoneOffset: new Date().getTimezoneOffset(),
    });

    // Use inventory_submit_session_v3 for variant support in stock_changes
    const { data, error } = await client.rpc('inventory_submit_session_v3', {
      p_session_id: sessionId,
      p_user_id: userId,
      p_items: items,
      p_is_final: isFinal,
      p_time: localTime,
      p_timezone: timezone,
      p_notes: notes || null,
    });

    console.log('📤 [submitSession] RPC Response:', { success: data?.success, error: error?.message });

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
      // v3 fields
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

    // v2: supports variant_id, variant_name, display_name, has_variants in items
    // v2: receiving progress now matches by (product_id, variant_id)
    const { data, error } = await client.rpc('inventory_get_shipment_detail_v2', {
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
    startDate?: string;
    endDate?: string;
    timezone: string;
    // v2 parameters
    status?: 'pending' | 'process' | 'complete' | 'cancelled';
    supplierId?: string;
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
    // v2: date filter parameters
    if (params.startDate) {
      rpcParams.p_start_date = `${params.startDate} 00:00:00`;
    }
    if (params.endDate) {
      rpcParams.p_end_date = `${params.endDate} 23:59:59`;
    }
    // v2: status filter (pending, process, complete, cancelled)
    if (params.status) {
      rpcParams.p_status = params.status;
    }
    // v2: supplier filter
    if (params.supplierId) {
      rpcParams.p_supplier_id = params.supplierId;
    }

    // Use v2 RPC which supports date, status, and supplier filters
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await client.rpc('inventory_get_session_list_v2' as any, rpcParams);

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

    // Debug: Log create session parameters
    console.log('🕐 [createSession] Time Debug:', {
      time: params.time,
      timezone: params.timezone,
      browserDate: new Date().toString(),
      browserTimezoneOffset: new Date().getTimezoneOffset(),
    });

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

    const { data, error } = await client.rpc('inventory_create_session_v2', rpcParams);

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

    const { data, error } = await client.rpc('inventory_get_session_items_v2', {
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
    const localTime = this.getLocalTimeString();

    // Use inventory_merge_sessions_v2 for variant support
    const { data, error } = await client.rpc('inventory_merge_sessions_v2', {
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
        session_type: data.data?.target_session?.session_type || '',
        store_id: data.data?.target_session?.store_id || '',
        store_name: data.data?.target_session?.store_name || '',
        items_before: data.data?.target_session?.items_before || 0,
        items_after: data.data?.target_session?.items_after || 0,
        quantity_before: data.data?.target_session?.quantity_before || 0,
        quantity_after: data.data?.target_session?.quantity_after || 0,
        members_before: data.data?.target_session?.members_before || 0,
        members_after: data.data?.target_session?.members_after || 0,
      },
      source_session: {
        session_id: data.data?.source_session?.session_id || params.sourceSessionId,
        session_name: data.data?.source_session?.session_name || '',
        items_copied: data.data?.source_session?.items_copied || 0,
        quantity_copied: data.data?.source_session?.quantity_copied || 0,
        members_added: data.data?.source_session?.members_added || 0,
        deactivated: data.data?.source_session?.deactivated || false,
      },
      merged_items: (data.data?.merged_items || []).map((item: MergedItemDTO) => ({
        item_id: item.item_id,
        product_id: item.product_id,
        variant_id: item.variant_id,
        sku: item.sku,
        product_name: item.product_name,
        variant_name: item.variant_name,
        display_name: item.display_name,
        has_variants: item.has_variants,
        quantity: item.quantity,
        quantity_rejected: item.quantity_rejected,
        scanned_by: item.scanned_by,
        scanned_by_name: item.scanned_by_name,
      })),
      summary: {
        total_items_copied: data.data?.summary?.total_items_copied || 0,
        total_quantity_copied: data.data?.summary?.total_quantity_copied || 0,
        total_members_added: data.data?.summary?.total_members_added || 0,
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

    // Use inventory_compare_sessions_v2 for variant support
    const { data, error } = await client.rpc('inventory_compare_sessions_v2', {
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

    const { data, error } = await client.rpc('inventory_get_session_history_v3', rpcParams);

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
