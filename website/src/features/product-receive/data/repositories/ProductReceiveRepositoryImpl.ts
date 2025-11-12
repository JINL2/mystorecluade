/**
 * ProductReceiveRepositoryImpl
 * Implementation of IProductReceiveRepository
 */

import {
  IProductReceiveRepository,
  ReceiveItem,
  RepositoryResult,
} from '../../domain/repositories/IProductReceiveRepository';
import { Order } from '../../domain/entities/Order';
import { OrderProduct } from '../../domain/entities/OrderProduct';
import { ReceiveResult } from '../../domain/entities/ReceiveResult';
import { ProductReceiveDataSource } from '../datasources/ProductReceiveDataSource';
import { OrderModel } from '../models/OrderModel';
import { ReceiveResultModel } from '../models/ReceiveResultModel';

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

      // Convert DTOs to Domain Entities using Model mapper
      const allOrders = OrderModel.fromDTOArray(response.orders);

      // Filter to only receivable orders (pending or partial)
      const receivableOrders = OrderModel.filterReceivableOrders(allOrders);

      return {
        success: true,
        data: receivableOrders,
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

  async getCurrentUserId(): Promise<RepositoryResult<string>> {
    try {
      const userId = await this.dataSource.getCurrentUserId();

      if (!userId) {
        return {
          success: false,
          error: 'User session not found. Please login again.',
        };
      }

      return {
        success: true,
        data: userId,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to get user ID',
      };
    }
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

      // Convert DTO to Domain Entity using Model mapper
      const result = ReceiveResultModel.fromDTO(response);

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
