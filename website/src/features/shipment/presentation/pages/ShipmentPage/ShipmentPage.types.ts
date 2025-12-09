/**
 * ShipmentPage Types
 * Type definitions for ShipmentPage component
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

// OrderInfo interface (from inventory_get_order_info RPC)
export interface OrderInfo {
  order_id: string;
  order_number: string;
  order_date: string;
  supplier_name: string;
  total_amount: number;
  status: 'pending' | 'process';
}

// Date preset types
export type DatePreset = 'this_month' | 'last_month' | 'this_year' | 'custom';

// Shipment type matching inventory_get_shipment_list RPC response
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

// Filter state interface
export interface ShipmentFilters {
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

// Shipment status options
export const SHIPMENT_STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'process', label: 'Process' },
  { value: 'complete', label: 'Complete' },
  { value: 'cancelled', label: 'Cancelled' },
];
