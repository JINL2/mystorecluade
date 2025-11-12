/**
 * Order Entity
 * Represents a purchase order
 */

import { DateTimeUtils } from '@/core/utils/datetime-utils';

export interface ReceiptsByStore {
  [storeName: string]: {
    store_id: string;
    quantity_received: number;
    last_receipt_date: string;
  };
}

export interface OrderItem {
  product_id: string;
  product_name: string;
  sku?: string;
  barcode?: string;
  quantity_ordered: number;
  quantity_received_total?: number;
  quantity_remaining?: number;
  unit_price: number;
  total_amount: number;
  receipts_by_store?: ReceiptsByStore;
}

export interface OrderSummary {
  total_products: number;
  total_ordered: number;
  total_received: number;
  completion_rate: number;
}

export class Order {
  constructor(
    public readonly orderId: string,
    public readonly orderNumber: string,
    public readonly orderDate: string,
    public readonly expectedDate: string | null,
    public readonly supplierName: string,
    public readonly itemCount: number,
    public readonly totalQuantity: number,
    public readonly totalAmount: number,
    public readonly status: 'pending' | 'approved' | 'received' | 'cancelled' | 'partial',
    public readonly currencySymbol: string,
    public readonly items?: OrderItem[],
    public readonly summary?: OrderSummary
  ) {}

  /**
   * Get status display
   */
  get statusDisplay(): string {
    switch (this.status) {
      case 'pending':
        return 'Pending';
      case 'approved':
        return 'Approved';
      case 'received':
        return 'Received';
      case 'cancelled':
        return 'Cancelled';
      case 'partial':
        return 'Partial';
      default:
        return this.status;
    }
  }

  /**
   * Format currency amount (integer only, following backup pattern)
   */
  formatCurrency(amount: number): string {
    return `${this.currencySymbol}${Math.round(amount).toString().replace(/\B(?=(\d{3})+(?!\d))/g, ',')}`;
  }

  /**
   * Get formatted date
   * Converts UTC date from DB to local time for display
   */
  get formattedDate(): string {
    const localDate = DateTimeUtils.toLocal(this.orderDate);
    return DateTimeUtils.formatCustom(localDate, {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    }, 'en-US');
  }

  /**
   * Get formatted expected date
   * Converts UTC date from DB to local time for display
   */
  get formattedExpectedDate(): string | null {
    if (!this.expectedDate) return null;
    const localDate = DateTimeUtils.toLocal(this.expectedDate);
    return DateTimeUtils.formatCustom(localDate, {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    }, 'en-US');
  }

  /**
   * Check if order can be cancelled
   */
  get isCancellable(): boolean {
    return this.status === 'pending' || this.status === 'approved';
  }

  /**
   * Check if order can be received
   */
  get isReceivable(): boolean {
    return this.status === 'approved' || this.status === 'partial';
  }

  /**
   * Get receiving progress
   */
  get receivingProgress(): { received: number; total: number; percentage: number } {
    if (this.summary) {
      return {
        received: this.summary.total_received,
        total: this.summary.total_ordered,
        percentage: this.summary.completion_rate,
      };
    }
    return { received: 0, total: 0, percentage: 0 };
  }
}
