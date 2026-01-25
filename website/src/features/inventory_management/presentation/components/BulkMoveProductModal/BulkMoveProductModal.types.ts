/**
 * BulkMoveProductModal Component Types
 */

export interface ProductToMove {
  productId: string;
  variantId?: string | null; // v4: variant support
  productName: string;
  productCode: string;
  currentStock: number;
}

export interface BulkMoveProductModalProps {
  isOpen: boolean;
  onClose: () => void;
  products: ProductToMove[];
  sourceStoreId: string;
  companyId: string;
  onMove?: (targetStoreId: string, items: Array<{ productId: string; variantId?: string | null; productName: string; quantity: number }>, notes: string, sourceStoreId?: string) => Promise<void>;
}
