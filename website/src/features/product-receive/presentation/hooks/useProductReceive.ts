/**
 * useProductReceive Hook
 * Thin wrapper for product receive Zustand store
 *
 * Following 2025 Best Practice:
 * - Hook is just a selector wrapper
 * - All state and logic in Zustand provider
 * - Clean separation of concerns
 */

import { useProductReceiveStore } from '../providers/product_receive_provider';
import { useCallback, useEffect } from 'react';

export const useProductReceive = (companyId: string, storeId: string | null) => {
  // Select state from Zustand store
  const orders = useProductReceiveStore((state) => state.orders);
  const selectedOrder = useProductReceiveStore((state) => state.selectedOrder);
  const orderProducts = useProductReceiveStore((state) => state.orderProducts);
  const loadingOrders = useProductReceiveStore((state) => state.loadingOrders);

  const scannedItems = useProductReceiveStore((state) => state.scannedItems);
  const skuInput = useProductReceiveStore((state) => state.skuInput);
  const autocompleteResults = useProductReceiveStore((state) => state.autocompleteResults);
  const showAutocomplete = useProductReceiveStore((state) => state.showAutocomplete);

  const productSearchTerm = useProductReceiveStore((state) => state.productSearchTerm);
  const filteredProducts = useProductReceiveStore((state) => state.filteredProducts);

  const submitting = useProductReceiveStore((state) => state.submitting);
  const error = useProductReceiveStore((state) => state.error);

  // Select actions from Zustand store
  const selectOrder = useProductReceiveStore((state) => state.selectOrder);
  const loadOrders = useProductReceiveStore((state) => state.loadOrders);
  const handleSkuInput = useProductReceiveStore((state) => state.handleSkuInput);
  const setShowAutocomplete = useProductReceiveStore((state) => state.setShowAutocomplete);
  const setProductSearchTerm = useProductReceiveStore((state) => state.setProductSearchTerm);
  const addScannedItem = useProductReceiveStore((state) => state.addScannedItem);
  const updateScannedQuantity = useProductReceiveStore((state) => state.updateScannedQuantity);
  const removeScannedItem = useProductReceiveStore((state) => state.removeScannedItem);
  const clearAllScanned = useProductReceiveStore((state) => state.clearAllScanned);
  const submitReceiveAction = useProductReceiveStore((state) => state.submitReceive);

  // Load orders when company changes
  useEffect(() => {
    loadOrders(companyId);
  }, [companyId, loadOrders]);

  // Wrapper for submitReceive to inject companyId, storeId, and userId
  const submitReceive = useCallback(async () => {
    if (!companyId || !storeId) {
      return { success: false, error: 'Company or Store is not selected' };
    }

    // Get user ID from repository
    const { ProductReceiveRepositoryImpl } = await import('../../data/repositories/ProductReceiveRepositoryImpl');
    const repository = new ProductReceiveRepositoryImpl();
    const userIdResult = await repository.getCurrentUserId();

    if (!userIdResult.success || !userIdResult.data) {
      return { success: false, error: userIdResult.error || 'Failed to get user ID' };
    }

    const userId = userIdResult.data;

    return await submitReceiveAction(companyId, storeId, userId);
  }, [companyId, storeId, submitReceiveAction]);

  // Calculate progress
  const totalScannedCount = Array.from(scannedItems.values()).reduce(
    (sum, item) => sum + item.count,
    0
  );

  const scannedItemsArray = Array.from(scannedItems.values());

  return {
    // Orders
    orders,
    selectedOrder,
    selectOrder,
    loadingOrders,

    // Products
    orderProducts,
    filteredProducts,
    productSearchTerm,
    setProductSearchTerm,

    // Scanning
    scannedItems: scannedItemsArray,
    totalScannedCount,
    skuInput,
    handleSkuInput,
    autocompleteResults,
    showAutocomplete,
    setShowAutocomplete,
    addScannedItem,
    updateScannedQuantity,
    removeScannedItem,
    clearAllScanned,

    // Submission
    submitReceive,
    submitting,

    // Error
    error,
  };
};
