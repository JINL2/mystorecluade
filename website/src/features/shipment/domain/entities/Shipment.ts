/**
 * Shipment Entity
 * Domain entity representing a shipment in the system
 * Contains business rules and validations for shipment data
 */

import type {
  ShipmentStatus,
  LinkedOrder,
  OneTimeSupplier,
} from '../types';

// ===== Core Shipment Entity =====

/** Base shipment properties shared across contexts */
export interface ShipmentBase {
  shipmentId: string;
  shipmentNumber: string;
  trackingNumber: string | null;
  shippedDate: Date;
  status: ShipmentStatus;
  notes: string | null;
  createdAt: Date;
  createdBy: string | null;
}

/** Supplier information for a shipment */
export interface ShipmentSupplier {
  supplierId: string | null;
  supplierName: string;
  supplierPhone: string | null;
  supplierEmail: string | null;
  supplierAddress: string | null;
  isRegisteredSupplier: boolean;
}

/** Shipment item entity */
export interface ShipmentItemEntity {
  itemId: string;
  productId: string;
  productName: string;
  sku: string;
  quantityShipped: number;
  unitCost: number;
  totalAmount: number;
}

/** Complete shipment entity with all details */
export interface Shipment extends ShipmentBase, ShipmentSupplier {
  totalAmount: number;
  items: ShipmentItemEntity[];
  hasOrders: boolean;
  orderCount: number;
  orders: LinkedOrder[];
  canCancel: boolean;
}

/** Shipment list item entity (summary for list view) */
export interface ShipmentListItemEntity extends ShipmentBase {
  supplierId: string | null;
  supplierName: string;
  itemCount: number;
  hasOrders: boolean;
  linkedOrderCount: number;
}

// ===== Create Shipment Entity =====

/** New shipment item for creation */
export interface NewShipmentItem {
  orderItemId: string;
  orderId: string;
  orderNumber: string;
  productId: string;
  productName: string;
  sku: string;
  quantity: number;
  maxQuantity: number;
  unitPrice: number;
}

/** New shipment entity for creation */
export interface NewShipment {
  items: NewShipmentItem[];
  trackingNumber?: string;
  notes?: string;
  // Either order-based or supplier-based
  orderId?: string;
  supplierId?: string;
  oneTimeSupplier?: OneTimeSupplier;
}

// ===== Entity Class Implementation =====

/**
 * ShipmentEntity class with business logic methods
 */
export class ShipmentEntity implements Shipment {
  shipmentId: string;
  shipmentNumber: string;
  trackingNumber: string | null;
  shippedDate: Date;
  status: ShipmentStatus;
  totalAmount: number;
  notes: string | null;
  createdBy: string | null;
  createdAt: Date;
  supplierId: string | null;
  supplierName: string;
  supplierPhone: string | null;
  supplierEmail: string | null;
  supplierAddress: string | null;
  isRegisteredSupplier: boolean;
  items: ShipmentItemEntity[];
  hasOrders: boolean;
  orderCount: number;
  orders: LinkedOrder[];
  canCancel: boolean;

  constructor(data: Shipment) {
    this.shipmentId = data.shipmentId;
    this.shipmentNumber = data.shipmentNumber;
    this.trackingNumber = data.trackingNumber;
    this.shippedDate = data.shippedDate;
    this.status = data.status;
    this.totalAmount = data.totalAmount;
    this.notes = data.notes;
    this.createdBy = data.createdBy;
    this.createdAt = data.createdAt;
    this.supplierId = data.supplierId;
    this.supplierName = data.supplierName;
    this.supplierPhone = data.supplierPhone;
    this.supplierEmail = data.supplierEmail;
    this.supplierAddress = data.supplierAddress;
    this.isRegisteredSupplier = data.isRegisteredSupplier;
    this.items = data.items;
    this.hasOrders = data.hasOrders;
    this.orderCount = data.orderCount;
    this.orders = data.orders;
    this.canCancel = data.canCancel;
  }

  // ===== Business Logic Methods =====

  /**
   * Check if shipment is editable
   */
  isEditable(): boolean {
    return this.status === 'pending' || this.status === 'process';
  }

  /**
   * Check if shipment can be cancelled
   */
  isCancellable(): boolean {
    return this.canCancel && this.status !== 'cancelled' && this.status !== 'complete';
  }

  /**
   * Get total quantity shipped
   */
  getTotalQuantity(): number {
    return this.items.reduce((sum, item) => sum + item.quantityShipped, 0);
  }

  /**
   * Check if shipment has supplier contact info
   */
  hasSupplierContact(): boolean {
    return !!(this.supplierPhone || this.supplierEmail);
  }

  /**
   * Get status display text
   */
  getStatusDisplay(): string {
    const statusMap: Record<ShipmentStatus, string> = {
      pending: 'Pending',
      process: 'In Process',
      complete: 'Complete',
      cancelled: 'Cancelled',
    };
    return statusMap[this.status] || this.status;
  }

  /**
   * Check if shipment is linked to orders
   */
  isOrderLinked(): boolean {
    return this.hasOrders && this.orderCount > 0;
  }

  /**
   * Calculate item subtotal
   */
  getItemSubtotal(itemId: string): number {
    const item = this.items.find((i) => i.itemId === itemId);
    return item ? item.quantityShipped * item.unitCost : 0;
  }

  /**
   * Recalculate total amount from items
   */
  recalculateTotalAmount(): number {
    return this.items.reduce((sum, item) => sum + item.totalAmount, 0);
  }
}

// ===== Factory Functions =====

/**
 * Create empty shipment item entity
 */
export function createEmptyShipmentItem(): NewShipmentItem {
  return {
    orderItemId: '',
    orderId: '',
    orderNumber: '-',
    productId: '',
    productName: '',
    sku: '',
    quantity: 1,
    maxQuantity: 0,
    unitPrice: 0,
  };
}

/**
 * Create new shipment item from product search
 */
export function createShipmentItemFromProduct(
  product: { product_id: string; product_name: string; sku: string; stock: { quantity_on_hand: number }; price: { cost: number } }
): NewShipmentItem {
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

/**
 * Create new shipment item from order item
 */
export function createShipmentItemFromOrder(
  orderItem: { order_item_id: string; product_id: string; product_name: string; sku: string; remaining_quantity: number; unit_price: number },
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
