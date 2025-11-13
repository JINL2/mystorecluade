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

  // Actions - Group actions together for better performance
  const {
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
    loadOrders,
    createOrder,
    cancelOrder,
  } = useOrderStore((state) => ({
    setActiveTab: state.setActiveTab,
    setSearchQuery: state.setSearchQuery,
    toggleOrderSelection: state.toggleOrderSelection,
    selectAllOrders: state.selectAllOrders,
    clearSelection: state.clearSelection,
    setSelectedOrder: state.setSelectedOrder,
    showNotification: state.showNotification,
    hideNotification: state.hideNotification,
    setLoading: state.setLoading,
    setError: state.setError,
    clearError: state.clearError,
    loadOrders: state.loadOrders,
    createOrder: state.createOrder,
    cancelOrder: state.cancelOrder,
  }));

  // ============================================
  // AUTO-LOAD ORDERS
  // Load orders when companyId or storeId changes
  // ============================================

  useEffect(() => {
    if (companyId) {
      loadOrders(companyId, storeId);
    }
  }, [companyId, storeId, loadOrders]);

  // ============================================
  // REFRESH FUNCTION
  // Reload orders with current filters
  // ============================================

  const refresh = useCallback(() => {
    if (companyId) {
      loadOrders(companyId, storeId);
    }
  }, [companyId, storeId, loadOrders]);

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
