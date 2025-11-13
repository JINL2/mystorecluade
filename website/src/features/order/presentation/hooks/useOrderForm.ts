/**
 * useOrderForm Hook
 * Custom hook for order form management
 * Following 2025 Best Practice: Uses Zustand provider with selector pattern
 */

import { useEffect } from 'react';
import { useOrderFormStore } from '../providers/order_form_provider';

/**
 * useOrderForm Hook
 * Wrapper around useOrderFormStore with automatic initialization
 *
 * @returns Order form state and actions
 */
export const useOrderForm = () => {
  // ============================================
  // SELECTOR PATTERN - Select only needed state
  // ============================================

  // Form data state
  const orderDate = useOrderFormStore((state) => state.orderDate);
  const notes = useOrderFormStore((state) => state.notes);
  const supplierTab = useOrderFormStore((state) => state.supplierTab);
  const selectedSupplier = useOrderFormStore((state) => state.selectedSupplier);
  const supplierInfo = useOrderFormStore((state) => state.supplierInfo);
  const orderItems = useOrderFormStore((state) => state.orderItems);

  // UI state
  const isDropdownOpen = useOrderFormStore((state) => state.isDropdownOpen);
  const searchTerm = useOrderFormStore((state) => state.searchTerm);
  const showSuggestions = useOrderFormStore((state) => state.showSuggestions);
  const searchResults = useOrderFormStore((state) => state.searchResults);

  // Loading/Error state
  const isCreating = useOrderFormStore((state) => state.isCreating);
  const error = useOrderFormStore((state) => state.error);
  const validationErrors = useOrderFormStore((state) => state.validationErrors);

  // Actions - Group actions together
  const {
    setOrderDate,
    setNotes,
    setSupplierTab,
    setSelectedSupplier,
    setSupplierInfo,
    setOrderItems,
    setIsDropdownOpen,
    setSearchTerm,
    setShowSuggestions,
    setSearchResults,
    setIsCreating,
    setError,
    setValidationErrors,
    clearErrors,
    addOrderItem,
    updateOrderItemQuantity,
    updateOrderItemPrice,
    removeOrderItem,
    searchProducts,
    clearSearch,
    validateForm,
    resetForm,
    getSummary,
  } = useOrderFormStore((state) => ({
    setOrderDate: state.setOrderDate,
    setNotes: state.setNotes,
    setSupplierTab: state.setSupplierTab,
    setSelectedSupplier: state.setSelectedSupplier,
    setSupplierInfo: state.setSupplierInfo,
    setOrderItems: state.setOrderItems,
    setIsDropdownOpen: state.setIsDropdownOpen,
    setSearchTerm: state.setSearchTerm,
    setShowSuggestions: state.setShowSuggestions,
    setSearchResults: state.setSearchResults,
    setIsCreating: state.setIsCreating,
    setError: state.setError,
    setValidationErrors: state.setValidationErrors,
    clearErrors: state.clearErrors,
    addOrderItem: state.addOrderItem,
    updateOrderItemQuantity: state.updateOrderItemQuantity,
    updateOrderItemPrice: state.updateOrderItemPrice,
    removeOrderItem: state.removeOrderItem,
    searchProducts: state.searchProducts,
    clearSearch: state.clearSearch,
    validateForm: state.validateForm,
    resetForm: state.resetForm,
    getSummary: state.getSummary,
  }));

  // ============================================
  // AUTO-INITIALIZE FORM
  // Initialize order date to today on mount
  // ============================================

  useEffect(() => {
    // Only initialize if order date is empty
    if (!orderDate) {
      const today = new Date();
      const year = today.getFullYear();
      const month = String(today.getMonth() + 1).padStart(2, '0');
      const day = String(today.getDate()).padStart(2, '0');
      setOrderDate(`${year}-${month}-${day}`);
    }
  }, []); // Run only once on mount

  // ============================================
  // COMPUTED VALUES
  // ============================================

  const summary = getSummary();
  const isValid = orderItems.length > 0 && validateForm();

  // ============================================
  // RETURN STATE AND ACTIONS
  // ============================================

  return {
    // Form data state
    orderDate,
    notes,
    supplierTab,
    selectedSupplier,
    supplierInfo,
    orderItems,

    // UI state
    isDropdownOpen,
    searchTerm,
    showSuggestions,
    searchResults,

    // Loading/Error state
    isCreating,
    error,
    validationErrors,

    // Computed values
    summary,
    isValid,

    // Actions
    setOrderDate,
    setNotes,
    setSupplierTab,
    setSelectedSupplier,
    setSupplierInfo,
    setOrderItems,
    setIsDropdownOpen,
    setSearchTerm,
    setShowSuggestions,
    setSearchResults,
    setIsCreating,
    setError,
    setValidationErrors,
    clearErrors,
    addOrderItem,
    updateOrderItemQuantity,
    updateOrderItemPrice,
    removeOrderItem,
    searchProducts,
    clearSearch,
    validateForm,
    resetForm,
  };
};
