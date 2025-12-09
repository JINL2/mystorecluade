/**
 * ShipmentCreatePage Types
 * Type definitions for ShipmentCreatePage component
 */

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

// Order info for selection (from inventory_get_order_info RPC)
export interface OrderInfo {
  order_id: string;
  order_number: string;
  order_date: string;
  supplier_id: string;
  supplier_name: string;
  total_amount: number;
  status: 'pending' | 'process';
}

// Order item from order details
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

// Shipment item to create
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

// Currency interface
export interface Currency {
  symbol: string;
  code: string;
}

// Save result state
export interface SaveResult {
  show: boolean;
  success: boolean;
  message: string;
  shipmentNumber?: string;
}
