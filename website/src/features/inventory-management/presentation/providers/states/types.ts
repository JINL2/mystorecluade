/**
 * Inventory State Types
 * Shared type definitions for inventory state management
 */

import type { InventoryItem } from '../../../domain/entities/InventoryItem';
import type { UpdateProductData } from '../../../domain/repositories/IInventoryRepository';

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
 * Update product result
 */
export interface UpdateProductResult {
  success: boolean;
  error?: string;
}

// Re-export types that are used across the feature
export type { InventoryItem, UpdateProductData };
