/**
 * OrderRepositoryImpl
 * Implementation of IOrderRepository interface
 * Uses OrderModel for DTO-to-Entity conversion
 */

import { IOrderRepository, OrderResult } from '../../domain/repositories/IOrderRepository';
import { OrderDataSource } from '../datasources/OrderDataSource';
import { OrderModel } from '../models/OrderModel';

export class OrderRepositoryImpl implements IOrderRepository {
  private dataSource: OrderDataSource;

  constructor() {
    this.dataSource = new OrderDataSource();
  }

  async getOrders(companyId: string, storeId: string | null): Promise<OrderResult> {
    try {
      // Fetch currency and orders in parallel
      const [currencyData, ordersData] = await Promise.all([
        this.dataSource.getCompanyCurrency(companyId),
        this.dataSource.getOrders(companyId, storeId),
      ]);

      // Get currency symbol from fetched data, fallback to $ if not available
      const defaultCurrencySymbol = currencyData?.currency_symbol || '$';

      // Use OrderModel to convert raw data to Order entities
      const orders = OrderModel.fromJsonArray(ordersData, defaultCurrencySymbol);

      return {
        success: true,
        data: orders,
      };
    } catch (error) {
      console.error('Repository error fetching orders:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch orders',
      };
    }
  }
}
