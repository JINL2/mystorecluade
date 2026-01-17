/**
 * Sale Product State Interface
 * Type definitions for Zustand store
 * v6: Updated cart actions to use uniqueKey (product_id + variant_id) for variant support
 */

import { CartItem } from '../../../domain/entities/CartItem';
import { Product } from '../../../domain/entities/Product';
import { ExchangeRate } from '../../../domain/entities/ExchangeRate';
import { CashLocation } from '../../../domain/entities/CashLocation';
import { DiscountType } from '../../../domain/entities/SaleInvoice';

export interface SaleProductState {
  // ============================================
  // STATE
  // ============================================

  // Cart State
  cartItems: CartItem[];
  subtotal: number;
  totalCost: number;

  // Discount State
  discountType: DiscountType;
  discountValue: number;
  discountAmount: number;
  total: number;

  // Modal State
  isPaymentModalOpen: boolean;
  selectedCashLocationId: string;
  exchangeRates: ExchangeRate[];
  cashLocations: CashLocation[];

  // Loading State
  loadingRates: boolean;
  loadingLocations: boolean;
  submitting: boolean;

  // Error State
  error: string | null;

  // ============================================
  // ACTIONS - Cart Management
  // v6: Actions use uniqueKey (product_id + variant_id) for variant support
  // ============================================

  addToCart: (product: Product) => void;
  removeFromCart: (uniqueKey: string) => void;
  updateQuantity: (uniqueKey: string, quantity: number) => void;
  clearCart: () => void;

  // ============================================
  // ACTIONS - Discount Management
  // ============================================

  setDiscountType: (type: DiscountType) => void;
  setDiscountValue: (value: number) => void;

  // ============================================
  // ACTIONS - Modal Management
  // ============================================

  openPaymentModal: () => void;
  closePaymentModal: () => void;
  setSelectedCashLocation: (id: string) => void;

  // ============================================
  // ASYNC ACTIONS
  // ============================================

  loadModalData: (companyId: string, storeId: string) => Promise<void>;
  submitInvoice: (companyId: string, storeId: string, userId: string) => Promise<{
    success: boolean;
    invoiceId?: string;
    error?: string;
  }>;

  // ============================================
  // UTILITY ACTIONS
  // ============================================

  reset: () => void;
  setError: (error: string | null) => void;
}
