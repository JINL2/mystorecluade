/**
 * CashEndingJournalValidator
 * Validation rules for cash ending journal entry creation
 */

import { ValidationError } from './CashEndingValidator';

export interface CreateJournalParams {
  companyId: string;
  userId: string;
  storeId: string | null;
  cashLocationId: string;
  difference: number;
  type: 'error' | 'exchange';
}

export class CashEndingJournalValidator {
  /**
   * Validate company ID
   */
  static validateCompanyId(companyId: string): ValidationError | null {
    if (!companyId || companyId.trim() === '') {
      return { field: 'companyId', message: 'Company ID is required' };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(companyId)) {
      return { field: 'companyId', message: 'Company ID must be a valid UUID' };
    }

    return null;
  }

  /**
   * Validate user ID
   */
  static validateUserId(userId: string): ValidationError | null {
    if (!userId || userId.trim() === '') {
      return { field: 'userId', message: 'User ID is required' };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(userId)) {
      return { field: 'userId', message: 'User ID must be a valid UUID' };
    }

    return null;
  }

  /**
   * Validate cash location ID
   */
  static validateCashLocationId(cashLocationId: string): ValidationError | null {
    if (!cashLocationId || cashLocationId.trim() === '') {
      return { field: 'cashLocationId', message: 'Cash location ID is required' };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(cashLocationId)) {
      return { field: 'cashLocationId', message: 'Cash location ID must be a valid UUID' };
    }

    return null;
  }

  /**
   * Validate difference amount
   */
  static validateDifference(difference: number): ValidationError | null {
    if (difference === null || difference === undefined) {
      return { field: 'difference', message: 'Difference amount is required' };
    }

    if (typeof difference !== 'number' || isNaN(difference)) {
      return { field: 'difference', message: 'Difference must be a valid number' };
    }

    if (difference === 0) {
      return { field: 'difference', message: 'Difference cannot be zero' };
    }

    return null;
  }

  /**
   * Validate journal entry type
   */
  static validateType(type: string): ValidationError | null {
    if (!type || type.trim() === '') {
      return { field: 'type', message: 'Journal entry type is required' };
    }

    if (type !== 'error' && type !== 'exchange') {
      return { field: 'type', message: 'Type must be either "error" or "exchange"' };
    }

    return null;
  }

  /**
   * Validate account ID
   */
  static validateAccountId(accountId: string, fieldName: string = 'accountId'): ValidationError | null {
    if (!accountId || accountId.trim() === '') {
      return { field: fieldName, message: `${fieldName} is required` };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(accountId)) {
      return { field: fieldName, message: `${fieldName} must be a valid UUID` };
    }

    return null;
  }

  /**
   * Validate complete journal entry parameters
   */
  static validateJournalParams(params: CreateJournalParams): ValidationError[] {
    const errors: ValidationError[] = [];

    const companyIdError = this.validateCompanyId(params.companyId);
    if (companyIdError) errors.push(companyIdError);

    const userIdError = this.validateUserId(params.userId);
    if (userIdError) errors.push(userIdError);

    const cashLocationIdError = this.validateCashLocationId(params.cashLocationId);
    if (cashLocationIdError) errors.push(cashLocationIdError);

    const differenceError = this.validateDifference(params.difference);
    if (differenceError) errors.push(differenceError);

    const typeError = this.validateType(params.type);
    if (typeError) errors.push(typeError);

    return errors;
  }

  /**
   * Validate journal line data
   */
  static validateJournalLine(line: {
    account_id: string;
    description: string;
    debit: number;
    credit: number;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    const accountIdError = this.validateAccountId(line.account_id, 'account_id');
    if (accountIdError) errors.push(accountIdError);

    if (!line.description || line.description.trim() === '') {
      errors.push({ field: 'description', message: 'Description is required' });
    }

    if (typeof line.debit !== 'number' || isNaN(line.debit) || line.debit < 0) {
      errors.push({ field: 'debit', message: 'Debit must be a non-negative number' });
    }

    if (typeof line.credit !== 'number' || isNaN(line.credit) || line.credit < 0) {
      errors.push({ field: 'credit', message: 'Credit must be a non-negative number' });
    }

    // Debit and credit cannot both be non-zero
    if (line.debit > 0 && line.credit > 0) {
      errors.push({
        field: 'debit_credit',
        message: 'A line cannot have both debit and credit amounts',
      });
    }

    // At least one must be non-zero
    if (line.debit === 0 && line.credit === 0) {
      errors.push({
        field: 'debit_credit',
        message: 'Either debit or credit must be greater than zero',
      });
    }

    return errors;
  }

  /**
   * Check if journal entry is balanced
   */
  static isBalanced(lines: Array<{ debit: number; credit: number }>): boolean {
    const totalDebit = lines.reduce((sum, line) => sum + line.debit, 0);
    const totalCredit = lines.reduce((sum, line) => sum + line.credit, 0);

    // Allow small floating point difference
    return Math.abs(totalDebit - totalCredit) < 0.01;
  }
}
