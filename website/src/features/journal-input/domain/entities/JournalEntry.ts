/**
 * JournalEntry Entity
 * Represents a complete journal entry with multiple transaction lines
 */

import { TransactionLine } from './TransactionLine';

export class JournalEntry {
  constructor(
    public readonly companyId: string,
    public readonly storeId: string | null,
    public readonly date: string,
    public readonly transactionLines: TransactionLine[]
  ) {}

  /**
   * Calculate total debits
   */
  get totalDebits(): number {
    return this.transactionLines
      .filter((line) => line.isDebit)
      .reduce((sum, line) => sum + line.amount, 0);
  }

  /**
   * Calculate total credits
   */
  get totalCredits(): number {
    return this.transactionLines
      .filter((line) => !line.isDebit)
      .reduce((sum, line) => sum + line.amount, 0);
  }

  /**
   * Count debit entries
   */
  get debitCount(): number {
    return this.transactionLines.filter((line) => line.isDebit).length;
  }

  /**
   * Count credit entries
   */
  get creditCount(): number {
    return this.transactionLines.filter((line) => !line.isDebit).length;
  }

  /**
   * Calculate difference (should be 0 for balanced entry)
   */
  get difference(): number {
    return this.totalDebits - this.totalCredits;
  }

  /**
   * Check if journal entry is balanced
   */
  get isBalanced(): boolean {
    return Math.abs(this.difference) < 0.01;
  }

  /**
   * Check if journal entry can be submitted
   */
  canSubmit(): boolean {
    return (
      this.isBalanced &&
      this.transactionLines.length >= 2 &&
      this.transactionLines.every((line) => line.isValid)
    );
  }

  /**
   * Add transaction line
   */
  addTransactionLine(line: TransactionLine): JournalEntry {
    return new JournalEntry(
      this.companyId,
      this.storeId,
      this.date,
      [...this.transactionLines, line]
    );
  }

  /**
   * Update transaction line at index
   */
  updateTransactionLine(index: number, line: TransactionLine): JournalEntry {
    const newLines = [...this.transactionLines];
    newLines[index] = line;
    return new JournalEntry(
      this.companyId,
      this.storeId,
      this.date,
      newLines
    );
  }

  /**
   * Remove transaction line at index
   */
  removeTransactionLine(index: number): JournalEntry {
    const newLines = this.transactionLines.filter((_, i) => i !== index);
    return new JournalEntry(
      this.companyId,
      this.storeId,
      this.date,
      newLines
    );
  }
}
