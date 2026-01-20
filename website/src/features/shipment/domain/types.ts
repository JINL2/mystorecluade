/**
 * Shipment State Types
 * Shared type definitions for shipment feature
 * All common types consolidated here to avoid duplication
 */

// ===== Common Types =====

/** Currency interface used across shipment feature */
export interface Currency {
  symbol: string;
  code: string;
}

/** Counterparty interface (from get_counterparty_info RPC) */
export interface Counterparty {
  counterparty_id: string;
  name: string;
  type: string;
  email: string | null;
  phone: string | null;
  address: string | null;
  notes: string | null;
  is_internal: boolean;
}

/** One-time supplier for shipment (not registered in system) */
export interface OneTimeSupplier {
  name: string;
  phone: string;
  email: string;
  address: string;
}

// ===== Order Types =====

/** Order info for selection (from inventory_get_order_info RPC) */
export interface OrderInfo {
  order_id: string;
  order_number: string;
  order_date: string;
  supplier_id: string;
  supplier_name: string;
  total_amount: number;
  status: 'pending' | 'process';
}

/** Linked order in shipment detail */
export interface LinkedOrder {
  order_id: string;
  order_number: string;
  status: string;
}

// ===== Product Types =====

/** Product interface from inventory RPC response (get_inventory_page_v6) */
export interface InventoryProduct {
  // 제품 정보
  product_id: string;
  product_name: string;
  product_sku: string;
  product_barcode?: string;
  product_type?: string;
  brand_id?: string;
  brand_name?: string;
  category_id?: string;
  category_name?: string;
  unit?: string;
  image_urls?: string[];

  // 변형 정보 (v6 신규)
  variant_id?: string | null;
  variant_name?: string | null;
  variant_sku?: string | null;
  variant_barcode?: string | null;

  // 표시용 (v6 신규)
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
  status?: {
    stock_level: string;
    is_active: boolean;
  };

  // 메타 (v6 신규)
  has_variants?: boolean;
  created_at?: string;

  // v4 호환 (deprecated, v6에서는 display_sku 사용)
  sku?: string;
  barcode?: string;
}

// ===== Shipment Types =====

/** Shipment status enum */
export type ShipmentStatus = 'pending' | 'process' | 'complete' | 'cancelled';

/** Selection mode - either select from order or enter supplier directly */
export type SelectionMode = 'order' | 'supplier' | null;

/** Date preset types for filtering */
export type DatePreset = 'this_month' | 'last_month' | 'this_year' | 'custom';

/** Shipment list item (from inventory_get_shipment_list RPC) */
export interface ShipmentListItem {
  shipment_id: string;
  shipment_number: string;
  tracking_number: string | null;
  shipped_date: string;
  supplier_id: string | null;
  supplier_name: string;
  status: ShipmentStatus;
  item_count: number;
  has_orders: boolean;
  linked_order_count: number;
  notes: string | null;
  created_at: string;
  created_by: string | null;
}

/** Shipment item to create (v6: variant support) */
export interface ShipmentItem {
  orderItemId: string;
  orderId: string;
  orderNumber: string;
  productId: string;
  variantId?: string; // v6: variant support
  productName: string;
  sku: string;
  quantity: number;
  maxQuantity: number;
  unitPrice: number;
}

/** Shipment detail item (from inventory_get_shipment_detail_v2 RPC) */
export interface ShipmentDetailItem {
  item_id: string;
  product_id: string;
  variant_id: string | null; // v2: variant support
  product_name: string;
  variant_name: string | null; // v2: variant support
  display_name: string; // v2: variant support
  has_variants: boolean; // v2: variant support
  sku: string;
  quantity_shipped: number;
  quantity_received: number;
  quantity_accepted: number;
  quantity_rejected: number;
  quantity_remaining: number;
  unit_cost: number;
  total_amount: number;
}

/** Receiving summary (from inventory_get_shipment_detail_v2 RPC) */
export interface ReceivingSummary {
  total_shipped: number;
  total_received: number;
  total_accepted: number;
  total_rejected: number;
  total_remaining: number;
  progress_percentage: number;
}

/** Shipment detail (from inventory_get_shipment_detail_v2 RPC) */
export interface ShipmentDetail {
  // Shipment Header
  shipment_id: string;
  shipment_number: string;
  tracking_number: string | null;
  shipped_date: string;
  status: ShipmentStatus;
  total_amount: number;
  notes: string | null;
  created_by: string | null;
  created_at: string;

  // Supplier Info
  supplier_id: string | null;
  supplier_name: string;
  supplier_phone: string | null;
  supplier_email: string | null;
  supplier_address: string | null;
  is_registered_supplier: boolean;

  // Shipment Items (v2: with variant support)
  items: ShipmentDetailItem[];

  // Receiving Summary (v2: new field)
  receiving_summary?: ReceivingSummary;

  // Linked Orders
  has_orders: boolean;
  order_count: number;
  orders: LinkedOrder[];

  // Actions
  can_cancel: boolean;
}

// ===== Create Shipment Types =====

/** Parameters for creating a shipment */
export interface CreateShipmentParams {
  companyId: string;
  userId: string;
  items: CreateShipmentItem[];
  time: string;
  timezone: string;
  orderIds?: string[];
  counterpartyId?: string;
  supplierInfo?: Partial<OneTimeSupplier>;
  trackingNumber?: string;
  notes?: string;
}

/** Item structure for RPC call (v3: variant support) */
export interface CreateShipmentItem {
  sku: string;
  variant_id: string | null; // v3: required (null for non-variant products)
  quantity_shipped: number;
  unit_cost: number;
}

// ===== Filter Types =====

/** Filter state interface for shipment list */
export interface ShipmentFilters {
  searchQuery: string;
  datePreset: DatePreset;
  fromDate: string;
  toDate: string;
  shipmentStatusFilter: string | null;
  supplierFilter: string | null;
  orderFilter: string | null;
}

/** Custom date picker state */
export interface DatePickerState {
  showDatePicker: boolean;
  tempFromDate: string;
  tempToDate: string;
}

// ===== UI State Types =====

/** Save result state */
export interface SaveResult {
  show: boolean;
  success: boolean;
  message: string;
  shipmentNumber?: string;
}

/** Import error state */
export interface ImportError {
  show: boolean;
  notFoundSkus: string[];
}

// ===== Selector Option Types =====

/** Supplier option for TossSelector */
export interface SupplierOption {
  value: string;
  label: string;
  description?: string;
}

/** Order option for TossSelector */
export interface OrderOption {
  value: string;
  label: string;
}

// ===== Status Options =====

/** Shipment status options for filter */
export const SHIPMENT_STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'process', label: 'Process' },
  { value: 'complete', label: 'Complete' },
  { value: 'cancelled', label: 'Cancelled' },
] as const;
