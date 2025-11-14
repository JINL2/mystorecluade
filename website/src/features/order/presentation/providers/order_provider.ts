/**
 * Order Provider
 * Zustand store for order feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import type { OrderState } from './states/order_state';
import { OrderRepositoryImpl } from '../../data/repositories/OrderRepositoryImpl';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new OrderRepositoryImpl();

/**
 * Order Store
 * Zustand store for order feature state
 */
export const useOrderStore = create<OrderState>((set) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  orders: [],
  selectedOrder: null,
  currency: {
    symbol: '$',
    code: 'USD',
  },

  activeTab: 'new-order',
  searchQuery: '',
  selectedOrderIds: new Set(),

  loading: true,
  error: null,
  isCreatingOrder: false,
  isCancellingOrder: false,

  notification: {
    isOpen: false,
    variant: 'success',
    message: '',
  },

  // ============================================
  // SYNCHRONOUS ACTIONS (SETTERS)
  // ============================================

  setActiveTab: (tab) => set({ activeTab: tab }),

  setSearchQuery: (query) => set({ searchQuery: query }),

  toggleOrderSelection: (orderId) =>
    set((state) => {
      const newSelected = new Set(state.selectedOrderIds);
      if (newSelected.has(orderId)) {
        newSelected.delete(orderId);
      } else {
        newSelected.add(orderId);
      }
      return { selectedOrderIds: newSelected };
    }),

  selectAllOrders: () =>
    set((state) => ({
      selectedOrderIds: new Set(state.orders.map((order) => order.orderId)),
    })),

  clearSelection: () => set({ selectedOrderIds: new Set() }),

  setSelectedOrder: (order) => set({ selectedOrder: order }),

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
   * Load orders data
   * Fetches orders and updates state
   */
  loadOrders: async (companyId, storeId) => {
    set({ loading: true, error: null });

    try {
      const result = await repository.getOrders(companyId, storeId);

      if (!result.success) {
        set({
          error: result.error || 'Failed to load orders',
          orders: [],
          loading: false,
        });
        return;
      }

      // Sort orders by order date DESC (newest first)
      const sortedOrders = (result.data || []).sort((a, b) => {
        const dateA = new Date(a.orderDate);
        const dateB = new Date(b.orderDate);
        return dateB.getTime() - dateA.getTime();
      });

      set({ orders: sortedOrders, loading: false });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        orders: [],
        loading: false,
      });
    }
  },

  /**
   * Create new order
   * Validates and creates order via repository
   */
  createOrder: async (_params) => {
    set({ isCreatingOrder: true, error: null });

    try {
      // TODO: Implement order creation via repository
      // const result = await repository.createOrder(params);

      // For now, return not implemented
      set({ isCreatingOrder: false });
      return {
        success: false,
        error: 'Order creation not yet implemented',
      };
    } catch (err) {
      set({ isCreatingOrder: false });
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    }
  },

  /**
   * Cancel order
   * Cancels an existing order
   */
  cancelOrder: async (_orderId) => {
    set({ isCancellingOrder: true, error: null });

    try {
      // TODO: Implement order cancellation via repository
      // const result = await repository.cancelOrder(orderId);

      // For now, return not implemented
      set({ isCancellingOrder: false });
      return {
        success: false,
        error: 'Order cancellation not yet implemented',
      };
    } catch (err) {
      set({ isCancellingOrder: false });
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    }
  },

  /**
   * Refresh orders data
   * Reloads current orders
   */
  refresh: async () => {
    // Note: companyId and storeId should be passed from component context
    // For now, we keep the same signature but components should provide it
    // This will be handled by the useOrder hook
  },
}));
