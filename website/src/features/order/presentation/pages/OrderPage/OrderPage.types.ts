/**
 * OrderPage Types
 * Type definitions for OrderPage component
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

// Order type matching RPC response
export interface PurchaseOrder {
  order_id: string;
  order_number: string;
  order_date: string;
  supplier_id: string;
  supplier_name: string;
  order_status: 'draft' | 'pending' | 'approved' | 'cancelled';
  receiving_status: 'pending' | 'partial' | 'received' | 'cancelled';
  total_amount: number;
  item_count: number;
  fulfilled_percentage: number;
  created_at: string;
  created_by: string | null;
}

// Filter state interface
export interface OrderFilters {
  searchQuery: string;
  datePreset: DatePreset;
  fromDate: string;
  toDate: string;
  orderStatusFilter: Set<string>;
  receivingStatusFilter: Set<string>;
  selectedSupplier: string | null;
}

// Custom date picker state
export interface DatePickerState {
  showDatePicker: boolean;
  tempFromDate: string;
  tempToDate: string;
}

// Order status options
export const ORDER_STATUS_OPTIONS = [
  { value: 'draft', label: 'Draft' },
  { value: 'pending', label: 'Pending' },
  { value: 'approved', label: 'Approved' },
  { value: 'cancelled', label: 'Cancelled' },
];

// Receiving status options
export const RECEIVING_STATUS_OPTIONS = [
  { value: 'pending', label: 'Pending' },
  { value: 'partial', label: 'Partial' },
  { value: 'received', label: 'Received' },
  { value: 'cancelled', label: 'Cancelled' },
];
