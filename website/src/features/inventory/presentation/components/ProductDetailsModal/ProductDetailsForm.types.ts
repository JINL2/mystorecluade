/**
 * ProductDetailsForm Component Types
 */

import type { InventoryMetadata } from '../../hooks/useInventoryMetadata';

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
}

export interface ProductDetailsFormProps {
  formData: ProductFormData;
  metadata: InventoryMetadata | null;
  onInputChange: (field: string, value: string | number) => void;
  onAddBrand: () => void;
  onAddCategory: () => void;
}
