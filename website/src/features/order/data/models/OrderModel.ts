/**
 * OrderModel
 * DTO (Data Transfer Object) and Mapper for Order entity
 * Handles conversion between database schema and domain entity
 */

import { Order, OrderItem, OrderSummary } from '../../domain/entities/Order';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * Raw order data from database/RPC
 * Matches the structure returned by get_inventory_order_list RPC function
 */
export interface OrderDTO {
  order_id: string;
  order_number: string;
  order_date: string;
  expected_date: string | null;
  supplier_name: string;
  total_amount: number;
  status: 'pending' | 'approved' | 'received' | 'cancelled' | 'partial';
  items?: OrderItem[];
  summary?: OrderSummary;
}

/**
 * OrderModel class - handles data transformation
 */
export class OrderModel {
  /**
   * Convert raw database/RPC data to Order entity
   * Converts UTC dates (order_date, expected_date) to local time using DateTimeUtils
   */
  static fromJson(json: OrderDTO, defaultCurrencySymbol: string = '$'): Order {
    // Extract data from summary (RPC returns summary object)
    const itemCount = json.summary?.total_products ?? (json.items ? json.items.length : 0);
    const totalQuantity = json.summary?.total_ordered ?? 0;
    const currencySymbol = defaultCurrencySymbol;

    // Convert UTC dates from DB to local time
    const localOrderDate = DateTimeUtils.toLocal(json.order_date);
    const localOrderDateString = localOrderDate.toISOString();

    const localExpectedDateString = json.expected_date
      ? DateTimeUtils.toLocal(json.expected_date).toISOString()
      : null;

    return new Order(
      json.order_id,
      json.order_number,
      localOrderDateString,
      localExpectedDateString,
      json.supplier_name,
      itemCount,
      totalQuantity,
      json.total_amount,
      json.status,
      currencySymbol,
      json.items,
      json.summary
    );
  }

  /**
   * Convert Order entity to database format (for create/update operations)
   */
  static toJson(order: Order): OrderDTO {
    return {
      order_id: order.orderId,
      order_number: order.orderNumber,
      order_date: order.orderDate,
      expected_date: order.expectedDate,
      supplier_name: order.supplierName,
      total_amount: order.totalAmount,
      status: order.status,
      items: order.items,
      summary: order.summary,
    };
  }

  /**
   * Batch convert multiple orders from JSON
   */
  static fromJsonArray(jsonArray: OrderDTO[], defaultCurrencySymbol: string = '$'): Order[] {
    return jsonArray.map((json) => OrderModel.fromJson(json, defaultCurrencySymbol));
  }
}
