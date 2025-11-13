/**
 * Product Receive State Interface
 * State interface definition for product receive feature
 *
 * Following 2025 Best Practice:
 * - Zustand for state management
 * - Async operations in store
 * - Repository pattern integration
 */

import type { Order, OrderProduct, ScannedItemEntity, SubmitReceiveResult } from './types';

export interface ProductReceiveState {
  // ============================================
  // ORDER STATE
  // ============================================
  orders: Order[];
  selectedOrder: Order | null;
  orderProducts: OrderProduct[];
  loadingOrders: boolean;

  // ============================================
  // SCANNING STATE
  // ============================================
  scannedItems: Map<string, ScannedItemEntity>;
  skuInput: string;
  autocompleteResults: OrderProduct[];
  showAutocomplete: boolean;

  // ============================================
  // SEARCH/FILTER STATE
  // ============================================
  productSearchTerm: string;
  filteredProducts: OrderProduct[];

  // ============================================
  // UI STATE
  // ============================================
  submitting: boolean;
  error: string | null;

  // ============================================
  // SYNCHRONOUS ACTIONS
  // ============================================
  setSkuInput: (value: string) => void;
  setShowAutocomplete: (show: boolean) => void;
  setProductSearchTerm: (term: string) => void;
  setError: (error: string | null) => void;
  clearError: () => void;

  // ============================================
  // ASYNCHRONOUS ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load orders for company
   */
  loadOrders: (companyId: string) => Promise<void>;

  /**
   * Select an order
   */
  selectOrder: (order: Order) => void;

  /**
   * Handle SKU input for autocomplete
   */
  handleSkuInput: (value: string) => void;

  /**
   * Add scanned item
   */
  addScannedItem: (product: OrderProduct) => void;

  /**
   * Update scanned item quantity
   */
  updateScannedQuantity: (sku: string, quantity: number) => void;

  /**
   * Remove scanned item
   */
  removeScannedItem: (sku: string) => void;

  /**
   * Clear all scanned items
   */
  clearAllScanned: () => void;

  /**
   * Submit receive
   */
  submitReceive: (companyId: string, storeId: string, userId: string) => Promise<SubmitReceiveResult>;
}
