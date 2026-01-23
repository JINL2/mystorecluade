/**
 * TransactionFilterValidator
 * Validation rules for transaction filter inputs
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class TransactionFilterValidator {
  /**
   * Validate date string format (YYYY-MM-DD)
   */
  static validateDateFormat(date: string): ValidationError | null {
    if (!date || date.trim() === '') {
      return { field: 'date', message: 'Date is required' };
    }

    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
      return { field: 'date', message: 'Invalid date format. Use YYYY-MM-DD' };
    }

    // Check if date is valid
    const dateObj = new Date(date);
    if (isNaN(dateObj.getTime())) {
      return { field: 'date', message: 'Invalid date' };
    }

    return null;
  }

  /**
   * Validate date range (fromDate should be before toDate)
   */
  static validateDateRange(fromDate: string, toDate: string): ValidationError | null {
    // First validate individual dates
    const fromError = this.validateDateFormat(fromDate);
    if (fromError) return fromError;

    const toError = this.validateDateFormat(toDate);
    if (toError) return toError;

    // Check range
    const from = new Date(fromDate);
    const to = new Date(toDate);

    if (from > to) {
      return {
        field: 'dateRange',
        message: 'From date must be before or equal to To date',
      };
    }

    // Check if range is too large (optional: prevent performance issues)
    const daysDiff = Math.floor((to.getTime() - from.getTime()) / (1000 * 60 * 60 * 24));
    const maxDaysRange = 365; // 1 year maximum

    if (daysDiff > maxDaysRange) {
      return {
        field: 'dateRange',
        message: `Date range cannot exceed ${maxDaysRange} days`,
      };
    }

    return null;
  }

  /**
   * Validate store ID (optional field)
   */
  static validateStoreId(storeId: string | null): ValidationError | null {
    // Store ID is optional, so null is valid
    if (storeId === null || storeId === '') {
      return null;
    }

    // Check if it's a valid UUID format (Supabase uses UUID)
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(storeId)) {
      return { field: 'storeId', message: 'Invalid store ID format' };
    }

    return null;
  }

  /**
   * Validate account ID (optional field)
   */
  static validateAccountId(accountId: string | null): ValidationError | null {
    // Account ID is optional, so null is valid
    if (accountId === null || accountId === '') {
      return null;
    }

    // Check if it's a valid UUID format
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(accountId)) {
      return { field: 'accountId', message: 'Invalid account ID format' };
    }

    return null;
  }

  /**
   * Validate company ID (required)
   */
  static validateCompanyId(companyId: string): ValidationError | null {
    if (!companyId || companyId.trim() === '') {
      return { field: 'companyId', message: 'Company ID is required' };
    }

    // Check if it's a valid UUID format
    const uuidRegex =
      /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(companyId)) {
      return { field: 'companyId', message: 'Invalid company ID format' };
    }

    return null;
  }

  /**
   * Validate complete transaction filter
   * Returns array of validation errors
   */
  static validateTransactionFilter(
    companyId: string,
    storeId: string | null,
    fromDate: string,
    toDate: string,
    accountId?: string | null
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate company ID
    const companyError = this.validateCompanyId(companyId);
    if (companyError) errors.push(companyError);

    // Validate store ID
    const storeError = this.validateStoreId(storeId);
    if (storeError) errors.push(storeError);

    // Validate date range
    const dateRangeError = this.validateDateRange(fromDate, toDate);
    if (dateRangeError) errors.push(dateRangeError);

    // Validate account ID (if provided)
    if (accountId !== undefined) {
      const accountError = this.validateAccountId(accountId);
      if (accountError) errors.push(accountError);
    }

    return errors;
  }

  /**
   * Validate journal filter (allows null dates)
   */
  static validateJournalFilter(
    companyId: string,
    storeId: string | null,
    startDate: string | null,
    endDate: string | null
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate company ID (required)
    const companyError = this.validateCompanyId(companyId);
    if (companyError) errors.push(companyError);

    // Validate store ID (optional)
    const storeError = this.validateStoreId(storeId);
    if (storeError) errors.push(storeError);

    // If both dates are provided, validate range
    if (startDate && endDate) {
      const dateRangeError = this.validateDateRange(startDate, endDate);
      if (dateRangeError) errors.push(dateRangeError);
    }

    return errors;
  }
}
