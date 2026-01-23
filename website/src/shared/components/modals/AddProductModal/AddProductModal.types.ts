/**
 * AddProductModal Component Types
 */

import type { InventoryMetadata } from '@/features/inventory_management/domain/entities/InventoryMetadata';

export interface AddProductModalProps {
  isOpen: boolean;
  onClose: () => void;
  companyId: string;
  storeId: string | null;
  metadata?: InventoryMetadata | null;
  onProductAdded?: (product: any) => void;
  onMetadataRefresh?: () => void;
}

export interface ProductFormData {
  productName: string;
  sku: string;
  barcode: string;
  categoryId: string;
  brandId: string;
  unit: string;
  costPrice: string;
  sellingPrice: string;
  initialQuantity: string;
  imageUrl: string;
  thumbnailUrl: string;
  // Attribute selection for variants (only 1 attribute allowed per product)
  selectedAttributeId: string;
  selectedOptionIds: string[]; // Multiple options create multiple variants
}
