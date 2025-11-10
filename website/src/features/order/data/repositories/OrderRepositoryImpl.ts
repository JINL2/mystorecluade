/**
 * OrderRepositoryImpl
 * Implementation of IOrderRepository interface
 */

import { IOrderRepository, OrderResult } from '../../domain/repositories/IOrderRepository';
import { Order } from '../../domain/entities/Order';
import { OrderDataSource } from '../datasources/OrderDataSource';

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
      const currencySymbol = currencyData?.currency_symbol || '$';

      const orders = ordersData.map(
        (item: any) =>
          new Order(
            item.order_id,
            item.order_number,
            item.order_date,
            item.supplier_name,
            item.item_count || (item.items ? item.items.length : 0),
            item.total_quantity || (item.summary ? item.summary.total_ordered : 0),
            item.total_amount,
            item.status,
            item.currency_symbol || currencySymbol,
            item.items,
            item.summary
          )
      );

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
