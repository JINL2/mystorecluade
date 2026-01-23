/**
 * MoveProductModal Component Types
 */

export interface MoveProductModalProps {
  isOpen: boolean;
  onClose: () => void;
  productId: string;
  variantId?: string | null; // v2: variant support
  productName: string;
  currentStock: number;
  sourceStoreId: string;
  companyId: string;
  onMove?: (targetStoreId: string, quantity: number, notes: string, sourceStoreId?: string) => Promise<void>;
}
