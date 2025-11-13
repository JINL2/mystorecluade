/**
 * Order Form Provider
 * Zustand store for order form state management
 *
 * Following 2025 Best Practice:
 * - Separate store for complex forms
 * - Form state centralization
 * - Validation integration
 */

import { create } from 'zustand';
import type { OrderFormState, OrderFormItem } from './states/order_form_state';
import { OrderValidator } from '../../domain/validators/OrderValidator';
import type { OrderItem } from '../../domain/entities/Order';

/**
 * Initial supplier info state
 */
const initialSupplierInfo = {
  name: '',
  contact: '',
  phone: '',
  email: '',
  address: '',
  bank_account: '',
  memo: '',
};

/**
 * Order Form Store
 * Zustand store for order form state
 */
export const useOrderFormStore = create<OrderFormState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  orderDate: '',
  notes: '',
  supplierTab: 'counter-party',
  selectedSupplier: null,
  supplierInfo: initialSupplierInfo,
  orderItems: [],

  isDropdownOpen: false,
  searchTerm: '',
  showSuggestions: false,
  searchResults: [],

  isCreating: false,
  error: null,
  validationErrors: {},

  // ============================================
  // SYNCHRONOUS ACTIONS (SETTERS)
  // ============================================

  setOrderDate: (date) => set({ orderDate: date }),

  setNotes: (notes) => set({ notes }),

  setSupplierTab: (tab) => {
    // Reset supplier data when switching tabs
    if (tab === 'others') {
      set({ supplierTab: tab, selectedSupplier: null });
    } else {
      set({ supplierTab: tab, supplierInfo: initialSupplierInfo });
    }
  },

  setSelectedSupplier: (supplier) => set({ selectedSupplier: supplier }),

  setSupplierInfo: (info) =>
    set((state) => ({
      supplierInfo: { ...state.supplierInfo, ...info },
    })),

  setOrderItems: (items) => set({ orderItems: items }),

  setIsDropdownOpen: (isOpen) => set({ isDropdownOpen: isOpen }),

  setSearchTerm: (term) => set({ searchTerm: term }),

  setShowSuggestions: (show) => set({ showSuggestions: show }),

  setSearchResults: (results) => set({ searchResults: results }),

  setIsCreating: (isCreating) => set({ isCreating }),

  setError: (error) => set({ error }),

  setValidationErrors: (errors) => set({ validationErrors: errors }),

  clearErrors: () => set({ error: null, validationErrors: {} }),

  // ============================================
  // FORM ACTIONS
  // ============================================

  /**
   * Add product to order items
   * If product exists, increment quantity
   */
  addOrderItem: (product) => {
    const state = get();
    const existingItem = state.orderItems.find((item) => item.product_id === product.product_id);

    if (existingItem) {
      // Increment quantity
      set({
        orderItems: state.orderItems.map((item) =>
          item.product_id === product.product_id
            ? {
                ...item,
                quantity: item.quantity + 1,
                subtotal: (item.quantity + 1) * item.unit_price,
              }
            : item
        ),
      });
    } else {
      // Add new item
      const newItem: OrderFormItem = {
        product_id: product.product_id,
        product_name: product.product_name,
        sku: product.sku || '',
        unit: product.unit_of_measure || 'Unit',
        quantity: 1,
        unit_price: product.selling_price || 0,
        subtotal: product.selling_price || 0,
      };
      set({ orderItems: [...state.orderItems, newItem] });
    }
  },

  /**
   * Update order item quantity
   */
  updateOrderItemQuantity: (productId, quantity) => {
    const state = get();
    set({
      orderItems: state.orderItems.map((item) =>
        item.product_id === productId
          ? {
              ...item,
              quantity,
              subtotal: quantity * item.unit_price,
            }
          : item
      ),
    });
  },

  /**
   * Update order item unit price
   */
  updateOrderItemPrice: (productId, unitPrice) => {
    const state = get();
    set({
      orderItems: state.orderItems.map((item) =>
        item.product_id === productId
          ? {
              ...item,
              unit_price: unitPrice,
              subtotal: item.quantity * unitPrice,
            }
          : item
      ),
    });
  },

  /**
   * Remove order item
   */
  removeOrderItem: (productId) => {
    const state = get();
    set({
      orderItems: state.orderItems.filter((item) => item.product_id !== productId),
    });
  },

  /**
   * Search products
   */
  searchProducts: (query, allProducts) => {
    if (!query || query.length < 1) {
      set({ searchResults: [], showSuggestions: false });
      return;
    }

    // Search by product name or SKU (case insensitive)
    const lowerQuery = query.toLowerCase();
    const results = allProducts.filter(
      (product) =>
        product.product_name.toLowerCase().includes(lowerQuery) ||
        (product.sku && product.sku.toLowerCase().includes(lowerQuery))
    );

    set({
      searchResults: results.slice(0, 10), // Limit to 10 results
      showSuggestions: true,
    });
  },

  /**
   * Clear search
   */
  clearSearch: () => {
    set({
      searchTerm: '',
      searchResults: [],
      showSuggestions: false,
    });
  },

  /**
   * Validate form using OrderValidator
   * Returns true if valid
   */
  validateForm: () => {
    const state = get();

    // Convert form items to domain items for validation
    const domainItems: OrderItem[] = state.orderItems.map((item) => ({
      product_id: item.product_id,
      product_name: item.product_name,
      sku: item.sku,
      barcode: undefined,
      quantity_ordered: item.quantity,
      quantity_received_total: undefined,
      quantity_remaining: undefined,
      unit_price: item.unit_price,
      total_amount: item.subtotal,
    }));

    // Validate using OrderValidator
    const validationErrors = OrderValidator.validateOrderForm(
      state.orderDate,
      state.supplierTab,
      state.selectedSupplier?.counterparty_id || null,
      state.supplierTab === 'others' ? state.supplierInfo : null,
      domainItems
    );

    if (validationErrors.length > 0) {
      // Convert validation errors to object format
      const errors: Record<string, string> = {};
      validationErrors.forEach((err) => {
        errors[err.field] = err.message;
      });
      set({ validationErrors: errors });
      return false;
    }

    set({ validationErrors: {} });
    return true;
  },

  /**
   * Reset form to initial state
   */
  resetForm: () => {
    // Initialize order date to today
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    const todayString = `${year}-${month}-${day}`;

    set({
      orderDate: todayString,
      notes: '',
      supplierTab: 'counter-party',
      selectedSupplier: null,
      supplierInfo: initialSupplierInfo,
      orderItems: [],
      isDropdownOpen: false,
      searchTerm: '',
      showSuggestions: false,
      searchResults: [],
      error: null,
      validationErrors: {},
    });
  },

  // ============================================
  // COMPUTED VALUES (GETTERS)
  // ============================================

  /**
   * Get order summary
   */
  getSummary: () => {
    const state = get();
    return {
      items: state.orderItems.length,
      totalQuantity: state.orderItems.reduce((sum, item) => sum + item.quantity, 0),
      subtotal: state.orderItems.reduce((sum, item) => sum + item.subtotal, 0),
    };
  },
}));
