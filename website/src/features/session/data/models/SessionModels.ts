/**
 * Session Models
 * DTO types for session-related data
 * Note: Mapper functions are defined in ProductReceiveRepositoryImpl.ts
 */

// ============ DTO Types ============

// SearchProductDTO (get_inventory_page_v6 응답)
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

export interface SessionParticipantDTO {
  user_id: string;
  user_name: string;
  user_profile_image: string | null;
  product_count: number;
  total_scanned: number;
}

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
  stock_changes?: StockChangeDTO[];
  new_display_count?: number;
  total_cost?: number;
}

export interface CounterpartyDTO {
  counterparty_id: string;
  name: string;
  is_internal?: boolean;
}

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

export interface CreateSessionResultDTO {
  session_id: string;
  [key: string]: unknown;
}

export interface JoinSessionResultDTO {
  member_id?: string;
  created_by?: string;
  created_by_name?: string;
}
