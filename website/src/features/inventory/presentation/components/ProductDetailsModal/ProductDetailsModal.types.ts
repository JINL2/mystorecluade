/**
 * ProductDetailsModal Component Types
 */

import type { InventoryMetadata } from '../../../domain/entities/InventoryMetadata';

export interface ProductDetailsModalProps {
  isOpen: boolean;
  onClose: () => void;
  productId: string;
  companyId: string;
  productData?: {
    productName: string;
    productCode: string;
    barcode: string;
    category?: string;
    brand?: string;
    productType: string;
    sku: string;
    currentStock: number;
    unit?: string;
    unitPrice: number;
    costPrice?: number;
  };
  metadata?: InventoryMetadata | null;
  onSave?: (updatedData: any) => void;
  onMetadataRefresh?: () => void;
}
