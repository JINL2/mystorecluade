/**
 * BulkMoveProductModal Component Types
 */

export interface ProductToMove {
  productId: string;
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
  onMove?: (targetStoreId: string, items: Array<{ productId: string; quantity: number }>, notes: string) => Promise<void>;
}
