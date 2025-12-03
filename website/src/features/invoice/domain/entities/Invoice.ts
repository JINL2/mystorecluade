/**
 * Invoice Entity
 * Represents a sales invoice with customer and item details
 */

import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class Invoice {
  constructor(
    public readonly invoiceId: string,
    public readonly invoiceNumber: string,
    public readonly invoiceDate: string,
    public readonly storeId: string,
    public readonly cashLocationId: string | null,
    public readonly customerName: string,
    public readonly customerPhone: string | null,
    public readonly itemCount: number,
    public readonly totalQuantity: number,
    public readonly totalAmount: number,
    public readonly status: 'draft' | 'issued' | 'paid' | 'cancelled' | 'completed',
    public readonly currencySymbol: string,
    public readonly paymentMethod: 'cash' | 'card' | 'bank' | 'transfer' | string = 'cash',
    public readonly paymentStatus: 'paid' | 'pending' | 'cancelled' | string = 'pending',
    public readonly totalCost: number = 0,
    public readonly profit: number = 0,
    // Store info
    public readonly storeName: string = '',
    public readonly storeCode: string = '',
    // Cash location info
    public readonly cashLocationName: string | null = null,
    public readonly cashLocationType: string | null = null,
    // Amount details
    public readonly subtotal: number = 0,
    public readonly taxAmount: number = 0,
    public readonly discountAmount: number = 0,
    // Created by info
    public readonly createdByName: string = '',
    public readonly createdByEmail: string = '',
    // Created at timestamp
    public readonly createdAt: string = ''
  ) {}

  /**
   * Get status display
   */
  get statusDisplay(): string {
    switch (this.status) {
      case 'draft':
        return 'Draft';
      case 'issued':
        return 'Issued';
      case 'paid':
        return 'Paid';
      case 'completed':
        return 'Completed';
      case 'cancelled':
        return 'Cancelled';
      default:
        return this.status;
    }
  }

  /**
   * Format currency amount
   */
  formatCurrency(amount: number | null | undefined): string {
    const safeAmount = amount ?? 0;
    return `${this.currencySymbol}${safeAmount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get formatted date
   * Note: invoiceDate is already converted to local timezone in InvoiceModel
   */
  get formattedDate(): string {
    if (!this.invoiceDate) {
      return 'Invalid Date';
    }

    try {
      // invoiceDate is already in local timezone, just parse and format
      const localDate = new Date(this.invoiceDate);

      // Format using Korean locale: "2025. 10. 25."
      return localDate.toLocaleDateString('ko-KR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
      });
    } catch (error) {
      console.error('Error formatting date:', this.invoiceDate, error);
      return 'Invalid Date';
    }
  }

  /**
   * Check if invoice is editable
   */
  get isEditable(): boolean {
    return this.status === 'draft';
  }

  /**
   * Check if invoice can be cancelled
   */
  get isCancellable(): boolean {
    return this.status === 'draft' || this.status === 'issued';
  }

  /**
   * Get payment method display text
   */
  get paymentMethodDisplay(): string {
    const methodMap: Record<string, string> = {
      'cash': 'Cash',
      'card': 'Card',
      'bank': 'Bank',
      'transfer': 'Bank',
      'bank_transfer': 'Bank',
    };
    return methodMap[this.paymentMethod] || this.paymentMethod;
  }

  /**
   * Get payment badge class for styling based on payment method
   */
  get paymentBadgeClass(): string {
    const method = this.paymentMethod.toLowerCase();
    if (method === 'bank' || method === 'transfer') {
      return 'payment-bank';
    } else if (method === 'card') {
      return 'payment-card';
    } else if (method === 'cash') {
      return 'payment-cash';
    }
    return 'payment-default';
  }

  /**
   * Get formatted time (HH:MM:SS)
   * Extracts time from createdAt timestamp
   */
  get formattedTime(): string {
    if (!this.createdAt) {
      return '';
    }

    try {
      const date = new Date(this.createdAt);
      return date.toLocaleTimeString('en-US', {
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit',
        hour12: false,
      });
    } catch (error) {
      console.error('Error formatting time:', this.createdAt, error);
      return '';
    }
  }
}
