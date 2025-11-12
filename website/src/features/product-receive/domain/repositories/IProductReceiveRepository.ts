/**
 * IProductReceiveRepository
 * Repository interface for product receive operations
 */

import { Order } from '../entities/Order';
import { OrderProduct } from '../entities/OrderProduct';
import { ReceiveResult } from '../entities/ReceiveResult';

export interface ReceiveItem {
  productId: string;
  quantityReceived: number;
}

export interface RepositoryResult<T> {
  success: boolean;
  data?: T;
  error?: string;
}

export interface IProductReceiveRepository {
  /**
   * Get list of orders for a company
   */
  getOrders(companyId: string): Promise<RepositoryResult<Order[]>>;

  /**
   * Get products in a specific order
   */
  getOrderProducts(
    companyId: string,
    orderId: string
  ): Promise<RepositoryResult<OrderProduct[]>>;

  /**
   * Search products by SKU or name for autocomplete
   */
  searchProducts(
    orderId: string,
    searchTerm: string
  ): Promise<RepositoryResult<OrderProduct[]>>;

  /**
   * Get current user ID from session
   */
  getCurrentUserId(): Promise<RepositoryResult<string>>;

  /**
   * Submit received items
   */
  submitReceive(
    companyId: string,
    storeId: string,
    orderId: string,
    userId: string,
    items: ReceiveItem[],
    notes?: string | null
  ): Promise<RepositoryResult<ReceiveResult>>;
}
