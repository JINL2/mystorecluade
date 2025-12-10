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

/** Order item from order details (from inventory_get_order_items RPC) */
export interface OrderItem {
  order_item_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  ordered_quantity: number;
  fulfilled_quantity: number;
  remaining_quantity: number;
  unit_price: number;
}

/** Linked order in shipment detail */
export interface LinkedOrder {
  order_id: string;
  order_number: string;
  status: string;
}

// ===== Product Types =====

/** Product interface from inventory RPC response */
export interface InventoryProduct {
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

/** Shipment item to create */
export interface ShipmentItem {
  orderItemId: string;
  orderId: string;
  orderNumber: string;
  productId: string;
  productName: string;
  sku: string;
  quantity: number;
  maxQuantity: number;
  unitPrice: number;
}

/** Shipment detail item (from inventory_get_shipment_detail RPC) */
export interface ShipmentDetailItem {
  item_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  quantity_shipped: number;
  unit_cost: number;
  total_amount: number;
}

/** Shipment detail (from inventory_get_shipment_detail RPC) */
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

  // Shipment Items
  items: ShipmentDetailItem[];

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

/** Item structure for RPC call */
export interface CreateShipmentItem {
  sku: string;
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
