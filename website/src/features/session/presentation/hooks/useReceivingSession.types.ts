/**
 * useReceivingSession Types
 * Presentation layer types and re-exports for backward compatibility
 */

// Re-export types for backward compatibility
export type {
  ReceivedEntry,
  EditableItem,
  ActiveSession,
} from '../providers/states/receiving_session_state';

// Re-export domain entities for backward compatibility
export type { SearchProduct, SessionItem } from '../../domain/entities';

// Presentation layer types for backward compatibility
export interface SessionItemPresentation {
  product_id: string;
  product_name: string;
  total_quantity: number;
  total_rejected: number;
  scanned_by: {
    user_id: string;
    user_name: string;
    quantity: number;
    quantity_rejected: number;
  }[];
}

export interface SessionItemsSummaryPresentation {
  total_products: number;
  total_quantity: number;
  total_rejected: number;
}

export interface EditableItemPresentation {
  product_id: string;
  product_name: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SearchProductPresentation {
  // 제품 정보
  product_id: string;
  product_name: string;
  product_sku: string;
  product_barcode?: string;
  product_type: string;
  brand_id?: string;
  brand_name?: string;
  category_id?: string;
  category_name?: string;
  unit: string;
  image_urls?: string[];

  // 변형 정보
  variant_id?: string;
  variant_name?: string;
  variant_sku?: string;
  variant_barcode?: string;

  // 표시용
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
  status: {
    stock_level: 'normal' | 'low' | 'out_of_stock' | 'overstock';
    is_active: boolean;
  };

  // 메타
  has_variants: boolean;
  created_at: string;
}
