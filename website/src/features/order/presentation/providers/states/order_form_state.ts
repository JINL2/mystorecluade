/**
 * Order Form State Interface
 * State interface definition for order form component
 *
 * Following 2025 Best Practice:
 * - Separate state for complex forms
 * - Zustand for state management
 * - Form validation integration
 */

import type { Counterparty } from '../../../data/models/CounterpartyModel';
import type { Product } from '../../../data/models/ProductModel';

/**
 * Supplier information for "Others" tab
 */
export interface SupplierInfo {
  name: string;
  contact: string;
  phone: string;
  email: string;
  address: string;
  bank_account: string;
  memo: string;
}

/**
 * Order form item (presentation layer)
 */
export interface OrderFormItem {
  product_id: string;
  product_name: string;
  sku: string;
  unit: string;
  quantity: number;
  unit_price: number;
  subtotal: number;
}

/**
 * Supplier tab type
 */
export type SupplierTabType = 'counter-party' | 'others';

/**
 * Order form validation errors
 */
export interface ValidationErrors {
  orderDate?: string;
  supplier?: string;
  items?: string;
  [key: string]: string | undefined;
}

/**
 * Order Form State
 */
export interface OrderFormState {
  // ============================================
  // FORM DATA STATE
  // ============================================
  orderDate: string;
  notes: string;
  supplierTab: SupplierTabType;
  selectedSupplier: Counterparty | null;
  supplierInfo: SupplierInfo;
  orderItems: OrderFormItem[];

  // ============================================
  // UI STATE
  // ============================================
  isDropdownOpen: boolean;
  searchTerm: string;
  showSuggestions: boolean;
  searchResults: Product[];

  // ============================================
  // LOADING/ERROR STATE
  // ============================================
  isCreating: boolean;
  error: string | null;
  validationErrors: ValidationErrors;

  // ============================================
  // SYNCHRONOUS ACTIONS
  // ============================================
  setOrderDate: (date: string) => void;
  setNotes: (notes: string) => void;
  setSupplierTab: (tab: SupplierTabType) => void;
  setSelectedSupplier: (supplier: Counterparty | null) => void;
  setSupplierInfo: (info: Partial<SupplierInfo>) => void;
  setOrderItems: (items: OrderFormItem[]) => void;

  setIsDropdownOpen: (isOpen: boolean) => void;
  setSearchTerm: (term: string) => void;
  setShowSuggestions: (show: boolean) => void;
  setSearchResults: (results: Product[]) => void;

  setIsCreating: (isCreating: boolean) => void;
  setError: (error: string | null) => void;
  setValidationErrors: (errors: ValidationErrors) => void;
  clearErrors: () => void;

  // ============================================
  // FORM ACTIONS
  // ============================================
  addOrderItem: (product: Product) => void;
  updateOrderItemQuantity: (productId: string, quantity: number) => void;
  updateOrderItemPrice: (productId: string, unitPrice: number) => void;
  removeOrderItem: (productId: string) => void;

  searchProducts: (query: string, allProducts: Product[]) => void;
  clearSearch: () => void;

  validateForm: () => boolean;
  resetForm: () => void;

  // ============================================
  // COMPUTED VALUES (GETTERS)
  // ============================================
  getSummary: () => {
    items: number;
    totalQuantity: number;
    subtotal: number;
  };
}
