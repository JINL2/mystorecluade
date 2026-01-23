/**
 * JournalEntryValidator
 * Validation rules for journal entries and transaction lines
 */

import { JournalEntry } from '../entities/JournalEntry';
import { TransactionLine } from '../entities/TransactionLine';
import type { ValidationError } from '../types/ValidationTypes';

export class JournalEntryValidator {
  /**
   * Validate a single transaction line
   */
  static validateTransactionLine(line: TransactionLine): ValidationError | null {
    if (!line.accountId || line.accountId.trim() === '') {
      return { field: 'accountId', message: 'Account is required' };
    }

    if (line.amount <= 0) {
      return { field: 'amount', message: 'Amount must be greater than 0' };
    }

    if (isNaN(line.amount)) {
      return { field: 'amount', message: 'Amount must be a valid number' };
    }

    // Validate cash location for cash accounts
    if (line.categoryTag === 'cash' && !line.cashLocationId) {
      return { field: 'cashLocationId', message: 'Cash location is required for cash accounts' };
    }

    return null;
  }

  /**
   * Validate a complete journal entry
   */
  static validateJournalEntry(entry: JournalEntry): ValidationError[] {
    const errors: ValidationError[] = [];

    // Check minimum transaction lines
    if (entry.transactionLines.length < 2) {
      errors.push({
        field: 'transactionLines',
        message: 'At least 2 transaction lines are required',
      });
    }

    // Check if balanced
    if (!entry.isBalanced) {
      errors.push({
        field: 'balance',
        message: `Debits (${entry.totalDebits}) must equal credits (${entry.totalCredits})`,
      });
    }

    // Check date
    if (!entry.date || entry.date.trim() === '') {
      errors.push({
        field: 'date',
        message: 'Journal date is required',
      });
    }

    // Validate each transaction line
    entry.transactionLines.forEach((line, index) => {
      const lineError = this.validateTransactionLine(line);
      if (lineError) {
        errors.push({
          field: `transactionLine[${index}].${lineError.field}`,
          message: `Line ${index + 1}: ${lineError.message}`,
        });
      }
    });

    return errors;
  }

  /**
   * Check if journal entry can be submitted
   */
  static canSubmit(entry: JournalEntry): boolean {
    const errors = this.validateJournalEntry(entry);
    return errors.length === 0;
  }

  /**
   * Validate transaction form data before creating TransactionLine
   */
  static validateTransactionFormData(data: {
    accountId: string;
    amount: number;
    categoryTag?: string;
    cashLocationId?: string;
  }): ValidationError | null {
    if (!data.accountId || data.accountId.trim() === '') {
      return { field: 'accountId', message: 'Please select an account' };
    }

    if (!data.amount || data.amount <= 0) {
      return { field: 'amount', message: 'Please enter an amount greater than 0' };
    }

    if (isNaN(data.amount)) {
      return { field: 'amount', message: 'Please enter a valid number' };
    }

    // Validate cash location for cash accounts
    if (data.categoryTag === 'cash' && !data.cashLocationId) {
      return {
        field: 'cashLocationId',
        message: 'Please select a cash location for cash accounts',
      };
    }

    return null;
  }
}
