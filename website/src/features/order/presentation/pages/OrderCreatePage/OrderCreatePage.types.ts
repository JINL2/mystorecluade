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

// Product interface from RPC response (get_inventory_page_v6)
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

// Order item interface
export interface OrderItem {
  productId: string;
  variantId?: string; // v6: variant support
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
