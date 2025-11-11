/**
 * JournalEntry Entity
 * Represents a journal entry with multiple transaction lines
 */

export interface JournalLine {
  lineId: string;
  accountId: string;
  accountName: string;
  accountType: string;
  debit: number;
  credit: number;
  isDebit: boolean;
  description: string;
  counterparty?: {
    id: string;
    name: string;
    type: string;
  } | null;
  cashLocation?: {
    id: string;
    name: string;
    type: string;
  } | null;
  displayLocation: string;
  displayCounterparty: string;
}

export class JournalEntry {
  constructor(
    public readonly journalId: string,
    public readonly journalNumber: string,
    public readonly entryDate: string,
    public readonly createdAt: string,
    public readonly description: string,
    public readonly journalType: string,
    public readonly isDraft: boolean,
    public readonly storeId: string | null,
    public readonly storeName: string | null,
    public readonly storeCode: string | null,
    public readonly createdBy: string,
    public readonly createdByName: string,
    public readonly currencyCode: string,
    public readonly currencySymbol: string,
    public readonly totalDebit: number,
    public readonly totalCredit: number,
    public readonly totalAmount: number,
    public readonly lines: JournalLine[]
  ) {}

  /**
   * Get formatted entry date
   */
  get formattedDate(): string {
    return new Date(this.entryDate).toLocaleDateString('en-US', {
      year: 'numeric',
      month: 'short',
      day: 'numeric',
    });
  }

  /**
   * Get formatted creation time
   */
  get formattedTime(): string {
    return new Date(this.createdAt).toLocaleTimeString('en-US', {
      hour: '2-digit',
      minute: '2-digit',
    });
  }

  /**
   * Format currency amount
   */
  formatCurrency(amount: number): string {
    // If no currency symbol, return just the number
    if (!this.currencySymbol) {
      return amount.toLocaleString('en-US', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      });
    }

    // Normalize currency symbol (W → ₩)
    const symbol = this.currencySymbol === 'W' ? '₩' : this.currencySymbol;
    return `${symbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get sorted lines (debits first, then credits)
   */
  get sortedLines(): JournalLine[] {
    return [...this.lines].sort((a, b) => {
      if (a.isDebit && !b.isDebit) return -1;
      if (!a.isDebit && b.isDebit) return 1;
      return 0;
    });
  }
}
