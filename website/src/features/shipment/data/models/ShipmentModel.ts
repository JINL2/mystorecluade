/**
 * ShipmentModel
 * DTO and Mapper for Shipment entity
 * Handles transformation between API/RPC responses and domain entities
 */

import type {
  Shipment,
  ShipmentListItemEntity,
  ShipmentItemEntity,
  NewShipmentItem,
} from '../../domain/entities/Shipment';
import type {
  ShipmentListItem,
  ShipmentDetail,
  ShipmentDetailItem,
  ShipmentStatus,
  LinkedOrder,
  Currency,
  OrderItem,
  InventoryProduct,
} from '../../domain/types';

// ===== Date Formatting Utilities =====

/**
 * Parse date string to Date object
 */
export function parseDate(dateStr: string | null | undefined): Date {
  if (!dateStr) return new Date();
  return new Date(dateStr);
}

/**
 * Format date for display (yyyy/MM/dd)
 */
export function formatDateDisplay(dateStr: string | null | undefined): string {
  if (!dateStr) return '';
  const date = new Date(dateStr);
  const year = date.getFullYear();
  const month = String(date.getMonth() + 1).padStart(2, '0');
  const day = String(date.getDate()).padStart(2, '0');
  return `${year}/${month}/${day}`;
}

/**
 * Format date with time
 */
export function formatDateTime(dateStr: string | null | undefined): string {
  if (!dateStr) return '';
  const parts = dateStr.split(' ');
  if (parts.length >= 2) {
    const datePart = parts[0];
    const timePart = parts[1].substring(0, 5); // HH:MM
    return `${formatDateDisplay(datePart)} ${timePart}`;
  }
  return formatDateDisplay(dateStr);
}

// ===== Shipment Model Class =====

export class ShipmentModel {
  // ===== List Item Mapping =====

  /**
   * Map RPC response to ShipmentListItem
   */
  static fromRpcListItem(data: ShipmentListItem): ShipmentListItem {
    return {
      shipment_id: data.shipment_id,
      shipment_number: data.shipment_number,
      tracking_number: data.tracking_number,
      shipped_date: data.shipped_date,
      supplier_id: data.supplier_id,
      supplier_name: data.supplier_name || 'Unknown Supplier',
      status: data.status,
      item_count: data.item_count || 0,
      has_orders: data.has_orders || false,
      linked_order_count: data.linked_order_count || 0,
      notes: data.notes,
      created_at: data.created_at,
      created_by: data.created_by,
    };
  }

  /**
   * Map RPC response array to ShipmentListItem array
   */
  static fromRpcList(data: ShipmentListItem[]): ShipmentListItem[] {
    return data.map((item) => this.fromRpcListItem(item));
  }

  /**
   * Map ShipmentListItem to domain entity
   */
  static toListEntity(data: ShipmentListItem): ShipmentListItemEntity {
    return {
      shipmentId: data.shipment_id,
      shipmentNumber: data.shipment_number,
      trackingNumber: data.tracking_number,
      shippedDate: parseDate(data.shipped_date),
      status: data.status,
      notes: data.notes,
      createdAt: parseDate(data.created_at),
      createdBy: data.created_by,
      supplierId: data.supplier_id,
      supplierName: data.supplier_name,
      itemCount: data.item_count,
      hasOrders: data.has_orders,
      linkedOrderCount: data.linked_order_count,
    };
  }

  // ===== Detail Mapping =====

  /**
   * Map RPC response to ShipmentDetail
   */
  static fromRpcDetail(data: ShipmentDetail): ShipmentDetail {
    return {
      shipment_id: data.shipment_id,
      shipment_number: data.shipment_number,
      tracking_number: data.tracking_number,
      shipped_date: data.shipped_date,
      status: data.status,
      total_amount: data.total_amount || 0,
      notes: data.notes,
      created_by: data.created_by,
      created_at: data.created_at,
      supplier_id: data.supplier_id,
      supplier_name: data.supplier_name || 'Unknown Supplier',
      supplier_phone: data.supplier_phone,
      supplier_email: data.supplier_email,
      supplier_address: data.supplier_address,
      is_registered_supplier: data.is_registered_supplier ?? true,
      items: data.items?.map((item) => this.fromRpcDetailItem(item)) || [],
      has_orders: data.has_orders || false,
      order_count: data.order_count || 0,
      orders: data.orders || [],
      can_cancel: data.can_cancel ?? false,
    };
  }

  /**
   * Map RPC detail item
   */
  static fromRpcDetailItem(data: ShipmentDetailItem): ShipmentDetailItem {
    return {
      item_id: data.item_id,
      product_id: data.product_id,
      product_name: data.product_name,
      sku: data.sku,
      quantity_shipped: data.quantity_shipped || 0,
      unit_cost: data.unit_cost || 0,
      total_amount: data.total_amount || 0,
    };
  }

