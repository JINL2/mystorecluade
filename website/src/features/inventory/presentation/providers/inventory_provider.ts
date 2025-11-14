/**
 * Inventory Provider
 * Zustand store for inventory feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import type { InventoryState } from './states/inventory_state';
import { InventoryRepositoryImpl } from '../../data/repositories/InventoryRepositoryImpl';
import { InventoryValidator } from '../../domain/validators/InventoryValidator';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new InventoryRepositoryImpl();

/**
 * Inventory Store
 * Zustand store for inventory feature state
 */
export const useInventoryStore = create<InventoryState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  inventory: [],
  currency: {
    symbol: '₩',
    code: 'VND',
  },

  // Pagination
  currentPage: 1,
  itemsPerPage: 20,
  totalItems: 0,

  selectedStoreId: null,
  searchQuery: '',
  selectedProducts: new Set(),

  // Filter state
  filterType: 'newest',
  selectedBrandFilter: null,

  isModalOpen: false,
  selectedProductData: null,
  isAddProductModalOpen: false,

  loading: true,
  error: null,

  notification: {
    isOpen: false,
    variant: 'success',
    message: '',
  },

  // ============================================
  // SYNCHRONOUS ACTIONS (SETTERS)
  // ============================================

  setSelectedStoreId: (storeId) => set({ selectedStoreId: storeId, currentPage: 1 }),

  setSearchQuery: (query) => set({ searchQuery: query, currentPage: 1 }),

  setCurrentPage: (page) => set({ currentPage: page }),

  toggleProductSelection: (productId) =>
    set((state) => {
      const newSelected = new Set(state.selectedProducts);
      if (newSelected.has(productId)) {
        newSelected.delete(productId);
      } else {
        newSelected.add(productId);
      }
      return { selectedProducts: newSelected };
    }),

  selectAllProducts: () =>
    set((state) => ({
      selectedProducts: new Set(state.inventory.map((item) => item.productId)),
    })),

  clearSelection: () => set({ selectedProducts: new Set() }),

  setFilterType: (filterType) => set({ filterType, currentPage: 1 }),

  setSelectedBrandFilter: (brand) => set({ selectedBrandFilter: brand, currentPage: 1 }),

  clearFilter: () => set({ filterType: 'newest', selectedBrandFilter: null, currentPage: 1 }),

  openModal: (productData) =>
    set({
      isModalOpen: true,
      selectedProductData: productData,
    }),

  closeModal: () =>
    set({
      isModalOpen: false,
      selectedProductData: null,
    }),

  openAddProductModal: () => set({ isAddProductModalOpen: true }),

  closeAddProductModal: () => set({ isAddProductModalOpen: false }),

  showNotification: (variant, message) =>
    set({
      notification: { isOpen: true, variant, message },
    }),

  hideNotification: () =>
    set((state) => ({
      notification: { ...state.notification, isOpen: false },
    })),

  setLoading: (loading) => set({ loading }),

  setError: (error) => set({ error }),

  clearError: () => set({ error: null }),

  // ============================================
  // ASYNCHRONOUS ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load inventory data (ALL products for client-side filtering)
   * Fetches ALL inventory items at once
   */
  loadInventory: async (companyId, storeId, searchQuery) => {
    set({ loading: true, error: null });

    try {
      // Load ALL products at once for client-side filtering
      // Use a very large limit to get all products (10000 should be enough)
      const result = await repository.getInventory(
        companyId,
        storeId,
        1, // Always page 1
        10000, // Large limit to get all products
        searchQuery || undefined
      );

      if (!result.success) {
        set({
          error: result.error || 'Failed to load inventory',
          inventory: [],
          loading: false,
        });
        return;
      }

      // Set currency symbol and code from API response
      if (result.currency?.symbol || result.currency?.code) {
        set({
          currency: {
            symbol: result.currency?.symbol || get().currency.symbol,
            code: result.currency?.code || get().currency.code,
          },
        });
      }

      // Sort products by created_at DESC (newest first) on client-side
      // This ensures the order remains consistent even after editing products
      // createdAt is now a Date object (Local time) from InventoryItemModel
      const sortedInventory = (result.data || []).sort((a, b) => {
        // Handle missing dates - put items without dates at the end
        if (!a.createdAt && !b.createdAt) return 0;
        if (!a.createdAt) return 1;
        if (!b.createdAt) return -1;

        // Both dates exist - compare timestamps
        return b.createdAt.getTime() - a.createdAt.getTime(); // DESC order (newest first)
      });

      // Total items = all loaded products (we load all at once now)
      const totalItems = sortedInventory.length;
      console.log('✅ Loaded all products:', totalItems);

      set({ inventory: sortedInventory, totalItems, loading: false });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        inventory: [],
        loading: false,
      });
    }
  },

  /**
   * Update product
   * Updates product data with validation
   */
  updateProduct: async (productId, companyId, storeId, data) => {
    const state = get();

    if (!companyId || !storeId) {
      return {
        success: false,
        error: 'Company ID and Store ID are required',
      };
    }

    // 1. Validate product data using domain validator
    const validationErrors = InventoryValidator.validateProduct({
      productName: data.productName,
      sku: data.sku,
      costPrice: data.costPrice,
      sellingPrice: data.sellingPrice,
      currentStock: data.currentStock,
    });

    if (validationErrors.length > 0) {
      // Return first validation error
      return {
        success: false,
        error: validationErrors[0].message,
      };
    }

    // 2. Call repository to update product
    try {
      const result = await repository.updateProduct(productId, companyId, storeId, data);

      if (result.success) {
        // Refresh inventory after successful update
        await get().loadInventory(companyId, storeId, state.searchQuery);
      }

      return result;
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    }
  },

  /**
   * Import products from Excel
   * Calls RPC to import products (NO auto-refresh for batch processing)
   */
  importExcel: async (companyId, storeId, userId, products) => {
    try {
      const result = await repository.importExcel(companyId, storeId, userId, products);
      return result;
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    }
  },

  /**
   * Refresh inventory data
   * Reloads current inventory with existing filters
   */
  refresh: async () => {
    const state = get();
    // Note: companyId should be passed from component context
    // For now, we'll keep the same signature but components should provide it
    await get().loadInventory('', state.selectedStoreId, state.searchQuery);
  },
}));
