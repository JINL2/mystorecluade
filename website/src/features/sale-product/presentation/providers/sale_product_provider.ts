/**
 * Sale Product Provider
 * Zustand store for sale-product feature (2025 Best Practice)
 */

import { create } from 'zustand';
import { SaleProductState } from './states/sale_product_state';
import { SaleProductRepositoryImpl } from '../../data/repositories/SaleProductRepositoryImpl';
import { SaleInvoiceValidator } from '../../domain/validators/SaleInvoiceValidator';
import { CartItem } from '../../domain/entities/CartItem';
import { Product } from '../../domain/entities/Product';
import { SaleInvoice } from '../../domain/entities/SaleInvoice';

const repository = new SaleProductRepositoryImpl();

/**
 * Calculate totals based on cart items and discount
 */
function calculateTotals(
  items: CartItem[],
  discountType: 'amount' | 'percent',
  discountValue: number
) {
  const subtotal = items.reduce((sum, item) => sum + item.totalPrice, 0);
  const totalCost = items.reduce((sum, item) => sum + item.totalCost, 0);

  const discountAmount =
    discountType === 'percent'
      ? (subtotal * discountValue) / 100
      : discountValue;

  const total = Math.max(0, subtotal - discountAmount);

  return { subtotal, totalCost, discountAmount, total };
}

