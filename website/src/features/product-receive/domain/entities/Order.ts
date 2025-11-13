/**
 * Order Entity
 * Represents a purchase order for product receiving
 */

import { OrderProduct } from './OrderProduct';

export interface Order {
  orderId: string;
  orderNumber: string;
  supplierName: string;
  status: 'pending' | 'partial' | 'completed' | 'cancelled';
  orderDate: Date;
  totalItems: number;
  receivedItems: number;
  remainingItems: number;
  items?: OrderProduct[]; // Products in this order

  // Computed properties (available in OrderEntity)
  progressPercentage?: number;
  isReceivable?: boolean;
  displayName?: string;
}

export class OrderEntity implements Order {
  orderId: string;
  orderNumber: string;
  supplierName: string;
  status: 'pending' | 'partial' | 'completed' | 'cancelled';
  orderDate: Date;
  totalItems: number;
  receivedItems: number;
  remainingItems: number;
  items?: OrderProduct[];

  constructor(data: Order) {
    this.orderId = data.orderId;
    this.orderNumber = data.orderNumber;
    this.supplierName = data.supplierName;
    this.status = data.status;
    this.orderDate = data.orderDate;
    this.totalItems = data.totalItems;
    this.receivedItems = data.receivedItems;
    this.remainingItems = data.remainingItems;
    this.items = data.items;
  }

  get progressPercentage(): number {
    if (this.totalItems === 0) return 0;
    return Math.round((this.receivedItems / this.totalItems) * 100);
  }

  get isReceivable(): boolean {
    return this.status === 'pending' || this.status === 'partial';
  }

  get displayName(): string {
    return `${this.orderNumber} - ${this.supplierName}`;
  }
}
