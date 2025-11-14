/**
 * useOrder Hook
 * Custom hook for order management
 * Following 2025 Best Practice: Uses Zustand provider with selector pattern
 */

import { useEffect, useCallback } from 'react';
import { useOrderStore } from '../providers/order_provider';

/**
 * useOrder Hook
 * Wrapper around useOrderStore with automatic data loading
 *
 * @param companyId - Company ID for filtering orders
 * @param storeId - Store ID for filtering orders (optional)
 * @returns Order state and actions
 */
export const useOrder = (companyId: string, storeId: string | null) => {
  // ============================================
  // SELECTOR PATTERN - Select only needed state
  // This prevents unnecessary re-renders
  // ============================================

  // Data state
  const orders = useOrderStore((state) => state.orders);
  const selectedOrder = useOrderStore((state) => state.selectedOrder);
  const currency = useOrderStore((state) => state.currency);

  // UI state
  const activeTab = useOrderStore((state) => state.activeTab);
  const searchQuery = useOrderStore((state) => state.searchQuery);
  const selectedOrderIds = useOrderStore((state) => state.selectedOrderIds);

  // Loading/Error state
  const loading = useOrderStore((state) => state.loading);
  const error = useOrderStore((state) => state.error);
  const isCreatingOrder = useOrderStore((state) => state.isCreatingOrder);
  const isCancellingOrder = useOrderStore((state) => state.isCancellingOrder);

  // Notification state
  const notification = useOrderStore((state) => state.notification);

  // Actions - Select individually to avoid creating new objects
  const setActiveTab = useOrderStore((state) => state.setActiveTab);
  const setSearchQuery = useOrderStore((state) => state.setSearchQuery);
  const toggleOrderSelection = useOrderStore((state) => state.toggleOrderSelection);
  const selectAllOrders = useOrderStore((state) => state.selectAllOrders);
  const clearSelection = useOrderStore((state) => state.clearSelection);
  const setSelectedOrder = useOrderStore((state) => state.setSelectedOrder);
  const showNotification = useOrderStore((state) => state.showNotification);
  const hideNotification = useOrderStore((state) => state.hideNotification);
  const setLoading = useOrderStore((state) => state.setLoading);
  const setError = useOrderStore((state) => state.setError);
  const clearError = useOrderStore((state) => state.clearError);
  const loadOrders = useOrderStore((state) => state.loadOrders);
  const createOrder = useOrderStore((state) => state.createOrder);
  const cancelOrder = useOrderStore((state) => state.cancelOrder);

  // ============================================
  // AUTO-LOAD ORDERS
  // Load orders when companyId or storeId changes
  // ============================================

  useEffect(() => {
    if (companyId) {
      loadOrders(companyId, storeId);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [companyId, storeId]); // Remove loadOrders from deps to prevent infinite loop

  // ============================================
  // REFRESH FUNCTION
  // Reload orders with current filters
  // ============================================

  const refresh = useCallback(() => {
    if (companyId) {
      loadOrders(companyId, storeId);
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [companyId, storeId]); // Remove loadOrders from deps

  // ============================================
  // FILTERED ORDERS
  // Apply search filter on client-side
  // ============================================

  const filteredOrders = searchQuery
    ? orders.filter(
        (order) =>
          order.orderNumber.toLowerCase().includes(searchQuery.toLowerCase()) ||
          order.supplierName.toLowerCase().includes(searchQuery.toLowerCase())
      )
    : orders;

  // ============================================
  // RETURN STATE AND ACTIONS
  // ============================================

  return {
    // Data state
    orders: filteredOrders,
    allOrders: orders, // Unfiltered orders
    selectedOrder,
    currency,

    // UI state
    activeTab,
    searchQuery,
    selectedOrderIds,

    // Loading/Error state
    loading,
    error,
    isCreatingOrder,
    isCancellingOrder,

    // Notification state
    notification,

    // Actions
    setActiveTab,
    setSearchQuery,
    toggleOrderSelection,
    selectAllOrders,
    clearSelection,
    setSelectedOrder,
    showNotification,
    hideNotification,
    setLoading,
    setError,
    clearError,
    createOrder,
    cancelOrder,
    refresh,
  };
};
