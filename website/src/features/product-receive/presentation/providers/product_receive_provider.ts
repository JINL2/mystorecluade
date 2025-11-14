/**
 * Product Receive Provider
 * Zustand store for product receive feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import type { ProductReceiveState } from './states/product_receive_state';
import { ProductReceiveRepositoryImpl } from '../../data/repositories/ProductReceiveRepositoryImpl';
import { ReceiveValidator } from '../../domain/validators/ReceiveValidator';
import { ScannedItemEntity } from '../../domain/entities/ScannedItem';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new ProductReceiveRepositoryImpl();

/**
 * Product Receive Store
 * Zustand store for product receive feature state
 */
export const useProductReceiveStore = create<ProductReceiveState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================

  // Orders
  orders: [],
  selectedOrder: null,
  orderProducts: [],
  loadingOrders: false,

  // Scanning
  scannedItems: new Map(),
  skuInput: '',
  autocompleteResults: [],
  showAutocomplete: false,

  // Search/Filter
  productSearchTerm: '',
  filteredProducts: [],

  // UI State
  submitting: false,
  error: null,

  // ============================================
  // SYNCHRONOUS ACTIONS (SETTERS)
  // ============================================

  setSkuInput: (value) => set({ skuInput: value }),

  setShowAutocomplete: (show) => set({ showAutocomplete: show }),

  setProductSearchTerm: (term) => {
    set({ productSearchTerm: term });

    // Filter products based on search term
    const state = get();
    if (!term.trim()) {
      set({ filteredProducts: state.orderProducts });
      return;
    }

    const searchLower = term.toLowerCase();
    const filtered = state.orderProducts.filter(
      (p) =>
        p.sku.toLowerCase().includes(searchLower) ||
        p.productName.toLowerCase().includes(searchLower)
    );

    set({ filteredProducts: filtered });
  },

  setError: (error) => set({ error }),

  clearError: () => set({ error: null }),

  // ============================================
  // ASYNCHRONOUS ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load orders for company
   * Fetches orders and auto-selects first order if available
   */
  loadOrders: async (companyId) => {
    if (!companyId) {
      set({ orders: [], selectedOrder: null, orderProducts: [] });
      return;
    }

    set({ loadingOrders: true, error: null });

    try {
      const result = await repository.getOrders(companyId);

      if (!result.success) {
        set({
          error: result.error || 'Failed to load orders',
          orders: [],
          selectedOrder: null,
          orderProducts: [],
          loadingOrders: false,
        });
        return;
      }

      const newOrders = result.data || [];
      set({ orders: newOrders });

      // Re-select current order with updated data, or auto-select first order
      const state = get();
      if (newOrders.length > 0) {
        if (state.selectedOrder) {
          // Find and re-select the current order with updated data
          const updatedOrder = newOrders.find((o) => o.orderId === state.selectedOrder?.orderId);
          if (updatedOrder) {
            set({
              selectedOrder: updatedOrder,
              orderProducts: updatedOrder.items || [],
              filteredProducts: updatedOrder.items || [],
            });
          } else {
            // If current order no longer exists, select first order
            set({
              selectedOrder: newOrders[0],
              orderProducts: newOrders[0].items || [],
              filteredProducts: newOrders[0].items || [],
            });
          }
        } else {
          // No order selected yet, auto-select first order
          set({
            selectedOrder: newOrders[0],
            orderProducts: newOrders[0].items || [],
            filteredProducts: newOrders[0].items || [],
          });
        }

        // Clear scanned items when switching orders
        set({ scannedItems: new Map(), skuInput: '', productSearchTerm: '' });
      }
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        orders: [],
        selectedOrder: null,
        orderProducts: [],
      });
    } finally {
      set({ loadingOrders: false });
    }
  },

  /**
   * Select an order
   * Updates selected order and resets scanned items
   */
  selectOrder: (order) => {
    set({
      selectedOrder: order,
      orderProducts: order.items || [],
      filteredProducts: order.items || [],
      scannedItems: new Map(),
      skuInput: '',
      productSearchTerm: '',
      error: null,
    });
  },

  /**
   * Handle SKU input for autocomplete
   * Filters products and shows autocomplete results
   */
  handleSkuInput: (value) => {
    set({ skuInput: value });

    const searchTerm = value.trim().toLowerCase();

    if (!searchTerm || searchTerm.length < 1) {
      set({ showAutocomplete: false, autocompleteResults: [] });
      return;
    }

    const state = get();

    // Filter products based on SKU or product name
    let filtered = state.orderProducts.filter(
      (p) =>
        p.sku.toLowerCase().includes(searchTerm) ||
        p.productName.toLowerCase().includes(searchTerm)
    );

    // Sort results to prioritize SKU matches at the beginning
    filtered.sort((a, b) => {
      const aSkuMatch = a.sku.toLowerCase().startsWith(searchTerm);
      const bSkuMatch = b.sku.toLowerCase().startsWith(searchTerm);

      if (aSkuMatch && !bSkuMatch) return -1;
      if (!aSkuMatch && bSkuMatch) return 1;

      // Then sort by SKU alphabetically
      return a.sku.localeCompare(b.sku);
    });

    // Limit to top 10 results
    filtered = filtered.slice(0, 10);

    set({
      autocompleteResults: filtered,
      showAutocomplete: filtered.length > 0,
    });
  },

  /**
   * Add scanned item
   * Adds or increments scanned item count
   */
  addScannedItem: (product) => {
    const state = get();
    const newMap = new Map(state.scannedItems);
    const existing = newMap.get(product.sku);

    if (existing) {
      existing.incrementCount();
    } else {
      newMap.set(
        product.sku,
        new ScannedItemEntity(
          product.sku,
          product.productId,
          product.productName,
          1
        )
      );
    }

    set({
      scannedItems: newMap,
      skuInput: '',
      showAutocomplete: false,
      error: null,
    });
  },

  /**
   * Update scanned item quantity
   * Updates quantity or removes item if quantity is 0
   */
  updateScannedQuantity: (sku, quantity) => {
    const state = get();
    const newMap = new Map(state.scannedItems);
    const item = newMap.get(sku);

    if (item && quantity > 0) {
      item.setCount(quantity);
    } else if (item && quantity === 0) {
      newMap.delete(sku);
    }

    set({ scannedItems: newMap });
  },

  /**
   * Remove scanned item
   * Removes item from scanned items list
   */
  removeScannedItem: (sku) => {
    const state = get();
    const newMap = new Map(state.scannedItems);
    newMap.delete(sku);

    set({ scannedItems: newMap });
  },

  /**
   * Clear all scanned items
   * Resets scanned items and input
   */
  clearAllScanned: () => {
    set({
      scannedItems: new Map(),
      skuInput: '',
      error: null,
    });
  },

  /**
   * Submit receive
   * Validates and submits received products
   */
  submitReceive: async (companyId, storeId, userId) => {
    const state = get();

    // Validate submission using Validator
    const scannedItemsArray = Array.from(state.scannedItems.values());
    const validationErrors = ReceiveValidator.validateSubmission(
      scannedItemsArray,
      state.selectedOrder,
      state.orderProducts
    );

    if (validationErrors.length > 0) {
      const errorMsg = validationErrors[0].message;
      set({ error: errorMsg });
      return { success: false, error: errorMsg };
    }

    if (!companyId || !storeId) {
      const errorMsg = 'Company or Store is not selected';
      set({ error: errorMsg });
      return { success: false, error: errorMsg };
    }

    if (!state.selectedOrder) {
      const errorMsg = 'No order selected';
      set({ error: errorMsg });
      return { success: false, error: errorMsg };
    }

    set({ submitting: true, error: null });

    try {
      // Build items array
      const items = Array.from(state.scannedItems.values()).map((item) => ({
        productId: item.productId,
        quantityReceived: item.count,
      }));

      const result = await repository.submitReceive(
        companyId,
        storeId,
        state.selectedOrder.orderId,
        userId,
        items,
        null
      );

      if (!result.success) {
        const errorMsg = result.error || 'Failed to submit receive';
        set({ error: errorMsg, submitting: false });
        return { success: false, error: errorMsg };
      }

      // Clear scanned items on success
      get().clearAllScanned();

      // Reload orders to get updated data
      await get().loadOrders(companyId);

      return {
        success: true,
        data: result.data,
      };
    } catch (err) {
      const errorMsg = err instanceof Error ? err.message : 'An unexpected error occurred';
      set({ error: errorMsg, submitting: false });
      return { success: false, error: errorMsg };
    } finally {
      set({ submitting: false });
    }
  },
}));
