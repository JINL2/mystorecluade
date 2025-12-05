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

export type FilterType = 'newest' | 'oldest' | 'price_high' | 'price_low' | 'cost_high' | 'cost_low' | 'brand' | 'category';

export interface InventoryState {
  // ============================================
  // DATA STATE
  // ============================================
  inventory: InventoryItem[];
  currency: CurrencyInfo;

  // ============================================
  // PAGINATION STATE
  // ============================================
  currentPage: number;
  itemsPerPage: number;
  totalItems: number;

  // ============================================
  // UI STATE
  // ============================================
  selectedStoreId: string | null;
  searchQuery: string;
  selectedProducts: Set<string>;

  // Filter state
  filterType: FilterType;
  selectedBrandFilter: Set<string>; // Multi-select support
  selectedCategoryFilter: Set<string>; // Multi-select support

  // ============================================
  // MODAL STATE
  // ============================================
  isModalOpen: boolean;
  selectedProductData: InventoryItem | null;
  isAddProductModalOpen: boolean;
  isDeleteConfirmModalOpen: boolean;
  productsToDelete: InventoryItem[];

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
  setCurrentPage: (page: number) => void;
  toggleProductSelection: (productId: string) => void;
  selectAllProducts: () => void;
  clearSelection: () => void;

  setFilterType: (filterType: FilterType) => void;
  toggleBrandFilter: (brand: string) => void; // Multi-select toggle
  toggleCategoryFilter: (category: string) => void; // Multi-select toggle
  clearBrandFilter: () => void;
  clearCategoryFilter: () => void;
  clearFilter: () => void;

  openModal: (productData: InventoryItem) => void;
  closeModal: () => void;

  openAddProductModal: () => void;
  closeAddProductModal: () => void;

  openDeleteConfirmModal: (products: InventoryItem[]) => void;
  closeDeleteConfirmModal: () => void;

  showNotification: (variant: 'success' | 'error', message: string) => void;
  hideNotification: () => void;

  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  clearError: () => void;

  // ============================================
  // ASYNCHRONOUS ACTIONS
  // ============================================
  loadBaseCurrency: (companyId: string) => Promise<void>;
  loadInventory: (companyId: string, storeId: string | null, searchQuery?: string) => Promise<void>;
  getAllInventoryForExport: (companyId: string, storeId: string | null, searchQuery?: string) => Promise<InventoryItem[]>;
  validateProductEdit: (
    productId: string,
    companyId: string,
    originalProductName?: string,
    newProductName?: string,
    originalSku?: string,
    newSku?: string
  ) => Promise<{ success: boolean; error?: { code: string; message: string; details?: string } }>;
  updateProduct: (productId: string, companyId: string, storeId: string, data: UpdateProductData, originalData?: any) => Promise<UpdateProductResult>;
  importExcel: (companyId: string, storeId: string, userId: string, products: any[]) => Promise<{ success: boolean; summary?: any; errors?: any[]; error?: string }>;
  moveProduct: (
    companyId: string,
    fromStoreId: string,
    toStoreId: string,
    productId: string,
    quantity: number,
    notes: string,
    time: string,
    updatedBy: string
  ) => Promise<{ success: boolean; data?: any; error?: string }>;
  deleteProducts: (
    productIds: string[],
    companyId: string
  ) => Promise<{ success: boolean; message?: string; deletedCount?: number; error?: string }>;
  refresh: () => Promise<void>;
}
