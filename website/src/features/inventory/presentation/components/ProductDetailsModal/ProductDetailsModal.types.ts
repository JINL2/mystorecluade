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
    categoryId?: string; // Add categoryId
    brand?: string;
    brandId?: string; // Add brandId
    productType: string;
    sku: string;
    currentStock: number;
    unit?: string;
    unitPrice: number;
    costPrice?: number;
    imageUrls?: string[]; // Add imageUrls
  };
  metadata?: InventoryMetadata | null;
  onSave?: (updatedData: any, originalData?: any) => void;
  onMetadataRefresh?: () => void;
}
