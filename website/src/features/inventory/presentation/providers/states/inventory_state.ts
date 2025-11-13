/**
 * Inventory State Interface
 * State interface definition for inventory feature
 *
 * Following 2025 Best Practice:
 * - Zustand for state management
 * - Async operations in store
 * - Repository pattern integration
 */

import type { InventoryItem, UpdateProductData, NotificationState, CurrencyInfo, UpdateProductResult } from './types';

export interface InventoryState {
  // ============================================
  // DATA STATE
  // ============================================
  inventory: InventoryItem[];
  currency: CurrencyInfo;

  // ============================================
  // UI STATE
  // ============================================
  selectedStoreId: string | null;
  searchQuery: string;
  selectedProducts: Set<string>;

  // ============================================
  // MODAL STATE
  // ============================================
  isModalOpen: boolean;
  selectedProductData: InventoryItem | null;
  isAddProductModalOpen: boolean;

  // ============================================
  // LOADING/ERROR STATE
  // ============================================
  loading: boolean;
  error: string | null;

  // ============================================
  // NOTIFICATION STATE
  // ============================================
  notification: NotificationState;

  // ============================================
  // SYNCHRONOUS ACTIONS
  // ============================================
  setSelectedStoreId: (storeId: string | null) => void;
  setSearchQuery: (query: string) => void;
  toggleProductSelection: (productId: string) => void;
  selectAllProducts: () => void;
  clearSelection: () => void;

  openModal: (productData: InventoryItem) => void;
  closeModal: () => void;

  openAddProductModal: () => void;
  closeAddProductModal: () => void;

  showNotification: (variant: 'success' | 'error', message: string) => void;
  hideNotification: () => void;

  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  clearError: () => void;

  // ============================================
  // ASYNCHRONOUS ACTIONS
  // ============================================
  loadInventory: (companyId: string, storeId: string | null, searchQuery?: string) => Promise<void>;
  updateProduct: (productId: string, companyId: string, storeId: string, data: UpdateProductData) => Promise<UpdateProductResult>;
  refresh: () => Promise<void>;
}
