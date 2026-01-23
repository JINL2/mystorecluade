/**
 * ProductDetailsForm Component Types
 */

import type { InventoryMetadata } from '../../../domain/entities/InventoryMetadata';

export interface ProductFormData {
  productName: string;
  category: string;
  brand: string;
  productType: string;
  barcode: string;
  sku: string;
  currentStock: string | number;
  unit: string;
  costPrice: string | number;
  sellingPrice: string | number;
  // v6 variant attribute selection: Map<attributeId -> selectedOptionId>
  selectedAttributes?: Record<string, string>;
}

export interface ProductDetailsFormProps {
  formData: ProductFormData;
  metadata: InventoryMetadata | null;
  onInputChange: (field: string, value: string | number) => void;
  onAttributeChange?: (attributeId: string, optionId: string) => void;
  onAddBrand: () => void;
  onAddCategory: () => void;
  onAddAttribute?: () => void;
  // v6: Show if product has variants (for display purposes)
  hasVariants?: boolean;
  variantName?: string | null;
}
