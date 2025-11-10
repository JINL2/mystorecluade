/**
 * Invoice Entity
 * Represents a sales invoice with customer and item details
 */

export class Invoice {
  constructor(
    public readonly invoiceId: string,
    public readonly invoiceNumber: string,
    public readonly invoiceDate: string,
    public readonly customerName: string,
    public readonly customerPhone: string | null,
    public readonly itemCount: number,
    public readonly totalQuantity: number,
    public readonly totalAmount: number,
    public readonly status: 'draft' | 'issued' | 'paid' | 'cancelled',
    public readonly currencySymbol: string,
    public readonly paymentMethod: 'cash' | 'card' | 'bank' | 'transfer' | string = 'cash',
    public readonly paymentStatus: 'paid' | 'pending' | 'cancelled' | string = 'pending'
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
   */
  get formattedDate(): string {
    if (!this.invoiceDate) {
      return 'Invalid Date';
    }

    try {
      // Use Korean locale to match backup format: "2025. 10. 25."
      return new Date(this.invoiceDate).toLocaleDateString('ko-KR', {
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
   * Get payment badge class for styling
   */
  get paymentBadgeClass(): string {
    return this.paymentStatus === 'paid' ? 'payment-paid' : 'payment-pending';
  }
}
