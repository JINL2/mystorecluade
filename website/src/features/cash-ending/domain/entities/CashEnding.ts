/**
 * CashEnding Entity
 * Represents cash ending data for a specific location and date
 */

export class CashEnding {
  constructor(
    public readonly cashEndingId: string,
    public readonly locationId: string,
    public readonly locationName: string,
    public readonly storeId: string | null,
    public readonly date: string,
    public readonly openingBalance: number,
    public readonly totalInflow: number,
    public readonly totalOutflow: number,
    public readonly expectedBalance: number,
    public readonly actualBalance: number,
    public readonly difference: number,
    public readonly status: 'pending' | 'completed' | 'verified',
    public readonly currencySymbol: string
  ) {}

  /**
   * Check if cash ending is balanced
   */
  get isBalanced(): boolean {
    return Math.abs(this.difference) < 0.01;
  }

  /**
   * Get status display
   */
  get statusDisplay(): string {
    switch (this.status) {
      case 'pending':
        return 'Pending';
      case 'completed':
        return 'Completed';
      case 'verified':
        return 'Verified';
      default:
        return this.status;
    }
  }

  /**
   * Format currency amount
   */
  formatCurrency(amount: number): string {
    return `${this.currencySymbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get formatted date
   */
  get formattedDate(): string {
    return new Date(this.date).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'long',
      day: 'numeric',
    });
  }
}
