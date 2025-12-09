/**
 * OrderCreatePage Types
 * Type definitions for OrderCreatePage component
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

// Product interface from RPC response
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

// Order item interface
export interface OrderItem {
  productId: string;
  productName: string;
  sku: string;
  quantity: number;
  cost: number;
}

// One-time supplier info
export interface OneTimeSupplier {
  name: string;
  phone: string;
  email: string;
  address: string;
}

// Currency interface
export interface Currency {
  symbol: string;
  code: string;
}

// Import error state
export interface ImportError {
  show: boolean;
  notFoundSkus: string[];
}

// Save result state
export interface SaveResult {
  show: boolean;
  success: boolean;
  message: string;
  orderNumber?: string;
}
