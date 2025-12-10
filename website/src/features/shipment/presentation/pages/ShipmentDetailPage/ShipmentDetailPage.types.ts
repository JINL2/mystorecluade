/**
 * ShipmentDetailPage Types
 * Type definitions for ShipmentDetailPage component
 */

// Currency interface
export interface Currency {
  symbol: string;
  code: string;
}

// Shipment item interface from RPC
export interface ShipmentItem {
  item_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  quantity_shipped: number;
  unit_cost: number;
  total_amount: number;
}

// Linked order interface from RPC
export interface LinkedOrder {
  order_id: string;
  order_number: string;
  status: string;
}

// Shipment detail interface from RPC
export interface ShipmentDetail {
  // Shipment Header
  shipment_id: string;
  shipment_number: string;
  tracking_number: string | null;
  shipped_date: string;
  status: 'pending' | 'process' | 'complete' | 'cancelled';
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
  items: ShipmentItem[];

  // Linked Orders
  has_orders: boolean;
  order_count: number;
  orders: LinkedOrder[];

  // Actions
  can_cancel: boolean;
}
