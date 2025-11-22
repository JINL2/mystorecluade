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
    symbol: '₫',
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
  selectedBrandFilter: new Set<string>(), // Multi-select
  selectedCategoryFilter: new Set<string>(), // Multi-select

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

  toggleBrandFilter: (brand) =>
    set((state) => {
      const newBrands = new Set(state.selectedBrandFilter);
      if (newBrands.has(brand)) {
        newBrands.delete(brand);
      } else {
        newBrands.add(brand);
      }
      return { selectedBrandFilter: newBrands, currentPage: 1 };
    }),

  toggleCategoryFilter: (category) =>
    set((state) => {
      const newCategories = new Set(state.selectedCategoryFilter);
      if (newCategories.has(category)) {
        newCategories.delete(category);
      } else {
        newCategories.add(category);
      }
      return { selectedCategoryFilter: newCategories, currentPage: 1 };
    }),

  clearBrandFilter: () => set({ selectedBrandFilter: new Set<string>(), currentPage: 1 }),

  clearCategoryFilter: () => set({ selectedCategoryFilter: new Set<string>(), currentPage: 1 }),

  clearFilter: () => set({
    filterType: 'newest',
    selectedBrandFilter: new Set<string>(),
    selectedCategoryFilter: new Set<string>(),
    currentPage: 1
  }),

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
   * Load base currency from database
   * Fetches company's base currency configuration
   */
  loadBaseCurrency: async (companyId) => {
    try {
      const currency = await repository.getBaseCurrency(companyId);
      set({ currency });
    } catch (err) {
      console.error('Failed to load base currency:', err);
      // Keep fallback currency (VND) if loading fails
    }
  },

  /**
   * Load inventory data with server-side pagination
   * Fetches products for the current page
   */
  loadInventory: async (companyId, storeId, searchQuery) => {
    set({ loading: true, error: null });

    try {
      const state = get();
      const currentPage = state.currentPage;
      const itemsPerPage = state.itemsPerPage;

      // Load products for current page with server-side pagination
      const result = await repository.getInventory(
        companyId,
        storeId,
        currentPage,
        itemsPerPage,
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

      // Products are already sorted by server (created_at DESC)
      // Use server-side pagination total count
      const totalItems = result.pagination?.total_count || result.pagination?.total || 0;

      set({
        inventory: result.data || [],
        totalItems,
        loading: false
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        inventory: [],
        loading: false,
      });
    }
  },

  /**
   * Validate product edit
   * Validates product changes before update (only changed fields)
   */
  validateProductEdit: async (productId, companyId, originalProductName, newProductName, originalSku, newSku) => {
    try {
      return await repository.validateProductEdit(
        productId,
        companyId,
        originalProductName,
        newProductName,
        originalSku,
        newSku
      );
    } catch (err) {
      return {
        success: false,
        error: {
          code: 'VALIDATION_ERROR',
          message: err instanceof Error ? err.message : 'Validation failed',
        },
      };
    }
  },

  /**
   * Update product
   * Updates product data with validation
   */
  updateProduct: async (productId, companyId, storeId, data, originalData) => {
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

    // 2. Call repository to update product (pass originalData for change detection)
    try {
      const result = await repository.updateProduct(productId, companyId, storeId, data, originalData);

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
   * Move product between stores
   * Calls RPC to move product and refreshes inventory
   */
  moveProduct: async (
    companyId,
    fromStoreId,
    toStoreId,
    productId,
    quantity,
    notes,
    time,
    updatedBy
  ) => {
    try {
      const result = await repository.moveProduct(
        companyId,
        fromStoreId,
        toStoreId,
        productId,
        quantity,
        notes,
        time,
        updatedBy
      );

      if (result.success) {
        // Refresh inventory after successful move
        await get().loadInventory(companyId, fromStoreId, get().searchQuery);
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
