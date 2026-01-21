/**
 * ProductReceiveDataSource Types
 * DTO type definitions for Supabase RPC responses
 */

// Types for RPC responses (get_inventory_page_v6)
export interface SearchProductDTO {
  // 제품 정보
  product_id: string;
  product_name: string;
  product_sku: string;
  product_barcode?: string;
  product_type: string;
  brand_id?: string;
  brand_name?: string;
  category_id?: string;
  category_name?: string;
  unit: string;
  image_urls?: string[];

  // 변형 정보
  variant_id?: string;
  variant_name?: string;
  variant_sku?: string;
  variant_barcode?: string;

  // 표시용
  display_name: string;
  display_sku: string;
  display_barcode?: string;

  // 재고
  stock: {
    quantity_on_hand: number;
    quantity_available: number;
    quantity_reserved: number;
  };

  // 가격
  price: {
    cost: number;
    selling: number;
    source: string;
  };

  // 상태
  status: {
    stock_level: 'normal' | 'low' | 'out_of_stock' | 'overstock';
    is_active: boolean;
  };

  // 메타
  has_variants: boolean;
  created_at: string;
}

export interface SessionItemUserDTO {
  user_id: string;
  user_name: string;
  quantity: number;
  quantity_rejected: number;
  started_at?: string;
}

export interface SessionItemDTO {
  product_id: string;
  variant_id?: string | null;
  product_name: string;
  variant_name?: string | null;
  display_name: string;
  sku: string;
  variant_sku?: string | null;
  display_sku: string;
  has_variants: boolean;
  image_urls?: string[] | null;
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

export interface CurrencyDTO {
  symbol: string;
  code: string;
}

export interface SaveItemDTO {
  product_id: string;
  variant_id: string | null;
  quantity: number;
  quantity_rejected: number;
}

export interface SubmitItemDTO {
  product_id: string;
  variant_id: string | null;
  quantity: number;
  quantity_rejected: number;
}

// Stock change item for v3 submit
export interface StockChangeDTO {
  product_id: string;
  variant_id?: string | null;
  variant_name?: string | null;
  display_name: string;
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
  // v3 fields
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
  variant_id?: string | null;
  product_name: string;
  variant_name?: string | null;
  display_name?: string;
  has_variants?: boolean;
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

// Session DTO (v2.1 - supports status, supplier filters)
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
  // v2.1 fields (status: in_progress, complete, cancelled)
  status?: 'in_progress' | 'complete' | 'cancelled';
  supplier_id?: string;
  supplier_name?: string;
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

// Merged item DTO for v2 merge result
export interface MergedItemDTO {
  item_id: string;
  product_id: string;
  variant_id: string | null;
  sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
  quantity: number;
  quantity_rejected: number;
  scanned_by: string;
  scanned_by_name: string;
}

// Merge Sessions Result DTO (v2)
export interface MergeSessionsResultDTO {
  target_session: {
    session_id: string;
    session_name: string;
    session_type: string;
    store_id: string;
    store_name: string;
    items_before: number;
    items_after: number;
    quantity_before: number;
    quantity_after: number;
    members_before: number;
    members_after: number;
  };
  source_session: {
    session_id: string;
    session_name: string;
    items_copied: number;
    quantity_copied: number;
    members_added: number;
    deactivated: boolean;
  };
  merged_items: MergedItemDTO[];
  summary: {
    total_items_copied: number;
    total_quantity_copied: number;
    total_members_added: number;
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

// Compare matched item DTO (v2 with variant support)
export interface CompareMatchedItemDTO {
  product_id: string;
  variant_id: string | null;
  sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
  quantity_a: number;
  quantity_b: number;
  quantity_diff: number;
  is_match: boolean;
}

// Compare only item DTO (v2 with variant support)
export interface CompareOnlyItemDTO {
  product_id: string;
  variant_id: string | null;
  sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
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

// Session History DTOs (inventory_get_session_history_v4)
// Updated to match actual RPC response structure with variant support and server-side search

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
  variant_id: string | null;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  sku: string | null;
  variant_sku: string | null;
  display_sku: string;
  has_variants: boolean;
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
      variant_id: string | null;
      sku: string;
      variant_sku: string | null;
      display_sku: string;
      product_name: string;
      variant_name: string | null;
      display_name: string;
      has_variants: boolean;
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
      variant_id: string | null;
      sku: string;
      variant_sku: string | null;
      display_sku: string;
      product_name: string;
      variant_name: string | null;
      display_name: string;
      has_variants: boolean;
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
  variant_id: string | null;
  sku: string;
  variant_sku: string | null;
  display_sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
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
  p_search?: string | null; // Server-side search (session_name, product_name, SKU, product_id)
}
