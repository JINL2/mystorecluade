/**
 * ProductReceivePage Types
 * Type definitions for ProductReceivePage component
 * Uses inventory_get_shipment_list and inventory_get_shipment_detail RPCs
 */

// Currency interface
export interface Currency {
  symbol: string;
  code: string;
}

// Counterparty interface (from get_counterparty_info RPC)
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

// Date preset types
export type DatePreset = 'this_month' | 'last_month' | 'this_year' | 'custom';

// Shipment type (from inventory_get_shipment_list RPC)
export interface Shipment {
  shipment_id: string;
  shipment_number: string;
  tracking_number: string | null;
  shipped_date: string;
  supplier_id: string | null;
  supplier_name: string;
  status: 'pending' | 'process' | 'complete' | 'cancelled';
  item_count: number;
  has_orders: boolean;
  linked_order_count: number;
  notes: string | null;
  created_at: string;
  created_by: string | null;
}

// Shipment item with receiving progress (from inventory_get_shipment_detail RPC)
export interface ShipmentItem {
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
  total_amount: number;
}

// Receiving summary (from inventory_get_shipment_detail RPC)
export interface ReceivingSummary {
  total_shipped: number;
  total_received: number;
  total_accepted: number;
  total_rejected: number;
  total_remaining: number;
  progress_percentage: number;
}

// Linked order info
export interface LinkedOrder {
  order_id: string;
  order_number: string;
  status: string;
}

// Shipment detail (from inventory_get_shipment_detail RPC)
export interface ShipmentDetail {
  shipment_id: string;
  shipment_number: string;
  tracking_number: string | null;
  shipped_date: string;
  status: 'pending' | 'process' | 'complete' | 'cancelled';
  total_amount: number;
  notes: string | null;
  created_by: string | null;
  created_at: string;

  supplier_id: string | null;
  supplier_name: string;
  supplier_phone: string | null;
  supplier_email: string | null;
  supplier_address: string | null;
  is_registered_supplier: boolean;

  items: ShipmentItem[];
  receiving_summary: ReceivingSummary;

  has_orders: boolean;
  order_count: number;
  orders: LinkedOrder[];

  can_cancel: boolean;
}

// Filter state interface
export interface ReceiveFilters {
  searchQuery: string;
  datePreset: DatePreset;
  fromDate: string;
  toDate: string;
  shipmentStatusFilter: Set<string>;
  selectedSupplier: string | null;
}

// Custom date picker state
export interface DatePickerState {
  showDatePicker: boolean;
  tempFromDate: string;
  tempToDate: string;
}

// Shipment status options (same as Receive status)
export const SHIPMENT_STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'process', label: 'In Transit' },
  { value: 'complete', label: 'Complete' },
  { value: 'cancelled', label: 'Cancelled' },
];

// Session type (from inventory_get_session_list RPC)
export interface Session {
  session_id: string;
  session_type: 'receiving' | 'counting';
  store_id: string;
  store_name: string;
  shipment_id: string | null;
  shipment_number: string | null;
  count_id: string | null;
  is_active: boolean;
  is_final: boolean;
  member_count: number;
  created_by: string;
  created_by_name: string;
  completed_at: string | null;
  created_at: string;
}
