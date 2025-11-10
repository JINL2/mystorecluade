/**
 * Order Entity
 * Represents a purchase order
 */

export interface OrderItem {
  product_id: string;
  product_name: string;
  sku?: string;
  barcode?: string;
  quantity_ordered: number;
  quantity_received?: number;
  unit_price: number;
  subtotal: number;
}

export interface OrderSummary {
  total_products: number;
  total_ordered: number;
  total_received: number;
  completion_percentage: number;
}

export class Order {
  constructor(
    public readonly orderId: string,
    public readonly orderNumber: string,
    public readonly orderDate: string,
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
   */
  get formattedDate(): string {
    return new Date(this.orderDate).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
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
        percentage: this.summary.completion_percentage,
      };
    }
    return { received: 0, total: 0, percentage: 0 };
  }
}
