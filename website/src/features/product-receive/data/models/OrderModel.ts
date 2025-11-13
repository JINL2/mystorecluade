/**
 * OrderModel
 * DTO and Mapper for Order entity
 */

import { Order, OrderEntity } from '../../domain/entities/Order';
import { OrderProductModel, OrderProductDTO } from './OrderProductModel';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * DTO from Supabase RPC
 */
export interface OrderDTO {
  order_id: string;
  order_number: string;
  supplier_name: string;
  status: string;
  order_date: string;
  summary?: {
    total_products: number;
    total_ordered: number;
    total_received: number;
    completion_rate: number;
  };
  items?: OrderProductDTO[]; // Products in this order
}

/**
 * Mapper class for Order
 */
export class OrderModel {
  /**
   * Convert DTO to Domain Entity
   */
  static fromDTO(dto: OrderDTO): Order {
    // Map order items if they exist
    const items = dto.items
      ? OrderProductModel.fromDTOArray(dto.items)
      : undefined;

    return new OrderEntity({
      orderId: dto.order_id,
      orderNumber: dto.order_number,
      supplierName: dto.supplier_name,
      status: dto.status as 'pending' | 'partial' | 'completed' | 'cancelled',
      orderDate: DateTimeUtils.toLocal(dto.order_date),
      totalItems: dto.summary?.total_ordered || 0,
      receivedItems: dto.summary?.total_received || 0,
      remainingItems: (dto.summary?.total_ordered || 0) - (dto.summary?.total_received || 0),
      items: items,
    });
  }

  /**
   * Convert Domain Entity to DTO (for API requests)
   */
  static toDTO(entity: Order): Partial<OrderDTO> {
    return {
      order_id: entity.orderId,
      order_number: entity.orderNumber,
      supplier_name: entity.supplierName,
      status: entity.status,
      order_date: DateTimeUtils.toUtc(entity.orderDate),
      summary: {
        total_products: entity.items?.length || 0,
        total_ordered: entity.totalItems,
        total_received: entity.receivedItems,
        completion_rate: entity.progressPercentage || 0,
      },
    };
  }

  /**
   * Convert array of DTOs to Domain Entities
   */
  static fromDTOArray(dtos: OrderDTO[]): Order[] {
    return dtos.map((dto) => OrderModel.fromDTO(dto));
  }

  /**
   * Filter orders to only receivable ones (pending or partial)
   */
  static filterReceivableOrders(orders: Order[]): Order[] {
    return orders.filter((order) => order.isReceivable);
  }
}