export const useSaleProductStore = create<SaleProductState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  cartItems: [],
  subtotal: 0,
  totalCost: 0,
  discountType: 'amount',
  discountValue: 0,
  discountAmount: 0,
  total: 0,
  isPaymentModalOpen: false,
  selectedCashLocationId: '',
  exchangeRates: [],
  cashLocations: [],
  loadingRates: false,
  loadingLocations: false,
  submitting: false,
  error: null,

  // ============================================
  // CART MANAGEMENT ACTIONS
  // ============================================

  addToCart: (product: Product) => {
    set((state) => {
      const existing = state.cartItems.find(
        (item) => item.productId === product.id
      );

      let newItems: CartItem[];

      if (existing) {
        // Increment existing item quantity
        newItems = state.cartItems.map((item) =>
          item.productId === product.id ? item.incrementQuantity() : item
        );
      } else {
        // Add new item to cart
        const newItem = CartItem.fromProduct(
          product.id,
          product.sku,
          product.name,
          product.sellingPrice,
          product.costPrice,
          1
        );
        newItems = [...state.cartItems, newItem];
      }

      const totals = calculateTotals(
        newItems,
        state.discountType,
        state.discountValue
      );

      return {
        cartItems: newItems,
        ...totals,
      };
    });
  },

  removeFromCart: (productId: string) => {
    set((state) => {
      const newItems = state.cartItems.filter(
        (item) => item.productId !== productId
      );

      const totals = calculateTotals(
        newItems,
        state.discountType,
        state.discountValue
      );

      return {
        cartItems: newItems,
        ...totals,
      };
    });
  },

  updateQuantity: (productId: string, quantity: number) => {
    set((state) => {
      const newItems: CartItem[] = [];

      for (const item of state.cartItems) {
        if (item.productId === productId) {
          const updated = item.updateQuantity(quantity);
          if (updated) {
            newItems.push(updated);
          }
          // If updated is null, item is removed (quantity <= 0)
        } else {
          newItems.push(item);
        }
      }

      const totals = calculateTotals(
        newItems,
        state.discountType,
        state.discountValue
      );

      return {
        cartItems: newItems,
        ...totals,
      };
    });
  },

  clearCart: () => {
    set({
      cartItems: [],
      subtotal: 0,
      totalCost: 0,
      discountAmount: 0,
      total: 0,
    });
  },

  // ============================================
  // DISCOUNT MANAGEMENT ACTIONS
  // ============================================

  setDiscountType: (type) => {
    set((state) => {
      const totals = calculateTotals(state.cartItems, type, state.discountValue);
      return {
        discountType: type,
        ...totals,
      };
    });
  },

  setDiscountValue: (value) => {
    set((state) => {
      const totals = calculateTotals(state.cartItems, state.discountType, value);
      return {
        discountValue: value,
        ...totals,
      };
    });
  },

  // ============================================
  // MODAL MANAGEMENT ACTIONS
  // ============================================

  openPaymentModal: () => {
    set({ isPaymentModalOpen: true });
  },

  closePaymentModal: () => {
    set({ isPaymentModalOpen: false });
  },

  setSelectedCashLocation: (id) => {
    set({ selectedCashLocationId: id });
  },

  // ============================================
  // ASYNC ACTIONS
  // ============================================

  loadModalData: async (companyId: string, storeId: string) => {
    set({ loadingRates: true, loadingLocations: true, error: null });

    try {
      const [rates, locations] = await Promise.all([
        repository.getExchangeRates(companyId),
        repository.getCashLocations(companyId, storeId),
      ]);

      set({
        exchangeRates: rates,
        cashLocations: locations,
        loadingRates: false,
        loadingLocations: false,
      });
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to load modal data';
      console.error('Failed to load modal data:', error);
      set({
        error: errorMessage,
        loadingRates: false,
        loadingLocations: false,
      });
    }
  },

  submitInvoice: async (companyId: string, storeId: string, userId: string) => {
    const state = get();

    console.log('📋 [submitInvoice] Starting invoice submission', {
      companyId,
      storeId,
      userId,
      selectedCashLocationId: state.selectedCashLocationId,
      cartItemsCount: state.cartItems.length,
      cashLocationsCount: state.cashLocations.length,
    });

    // Find selected cash location
    const selectedLocation = state.cashLocations.find(
      (loc) => loc.id === state.selectedCashLocationId
    );

    if (!selectedLocation) {
      console.error('❌ [submitInvoice] Cash location not found', {
        selectedId: state.selectedCashLocationId,
        availableLocations: state.cashLocations.map(l => ({ id: l.id, name: l.name })),
      });
      set({ error: 'Cash location not found' });
      return { success: false, error: 'Cash location not found' };
    }

    console.log('✅ [submitInvoice] Cash location found', {
      id: selectedLocation.id,
      name: selectedLocation.name,
      type: selectedLocation.type,
    });

    // Create invoice entity
    const invoice = SaleInvoice.create({
      items: state.cartItems,
      discountType: state.discountType,
      discountValue: state.discountValue,
      cashLocation: selectedLocation,
      companyId,
      storeId,
      userId,
    });

    console.log('📦 [submitInvoice] Invoice entity created', {
      itemsCount: invoice.items.length,
      subtotal: invoice.subtotal,
      discountAmount: invoice.discountAmount,
      total: invoice.total,
      paymentMethod: invoice.cashLocation.type,
      cashLocationId: invoice.cashLocation.id,
    });

    // Validate invoice
    const errors = SaleInvoiceValidator.validateInvoice(invoice);
    if (errors.length > 0) {
      const errorMessage = errors.map((e) => e.message).join(', ');
      console.error('❌ [submitInvoice] Validation failed', { errors });
      set({ error: errorMessage });
      return { success: false, error: errorMessage };
    }

    console.log('✅ [submitInvoice] Validation passed');

    // Submit invoice
    set({ submitting: true, error: null });

    try {
      console.log('🚀 [submitInvoice] Calling repository.submitSaleInvoice');
      const result = await repository.submitSaleInvoice(invoice);

      if (result.success) {
        console.log('✅ [submitInvoice] Invoice submitted successfully', {
          invoiceId: result.invoiceId,
        });
        // Clear cart and reset discount, but keep modal open for success message
        set({
          cartItems: [],
          subtotal: 0,
          totalCost: 0,
          discountType: 'amount',
          discountValue: 0,
          discountAmount: 0,
          total: 0,
          selectedCashLocationId: '',
          error: null,
          submitting: false,
        });
      } else {
        console.error('❌ [submitInvoice] Invoice submission failed', {
          error: result.error,
        });
        set({ error: result.error || 'Failed to submit invoice', submitting: false });
      }

      return result;
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : 'Failed to submit invoice';
      console.error('❌ [submitInvoice] Exception during submission', {
        error,
        errorMessage,
      });
      set({ error: errorMessage, submitting: false });
      return { success: false, error: errorMessage };
    }
  },

  // ============================================
  // UTILITY ACTIONS
  // ============================================

  reset: () => {
    set({
      cartItems: [],
      subtotal: 0,
      totalCost: 0,
      discountType: 'amount',
      discountValue: 0,
      discountAmount: 0,
      total: 0,
      isPaymentModalOpen: false,
      selectedCashLocationId: '',
      error: null,
    });
  },

  setError: (error) => {
    set({ error });
  },
}));
