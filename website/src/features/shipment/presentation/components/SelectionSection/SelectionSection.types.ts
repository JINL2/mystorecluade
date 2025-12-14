/**
 * SelectionSection Component Types
 * Type definitions for Order and Supplier selection sections
 */

import type { SelectorOption } from '@/shared/components/selectors/TossSelector';

export type SelectionMode = 'none' | 'order' | 'supplier';
export type SupplierType = 'existing' | 'onetime';

export interface OneTimeSupplier {
  name: string;
  phone: string;
  email: string;
  address: string;
}

export interface OrderSelectionSectionProps {
  selectionMode: SelectionMode;
  ordersLoading: boolean;
  orderOptions: SelectorOption[];
  selectedOrder: string | null;
  onOrderChange: (value: string | null) => void;
}

export interface SupplierSelectionSectionProps {
  selectionMode: SelectionMode;
  suppliersLoading: boolean;
  supplierOptions: SelectorOption[];
  selectedSupplier: string | null;
  supplierType: SupplierType;
  onSupplierTypeChange: (type: SupplierType) => void;
  onSupplierSectionChange: (value: string | null) => void;
  onClearSupplierSelection: () => void;
  oneTimeSupplier: OneTimeSupplier;
  onOneTimeSupplierChange: (field: keyof OneTimeSupplier, value: string) => void;
}
