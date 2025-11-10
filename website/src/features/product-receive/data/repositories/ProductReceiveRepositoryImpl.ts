/**
 * ProductReceiveRepositoryImpl
 * Implementation of IProductReceiveRepository
 */

import {
  IProductReceiveRepository,
  ReceiveItem,
  RepositoryResult,
} from '../../domain/repositories/IProductReceiveRepository';
import { Order, OrderEntity } from '../../domain/entities/Order';
import { OrderProduct, OrderProductEntity } from '../../domain/entities/OrderProduct';
import { ReceiveResult, ReceiveResultEntity } from '../../domain/entities/ReceiveResult';
import {
  ProductReceiveDataSource,
  OrderDTO,
  OrderProductDTO,
} from '../datasources/ProductReceiveDataSource';

export class ProductReceiveRepositoryImpl implements IProductReceiveRepository {
  private dataSource: ProductReceiveDataSource;

  constructor() {
    this.dataSource = new ProductReceiveDataSource();
  }

  async getOrders(companyId: string): Promise<RepositoryResult<Order[]>> {
    try {
      const response = await this.dataSource.getOrders(companyId);

      if (!response || !response.orders) {
        return {
          success: true,
          data: [],
        };
      }

      // Filter to only receivable orders (pending or partial)
      const receivableOrders = response.orders.filter(
        (order: OrderDTO) => order.status === 'pending' || order.status === 'partial'
      );

      const orders = receivableOrders.map((dto: OrderDTO) => {
        // Map order items if they exist
        const items = dto.items?.map((itemDto: OrderProductDTO) => {
          return new OrderProductEntity({
            productId: itemDto.product_id,
            sku: itemDto.sku,
            productName: itemDto.product_name,
            quantityOrdered: itemDto.quantity_ordered || 0,
            quantityReceived: itemDto.quantity_received_total || 0,
            quantityRemaining: (itemDto.quantity_ordered || 0) - (itemDto.quantity_received_total || 0),
            unit: '', // Not provided in the backup structure
          });
        });

        return new OrderEntity({
          orderId: dto.order_id,
          orderNumber: dto.order_number,
          supplierName: dto.supplier_name,
          status: dto.status as 'pending' | 'partial' | 'completed' | 'cancelled',
          orderDate: dto.order_date,
          totalItems: dto.summary?.total_ordered || 0,
          receivedItems: dto.summary?.total_received || 0,
          remainingItems: (dto.summary?.total_ordered || 0) - (dto.summary?.total_received || 0),
          items: items,
        });
      });

      return {
        success: true,
        data: orders,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to get orders',
      };
    }
  }

  async getOrderProducts(
    companyId: string,
    orderId: string
  ): Promise<RepositoryResult<OrderProduct[]>> {
    // Note: The backup page doesn't have a separate RPC for getting order products
    // They are likely included in the order details
    // For now, return empty array - will be implemented when we know the actual RPC
    return {
      success: true,
      data: [],
    };
  }

  async searchProducts(
    orderId: string,
    searchTerm: string
  ): Promise<RepositoryResult<OrderProduct[]>> {
    // This would require a search RPC or client-side filtering
    // For now, return empty array
    return {
      success: true,
      data: [],
    };
  }

  async submitReceive(
    companyId: string,
    storeId: string,
    orderId: string,
    userId: string,
    items: ReceiveItem[],
    notes?: string | null
  ): Promise<RepositoryResult<ReceiveResult>> {
    try {
      const itemDTOs = items.map((item) => ({
        product_id: item.productId,
        quantity_received: item.quantityReceived,
      }));

      const response = await this.dataSource.submitReceive(
        companyId,
        storeId,
        orderId,
        userId,
        itemDTOs,
        notes
      );

      const result = new ReceiveResultEntity({
        success: response.success,
        receiptNumber: response.receipt_number,
        message: response.message,
        receivedCount: response.received_count,
        warnings: response.warnings,
      });

      return {
        success: true,
        data: result,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to submit receive',
      };
    }
  }
}
