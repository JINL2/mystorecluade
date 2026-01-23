/**
 * useSaleInvoice Hook
 * Custom hook wrapper for sale invoice management
 * Following 2025 Best Practice - Optimized selectors for re-render prevention
 */

import { useSaleProductStore } from '../providers/sale_product_provider';

export const useSaleInvoice = () => {
  // ============================================
  // OPTIMIZED SELECTORS
  // ============================================
  // Each selector independently tracks changes
  // Components only re-render when their specific data changes

  // Cart State
  const cartItems = useSaleProductStore((state) => state.cartItems);
  const subtotal = useSaleProductStore((state) => state.subtotal);
  const totalCost = useSaleProductStore((state) => state.totalCost);

  // Discount State
  const discountType = useSaleProductStore((state) => state.discountType);
  const discountValue = useSaleProductStore((state) => state.discountValue);
  const discountAmount = useSaleProductStore((state) => state.discountAmount);
  const total = useSaleProductStore((state) => state.total);

  // Modal State
  const isPaymentModalOpen = useSaleProductStore(
    (state) => state.isPaymentModalOpen
  );
  const selectedCashLocationId = useSaleProductStore(
    (state) => state.selectedCashLocationId
  );
  const exchangeRates = useSaleProductStore((state) => state.exchangeRates);
  const cashLocations = useSaleProductStore((state) => state.cashLocations);

  // Loading State
  const loadingRates = useSaleProductStore((state) => state.loadingRates);
  const loadingLocations = useSaleProductStore(
    (state) => state.loadingLocations
  );
  const submitting = useSaleProductStore((state) => state.submitting);

  // Error State
  const error = useSaleProductStore((state) => state.error);

  // ============================================
  // ACTIONS
  // ============================================
  const addToCart = useSaleProductStore((state) => state.addToCart);
  const removeFromCart = useSaleProductStore((state) => state.removeFromCart);
  const updateQuantity = useSaleProductStore((state) => state.updateQuantity);
  const clearCart = useSaleProductStore((state) => state.clearCart);

  const setDiscountType = useSaleProductStore((state) => state.setDiscountType);
  const setDiscountValue = useSaleProductStore(
    (state) => state.setDiscountValue
  );

  const openPaymentModal = useSaleProductStore(
    (state) => state.openPaymentModal
  );
  const closePaymentModal = useSaleProductStore(
    (state) => state.closePaymentModal
  );
  const setSelectedCashLocation = useSaleProductStore(
    (state) => state.setSelectedCashLocation
  );

  const loadModalData = useSaleProductStore((state) => state.loadModalData);
  const submitInvoice = useSaleProductStore((state) => state.submitInvoice);

  const reset = useSaleProductStore((state) => state.reset);
  const setError = useSaleProductStore((state) => state.setError);

  // ============================================
  // RETURN API
  // ============================================
  return {
    // Cart State
    cartItems,
    subtotal,
    totalCost,
    itemCount: cartItems.length,

    // Discount State
    discountType,
    discountValue,
    discountAmount,
    total,

    // Modal State
    isPaymentModalOpen,
    selectedCashLocationId,
    exchangeRates,
    cashLocations,

    // Loading State
    loadingRates,
    loadingLocations,
    submitting,

    // Error State
    error,

    // Cart Actions
    addToCart,
    removeFromCart,
    updateQuantity,
    clearCart,

    // Discount Actions
    setDiscountType,
    setDiscountValue,

    // Modal Actions
    openPaymentModal,
    closePaymentModal,
    setSelectedCashLocation,

    // Async Actions
    loadModalData,
    submitInvoice,

    // Utility Actions
    reset,
    setError,
  };
};
