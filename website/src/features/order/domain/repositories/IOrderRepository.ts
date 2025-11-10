/**
 * IOrderRepository Interface
 * Repository interface for order operations
 */

import { Order } from '../entities/Order';

export interface OrderResult {
  success: boolean;
  data?: Order[];
  error?: string;
}

export interface IOrderRepository {
  /**
   * Get orders for a company
   */
  getOrders(companyId: string, storeId: string | null): Promise<OrderResult>;
}
