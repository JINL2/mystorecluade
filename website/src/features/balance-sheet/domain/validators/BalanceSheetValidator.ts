/**
 * BalanceSheetValidator
 * Validation rules for balance sheet operations
 *
 * Following Clean Architecture:
 * - Domain layer defines validation RULES (static methods)
 * - Presentation layer EXECUTES validation (in hooks)
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class BalanceSheetValidator {
  /**
   * Validate company ID
   */
  static validateCompanyId(companyId: string | null | undefined): ValidationError | null {
    if (!companyId || companyId.trim() === '') {
      return {
        field: 'companyId',
        message: 'Company ID is required',
      };
    }
    return null;
  }

  /**
   * Validate store ID (optional but must be valid if provided)
   */
  static validateStoreId(storeId: string | null | undefined): ValidationError | null {
    // Store ID is optional, so null is valid
    if (storeId === null || storeId === undefined) {
      return null;
    }

    // If provided, must not be empty string
    if (storeId.trim() === '') {
      return {
        field: 'storeId',
        message: 'Store ID cannot be empty string',
      };
    }

    return null;
  }

  /**
   * Validate date format (YYYY-MM-DD)
   */
  static validateDateFormat(date: string | null | undefined): ValidationError | null {
    // Date is optional
    if (!date) {
      return null;
    }

    // Check format YYYY-MM-DD
    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
      return {
        field: 'date',
        message: 'Date must be in YYYY-MM-DD format',
      };
    }

    // Check if valid date
    const parsedDate = new Date(date);
    if (isNaN(parsedDate.getTime())) {
      return {
        field: 'date',
        message: 'Invalid date value',
      };
    }

    return null;
  }

  /**
   * Validate date range (start date must be before or equal to end date)
   */
  static validateDateRange(
    startDate: string | null | undefined,
    endDate: string | null | undefined
  ): ValidationError | null {
    // Both dates are optional
    if (!startDate || !endDate) {
      return null;
    }

    // Validate individual date formats first
    const startDateError = this.validateDateFormat(startDate);
    if (startDateError) {
      return {
        field: 'startDate',
        message: startDateError.message,
      };
    }

    const endDateError = this.validateDateFormat(endDate);
    if (endDateError) {
      return {
        field: 'endDate',
        message: endDateError.message,
      };
    }

    // Check range logic
    const start = new Date(startDate);
    const end = new Date(endDate);

    if (start > end) {
      return {
        field: 'dateRange',
        message: 'Start date must be before or equal to end date',
      };
    }

    return null;
  }

  /**
   * Validate date is not in future
   */
  static validateDateNotFuture(date: string | null | undefined): ValidationError | null {
    if (!date) {
      return null;
    }

    const parsedDate = new Date(date);
    const today = new Date();
    today.setHours(0, 0, 0, 0);

    if (parsedDate > today) {
      return {
        field: 'date',
        message: 'Date cannot be in the future',
      };
    }

    return null;
  }

  /**
   * Validate balance sheet filters (composite validation)
   */
  static validateFilters(filters: {
    companyId: string;
    storeId: string | null;
    startDate: string | null;
    endDate: string | null;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate company ID (required)
    const companyError = this.validateCompanyId(filters.companyId);
    if (companyError) errors.push(companyError);

    // Validate store ID (optional)
    const storeError = this.validateStoreId(filters.storeId);
    if (storeError) errors.push(storeError);

    // Validate start date format
    if (filters.startDate) {
      const startDateFormatError = this.validateDateFormat(filters.startDate);
      if (startDateFormatError) {
        errors.push({
          field: 'startDate',
          message: startDateFormatError.message,
        });
      }
    }

    // Validate end date format
    if (filters.endDate) {
      const endDateFormatError = this.validateDateFormat(filters.endDate);
      if (endDateFormatError) {
        errors.push({
          field: 'endDate',
          message: endDateFormatError.message,
        });
      }
    }

    // Validate date range
    const dateRangeError = this.validateDateRange(filters.startDate, filters.endDate);
    if (dateRangeError) errors.push(dateRangeError);

    return errors;
  }

  /**
   * Validate balance sheet data integrity (business rule)
   * Check if Assets = Liabilities + Equity
   */
  static validateBalanceEquation(
    totalAssets: number,
    totalLiabilitiesAndEquity: number,
    tolerance: number = 0.01
  ): { valid: boolean; difference: number; message?: string } {
    const difference = Math.abs(totalAssets - totalLiabilitiesAndEquity);

    if (difference > tolerance) {
      return {
        valid: false,
        difference,
        message: `Balance sheet equation not satisfied. Assets (${totalAssets}) ≠ Liabilities + Equity (${totalLiabilitiesAndEquity}). Difference: ${difference.toFixed(2)}`,
      };
    }

    return {
      valid: true,
      difference,
    };
  }

  /**
   * Validate that totals match sum of sections
   */
  static validateTotalConsistency(
    total: number,
    sectionTotals: number[],
    tolerance: number = 0.01
  ): { valid: boolean; difference: number; message?: string } {
    const sumOfSections = sectionTotals.reduce((sum, value) => sum + value, 0);
    const difference = Math.abs(total - sumOfSections);

    if (difference > tolerance) {
      return {
        valid: false,
        difference,
        message: `Total (${total}) does not match sum of sections (${sumOfSections}). Difference: ${difference.toFixed(2)}`,
      };
    }

    return {
      valid: true,
      difference,
    };
  }
}