  /**
   * Map ShipmentDetail to domain entity
   */
  static toDetailEntity(data: ShipmentDetail): Shipment {
    return {
      shipmentId: data.shipment_id,
      shipmentNumber: data.shipment_number,
      trackingNumber: data.tracking_number,
      shippedDate: parseDate(data.shipped_date),
      status: data.status,
      totalAmount: data.total_amount,
      notes: data.notes,
      createdBy: data.created_by,
      createdAt: parseDate(data.created_at),
      supplierId: data.supplier_id,
      supplierName: data.supplier_name,
      supplierPhone: data.supplier_phone,
      supplierEmail: data.supplier_email,
      supplierAddress: data.supplier_address,
      isRegisteredSupplier: data.is_registered_supplier,
      items: data.items.map((item) => this.toItemEntity(item)),
      hasOrders: data.has_orders,
      orderCount: data.order_count,
      orders: data.orders,
      canCancel: data.can_cancel,
    };
  }

  /**
   * Map ShipmentDetailItem to domain entity
   */
  static toItemEntity(data: ShipmentDetailItem): ShipmentItemEntity {
    return {
      itemId: data.item_id,
      productId: data.product_id,
      productName: data.product_name,
      sku: data.sku,
      quantityShipped: data.quantity_shipped,
      unitCost: data.unit_cost,
      totalAmount: data.total_amount,
    };
  }

  // ===== Create Shipment Mapping =====

  /**
   * Map NewShipmentItem to RPC item format
   */
  static toRpcCreateItem(item: NewShipmentItem): {
    sku: string;
    quantity_shipped: number;
    unit_cost: number;
  } {
    return {
      sku: item.sku,
      quantity_shipped: item.quantity,
      unit_cost: item.unitPrice,
    };
  }

  /**
   * Map array of NewShipmentItem to RPC format
   */
  static toRpcCreateItems(items: NewShipmentItem[]): Array<{
    sku: string;
    quantity_shipped: number;
    unit_cost: number;
  }> {
    return items.map((item) => this.toRpcCreateItem(item));
  }

  // ===== Order Item Mapping =====

  /**
   * Map OrderItem to NewShipmentItem
   */
  static fromOrderItem(
    orderItem: OrderItem,
    orderId: string,
    orderNumber: string
  ): NewShipmentItem {
    return {
      orderItemId: orderItem.order_item_id,
      orderId: orderId,
      orderNumber: orderNumber,
      productId: orderItem.product_id,
      productName: orderItem.product_name,
      sku: orderItem.sku,
      quantity: orderItem.remaining_quantity,
      maxQuantity: orderItem.remaining_quantity,
      unitPrice: orderItem.unit_price,
    };
  }

  // ===== Product Mapping =====

  /**
   * Map InventoryProduct to NewShipmentItem
   */
  static fromProduct(product: InventoryProduct): NewShipmentItem {
    return {
      orderItemId: `search-${product.product_id}-${Date.now()}`,
      orderId: '',
      orderNumber: '-',
      productId: product.product_id,
      productName: product.product_name,
      sku: product.sku,
      quantity: 1,
      maxQuantity: product.stock.quantity_on_hand,
      unitPrice: product.price.cost,
    };
  }

  // ===== Currency Mapping =====

  /**
   * Map RPC currency response to Currency
   */
  static fromRpcCurrency(data: { symbol?: string; currency_code?: string } | null): Currency {
    return {
      symbol: data?.symbol || '₩',
      code: data?.currency_code || 'KRW',
    };
  }

  // ===== Utility Methods =====

  /**
   * Calculate total amount from items
   */
  static calculateTotalAmount(items: NewShipmentItem[]): number {
    return items.reduce((sum, item) => sum + item.quantity * item.unitPrice, 0);
  }

  /**
   * Format price with currency symbol
   */
  static formatPrice(price: number, currency: Currency): string {
    return `${currency.symbol}${price.toLocaleString()}`;
  }

  /**
   * Get status display class name
   */
  static getStatusClassName(status: ShipmentStatus): string {
    const statusMap: Record<ShipmentStatus, string> = {
      pending: 'pending',
      process: 'process',
      complete: 'complete',
      cancelled: 'cancelled',
    };
    return statusMap[status] || status;
  }

  /**
   * Filter order items with remaining quantity
   */
  static filterAvailableOrderItems(items: OrderItem[]): OrderItem[] {
    return items.filter((item) => item.remaining_quantity > 0);
  }

  /**
   * Check if shipment item already exists by product ID
   */
  static findExistingItem(
    items: NewShipmentItem[],
    productId: string
  ): NewShipmentItem | undefined {
    return items.find((item) => item.productId === productId);
  }

  /**
   * Check if shipment item already exists by order item ID
   */
  static findExistingByOrderItemId(
    items: NewShipmentItem[],
    orderItemId: string
  ): NewShipmentItem | undefined {
    return items.find((item) => item.orderItemId === orderItemId);
  }
}
