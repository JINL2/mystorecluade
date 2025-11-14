/**
 * Product Receive State Types
 * Shared type definitions for product receive state management
 */

import type { Order } from '../../../domain/entities/Order';
import type { OrderProduct } from '../../../domain/entities/OrderProduct';
import type { ScannedItemEntity } from '../../../domain/entities/ScannedItem';
import type { ReceiveResult } from '../../../domain/entities/ReceiveResult';

/**
 * Repository response type
 */
export interface RepositoryResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
}

/**
 * Submit receive result
 */
export interface SubmitReceiveResult {
  success: boolean;
  data?: ReceiveResult;
  error?: string;
}

// Re-export types that are used across the feature
export type { Order, OrderProduct, ScannedItemEntity, ReceiveResult };
