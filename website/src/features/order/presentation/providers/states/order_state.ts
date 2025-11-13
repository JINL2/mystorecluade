/**
 * Order State Interface
 * State interface definition for order feature
 *
 * Following 2025 Best Practice:
 * - Zustand for state management
 * - Async operations in store
 * - Repository pattern integration
 */

import type { Order, NotificationState, CurrencyInfo, CreateOrderResult, CancelOrderResult } from './types';

export interface OrderState {
  // ============================================
  // DATA STATE
  // ============================================
  orders: Order[];
  selectedOrder: Order | null;
  currency: CurrencyInfo;

  // ============================================
  // UI STATE
  // ============================================
  activeTab: 'new-order' | 'order-list';
  searchQuery: string;
  selectedOrderIds: Set<string>;

  // ============================================
  // LOADING/ERROR STATE
  // ============================================
  loading: boolean;
  error: string | null;
  isCreatingOrder: boolean;
  isCancellingOrder: boolean;

  // ============================================
  // NOTIFICATION STATE
  // ============================================
  notification: NotificationState;

  // ============================================
  // SYNCHRONOUS ACTIONS
  // ============================================
  setActiveTab: (tab: 'new-order' | 'order-list') => void;
  setSearchQuery: (query: string) => void;
  toggleOrderSelection: (orderId: string) => void;
  selectAllOrders: () => void;
  clearSelection: () => void;

  setSelectedOrder: (order: Order | null) => void;

  showNotification: (variant: 'success' | 'error', message: string) => void;
  hideNotification: () => void;

  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;
  clearError: () => void;

  // ============================================
  // ASYNCHRONOUS ACTIONS
  // ============================================
  loadOrders: (companyId: string, storeId: string | null) => Promise<void>;
  createOrder: (params: any) => Promise<CreateOrderResult>;
  cancelOrder: (orderId: string) => Promise<CancelOrderResult>;
  refresh: () => Promise<void>;
}
