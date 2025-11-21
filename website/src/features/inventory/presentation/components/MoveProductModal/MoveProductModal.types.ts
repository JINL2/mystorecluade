/**
 * MoveProductModal Component Types
 */

export interface MoveProductModalProps {
  isOpen: boolean;
  onClose: () => void;
  productId: string;
  productName: string;
  currentStock: number;
  sourceStoreId: string;
  companyId: string;
  onMove?: (targetStoreId: string, quantity: number, notes: string) => Promise<void>;
}
