/**
 * useInventory Hook
 * Custom hook wrapper for inventory store
 *
 * Following 2025 Best Practice:
 * - Optimized selectors for re-render prevention
 * - Clean API for components
 * - Separation of state management and component logic
 */

import { useInventoryStore } from '../providers/inventory_provider';

export const useInventory = () => {
  // ============================================
  // OPTIMIZED SELECTORS
  // ============================================
  // Each selector independently tracks changes
  // Components only re-render when their specific data changes

  // Data State
  const inventory = useInventoryStore((state) => state.inventory);
  const currency = useInventoryStore((state) => state.currency);

  // Pagination State
  const currentPage = useInventoryStore((state) => state.currentPage);
  const itemsPerPage = useInventoryStore((state) => state.itemsPerPage);
  const totalItems = useInventoryStore((state) => state.totalItems);

  // UI State
  const selectedStoreId = useInventoryStore((state) => state.selectedStoreId);
  const searchQuery = useInventoryStore((state) => state.searchQuery);
  const selectedProducts = useInventoryStore((state) => state.selectedProducts);

  // Filter State
  const filterType = useInventoryStore((state) => state.filterType);
  const selectedBrandFilter = useInventoryStore((state) => state.selectedBrandFilter);
  const selectedCategoryFilter = useInventoryStore((state) => state.selectedCategoryFilter);

  // Modal State
  const isModalOpen = useInventoryStore((state) => state.isModalOpen);
  const selectedProductData = useInventoryStore((state) => state.selectedProductData);
  const isAddProductModalOpen = useInventoryStore((state) => state.isAddProductModalOpen);

  // Loading/Error State
  const loading = useInventoryStore((state) => state.loading);
  const error = useInventoryStore((state) => state.error);

  // Notification State
  const notification = useInventoryStore((state) => state.notification);

  // ============================================
  // ACTIONS
  // ============================================
  // Synchronous Actions
  const setSelectedStoreId = useInventoryStore((state) => state.setSelectedStoreId);
  const setSearchQuery = useInventoryStore((state) => state.setSearchQuery);
  const setCurrentPage = useInventoryStore((state) => state.setCurrentPage);
  const toggleProductSelection = useInventoryStore((state) => state.toggleProductSelection);
  const selectAllProducts = useInventoryStore((state) => state.selectAllProducts);
  const clearSelection = useInventoryStore((state) => state.clearSelection);

  const setFilterType = useInventoryStore((state) => state.setFilterType);
  const toggleBrandFilter = useInventoryStore((state) => state.toggleBrandFilter);
  const toggleCategoryFilter = useInventoryStore((state) => state.toggleCategoryFilter);
  const clearBrandFilter = useInventoryStore((state) => state.clearBrandFilter);
  const clearCategoryFilter = useInventoryStore((state) => state.clearCategoryFilter);
  const clearFilter = useInventoryStore((state) => state.clearFilter);

  const openModal = useInventoryStore((state) => state.openModal);
  const closeModal = useInventoryStore((state) => state.closeModal);

  const openAddProductModal = useInventoryStore((state) => state.openAddProductModal);
  const closeAddProductModal = useInventoryStore((state) => state.closeAddProductModal);

  const showNotification = useInventoryStore((state) => state.showNotification);
  const hideNotification = useInventoryStore((state) => state.hideNotification);

  const setLoading = useInventoryStore((state) => state.setLoading);
  const setError = useInventoryStore((state) => state.setError);
  const clearError = useInventoryStore((state) => state.clearError);

  // Asynchronous Actions
  const loadInventory = useInventoryStore((state) => state.loadInventory);
  const validateProductEdit = useInventoryStore((state) => state.validateProductEdit);
  const updateProduct = useInventoryStore((state) => state.updateProduct);
  const importExcel = useInventoryStore((state) => state.importExcel);
  const moveProduct = useInventoryStore((state) => state.moveProduct);
  const refresh = useInventoryStore((state) => state.refresh);

  // ============================================
  // RETURN API
  // ============================================
  return {
    // State
    inventory,
    currencySymbol: currency.symbol,
    currencyCode: currency.code,
    currentPage,
    itemsPerPage,
    totalItems,
    selectedStoreId,
    searchQuery,
    selectedProducts,
    filterType,
    selectedBrandFilter,
    selectedCategoryFilter,
    isModalOpen,
    selectedProductData,
    isAddProductModalOpen,
    loading,
    error,
    notification,

    // Actions
    setSelectedStoreId,
    setSearchQuery,
    setCurrentPage,
    toggleProductSelection,
    selectAllProducts,
    clearSelection,
    setFilterType,
    toggleBrandFilter,
    toggleCategoryFilter,
    clearBrandFilter,
    clearCategoryFilter,
    clearFilter,
    openModal,
    closeModal,
    openAddProductModal,
    closeAddProductModal,
    showNotification,
    hideNotification,
    setLoading,
    setError,
    clearError,
    loadInventory,
    validateProductEdit,
    updateProduct,
    importExcel,
    moveProduct,
    refresh,
  };
};
