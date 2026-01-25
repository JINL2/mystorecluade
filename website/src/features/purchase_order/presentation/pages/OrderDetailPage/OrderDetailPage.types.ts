/**
 * OrderDetailPage Types
 * Type definitions for OrderDetailPage component
 */

// Currency interface
export interface Currency {
  symbol: string;
  code: string;
}

// Order item interface from RPC (v2: variant support)
export interface OrderItem {
  item_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  quantity_ordered: number;
  quantity_fulfilled: number;
  unit_price: number;
  total_amount: number;
  // v2: variant fields
  variant_id: string | null;
  variant_name: string | null;
  display_name: string; // Product name (Variant) or just Product name
  has_variants: boolean;
}

// Shipment interface from RPC
export interface Shipment {
  shipment_id: string;
  shipment_number: string;
  status: string;
}

// Order detail interface from RPC
export interface OrderDetail {
  order_id: string;
  order_number: string;
  order_date: string;
  order_status: 'draft' | 'pending' | 'approved' | 'cancelled';
  receiving_status: 'pending' | 'partial' | 'received' | 'cancelled';
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
  items: OrderItem[];
  has_shipments: boolean;
  shipment_count: number;
  shipments: Shipment[];
  fulfilled_percentage: number;
  can_cancel: boolean;
}
