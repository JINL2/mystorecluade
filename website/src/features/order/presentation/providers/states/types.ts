/**
 * Order State Types
 * Shared type definitions for order state management
 */

import type { Order, OrderItem } from '../../../domain/entities/Order';

/**
 * Notification state for success/error messages
 */
export interface NotificationState {
  isOpen: boolean;
  variant: 'success' | 'error';
  message: string;
}

/**
 * Currency information
 */
export interface CurrencyInfo {
  symbol: string;
  code: string;
}

/**
 * Repository response type
 */
export interface RepositoryResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

/**
 * Order creation result
 */
export interface CreateOrderResult {
  success: boolean;
  orderId?: string;
  error?: string;
}

/**
 * Order cancellation result
 */
export interface CancelOrderResult {
  success: boolean;
  error?: string;
}

// Re-export types that are used across the feature
export type { Order, OrderItem };
