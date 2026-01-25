/**
 * Transaction Entity
 * Represents a financial transaction record
 */

export class Transaction {
  constructor(
    public readonly transactionId: string,
    public readonly date: string,
    public readonly accountName: string,
    public readonly description: string,
    public readonly debitAmount: number,
    public readonly creditAmount: number,
    public readonly balance: number,
    public readonly categoryTag: string | null,
    public readonly counterpartyName: string | null,
    public readonly currencySymbol: string
  ) {}

  /**
   * Get transaction type (debit or credit)
   */
  get transactionType(): 'debit' | 'credit' {
    return this.debitAmount > 0 ? 'debit' : 'credit';
  }

  /**
   * Get transaction amount (absolute value)
   */
  get amount(): number {
    return this.debitAmount > 0 ? this.debitAmount : this.creditAmount;
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
      month: 'short',
      day: 'numeric',
    });
  }

  /**
   * Get formatted category tag
   */
  get formattedCategoryTag(): string {
    if (!this.categoryTag) return '';
    switch (this.categoryTag.toLowerCase()) {
      case 'fixedasset':
        return 'Fixed Asset';
      default:
        return this.categoryTag.charAt(0).toUpperCase() + this.categoryTag.slice(1);
    }
  }
}
