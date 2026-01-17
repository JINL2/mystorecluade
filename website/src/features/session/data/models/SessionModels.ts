/**
 * Session Models
 * DTO types and mappers for session-related data
 */

import type {
  SessionItem,
  SessionItemsSummary,
  SessionParticipant,
  Session,
  CreateSessionResult,
  JoinSessionResult,
  SaveItem,
  SubmitItem,
  SubmitResult,
  StockChange,
  Currency,
  Counterparty,
  SearchProduct,
} from '../../domain/entities';

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

// ============ Mapper Functions: DTO -> Domain Entity ============

export const mapSearchProductDTO = (dto: SearchProductDTO): SearchProduct => ({
  // 제품 정보
  productId: dto.product_id,
  productName: dto.product_name,
  productSku: dto.product_sku,
  productBarcode: dto.product_barcode,
  productType: dto.product_type,
  brandId: dto.brand_id,
  brandName: dto.brand_name,
  categoryId: dto.category_id,
  categoryName: dto.category_name,
  unit: dto.unit,
  imageUrls: dto.image_urls,

  // 변형 정보
  variantId: dto.variant_id,
  variantName: dto.variant_name,
  variantSku: dto.variant_sku,
  variantBarcode: dto.variant_barcode,

  // 표시용
  displayName: dto.display_name,
  displaySku: dto.display_sku,
  displayBarcode: dto.display_barcode,

  // 재고
  stock: {
    quantityOnHand: dto.stock.quantity_on_hand,
    quantityAvailable: dto.stock.quantity_available,
    quantityReserved: dto.stock.quantity_reserved,
  },

  // 가격
  price: {
    cost: dto.price.cost,
    selling: dto.price.selling,
    source: dto.price.source,
  },

  // 상태
  status: {
    stockLevel: dto.status.stock_level,
    isActive: dto.status.is_active,
  },

  // 메타
  hasVariants: dto.has_variants,
  createdAt: dto.created_at,
});

export const mapSessionItemDTO = (dto: SessionItemDTO): SessionItem => ({
  productId: dto.product_id,
  variantId: dto.variant_id,
  productName: dto.product_name,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  sku: dto.sku,
  variantSku: dto.variant_sku,
  displaySku: dto.display_sku,
  hasVariants: dto.has_variants,
  imageUrls: dto.image_urls,
  totalQuantity: dto.total_quantity,
  totalRejected: dto.total_rejected,
  scannedBy: dto.scanned_by.map((user) => ({
    userId: user.user_id,
    userName: user.user_name,
    quantity: user.quantity,
    quantityRejected: user.quantity_rejected,
    startedAt: user.started_at,
  })),
});

export const mapSessionItemsSummaryDTO = (dto: SessionItemsSummaryDTO): SessionItemsSummary => ({
  totalProducts: dto.total_products,
  totalQuantity: dto.total_quantity,
  totalRejected: dto.total_rejected,
});

export const mapSessionParticipantDTO = (dto: SessionParticipantDTO): SessionParticipant => ({
  userId: dto.user_id,
  userName: dto.user_name,
  userProfileImage: dto.user_profile_image,
  productCount: dto.product_count,
  totalScanned: dto.total_scanned,
});

export const mapStockChangeDTO = (dto: StockChangeDTO): StockChange => ({
  productId: dto.product_id,
  variantId: dto.variant_id,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  sku: dto.sku,
  productName: dto.product_name,
  quantityBefore: dto.quantity_before,
  quantityReceived: dto.quantity_received,
  quantityAfter: dto.quantity_after,
  needsDisplay: dto.needs_display,
});

export const mapCounterpartyDTO = (dto: CounterpartyDTO): Counterparty => ({
  counterpartyId: dto.counterparty_id,
  name: dto.name,
  isInternal: dto.is_internal,
});

export const mapSessionDTO = (dto: SessionDTO): Session => ({
  sessionId: dto.session_id,
  sessionName: dto.session_name,
  sessionType: dto.session_type,
  storeId: dto.store_id,
  storeName: dto.store_name,
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  isActive: dto.is_active,
  isFinal: dto.is_final,
  createdBy: dto.created_by,
  createdByName: dto.created_by_name,
  createdAt: dto.created_at,
  memberCount: dto.member_count,
});

export const mapCurrencyDTO = (dto: CurrencyDTO): Currency => ({
  symbol: dto.symbol,
  code: dto.code,
});

export const mapCreateSessionResultDTO = (dto: CreateSessionResultDTO): CreateSessionResult => ({
  sessionId: dto.session_id,
  ...dto,
});

export const mapJoinSessionResultDTO = (dto: JoinSessionResultDTO): JoinSessionResult => ({
  memberId: dto.member_id,
  createdBy: dto.created_by,
  createdByName: dto.created_by_name,
});

export const mapSubmitResultDTO = (dto: SubmitResultDTO): SubmitResult => ({
  receivingNumber: dto.receiving_number,
  itemsCount: dto.items_count,
  totalQuantity: dto.total_quantity,
  stockChanges: dto.stock_changes?.map(mapStockChangeDTO) || [],
  newDisplayCount: dto.new_display_count || 0,
  totalCost: dto.total_cost || 0,
});

// ============ Mapper Functions: Domain Entity -> DTO ============

export const mapSaveItemToDTO = (item: SaveItem): SaveItemDTO => ({
  product_id: item.productId,
  variant_id: item.variantId,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

export const mapSubmitItemToDTO = (item: SubmitItem): SubmitItemDTO => ({
  product_id: item.productId,
  variant_id: item.variantId,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});
