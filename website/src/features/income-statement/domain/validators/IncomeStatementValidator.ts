/**
 * Income Statement Validator
 * Domain layer - Validation rules for income statement operations
 *
 * Following ARCHITECTURE.md pattern: validators define rules (static methods),
 * presentation layer (hooks/components) executes validation.
 */

export interface ValidationError {
  field: string;
  message: string;
}

export interface ValidationResult {
  isValid: boolean;
  errors: ValidationError[];
}

export class IncomeStatementValidator {
  /**
   * Validate company ID format (UUID)
   * @param companyId - Company identifier
   * @returns ValidationResult with errors if invalid
   */
  static validateCompanyId(companyId: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!companyId || companyId.trim() === '') {
      errors.push({
        field: 'companyId',
        message: 'Company ID is required',
      });
      return { isValid: false, errors };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(companyId)) {
      errors.push({
        field: 'companyId',
        message: 'Invalid company ID format',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate store ID format (UUID, optional)
   * @param storeId - Store identifier (can be null for "All Stores")
   * @returns ValidationResult with errors if invalid
   */
  static validateStoreId(storeId: string | null): ValidationResult {
    const errors: ValidationError[] = [];

    // Store ID is optional (null means "All Stores")
    if (storeId === null || storeId === '') {
      return { isValid: true, errors };
    }

    // If provided, validate UUID format
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(storeId)) {
      errors.push({
        field: 'storeId',
        message: 'Invalid store ID format',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate date format (YYYY-MM-DD)
   * @param date - Date string to validate
   * @param fieldName - Name of the field for error messages
   * @returns ValidationResult with errors if invalid
   */
  static validateDateFormat(date: string, fieldName: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!date || date.trim() === '') {
      errors.push({
        field: fieldName,
        message: `${fieldName} is required`,
      });
      return { isValid: false, errors };
    }

    // YYYY-MM-DD format validation
    const dateRegex = /^\d{4}-(0[1-9]|1[0-2])-(0[1-9]|[12]\d|3[01])$/;
    if (!dateRegex.test(date)) {
      errors.push({
        field: fieldName,
        message: `Invalid ${fieldName} format. Expected YYYY-MM-DD`,
      });
      return { isValid: false, errors };
    }

    // Check if it's a valid date
    const dateObj = new Date(date);
    if (isNaN(dateObj.getTime())) {
      errors.push({
        field: fieldName,
        message: `Invalid ${fieldName}`,
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate date range
   * @param fromDate - Start date (YYYY-MM-DD)
   * @param toDate - End date (YYYY-MM-DD)
   * @returns ValidationResult with errors if invalid
   */
  static validateDateRange(fromDate: string, toDate: string): ValidationResult {
    const errors: ValidationError[] = [];

    // Validate individual dates first
    const fromResult = this.validateDateFormat(fromDate, 'fromDate');
    const toResult = this.validateDateFormat(toDate, 'toDate');

    if (!fromResult.isValid) {
      errors.push(...fromResult.errors);
    }
    if (!toResult.isValid) {
      errors.push(...toResult.errors);
    }

    // If individual dates are invalid, return early
    if (errors.length > 0) {
      return { isValid: false, errors };
    }

    // Check if from date is before to date
    const from = new Date(fromDate);
    const to = new Date(toDate);

    if (from > to) {
      errors.push({
        field: 'dateRange',
        message: 'From date must be before or equal to date',
      });
    }

    // Check date range is not too large (max 12 months)
    const daysDiff = Math.abs((to.getTime() - from.getTime()) / (1000 * 60 * 60 * 24));
    if (daysDiff > 366) { // 366 to account for leap years
      errors.push({
        field: 'dateRange',
        message: 'Date range cannot exceed 12 months',
      });
    }

    // Note: Removed future date restriction to allow RPC to handle date parameters
    // RPC calls should receive dates as-is without frontend validation restrictions

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate income statement type
   * @param type - Income statement type ('monthly' or '12month')
   * @returns ValidationResult with errors if invalid
   */
  static validateStatementType(type: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!type || type.trim() === '') {
      errors.push({
        field: 'type',
        message: 'Income statement type is required',
      });
      return { isValid: false, errors };
    }

    if (!['monthly', '12month'].includes(type)) {
      errors.push({
        field: 'type',
        message: 'Invalid income statement type. Must be "monthly" or "12month"',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate complete income statement query
   * Validates all required fields for querying income statement data
   *
   * @param companyId - Company identifier (UUID)
   * @param storeId - Store identifier (UUID, optional)
   * @param fromDate - Start date (YYYY-MM-DD)
   * @param toDate - End date (YYYY-MM-DD)
   * @param type - Statement type ('monthly' or '12month')
   * @returns ValidationResult with all errors if invalid
   */
  static validateQuery(
    companyId: string,
    storeId: string | null,
    fromDate: string,
    toDate: string,
    type: 'monthly' | '12month'
  ): ValidationResult {
    const errors: ValidationError[] = [];

    // Validate company ID
    const companyResult = this.validateCompanyId(companyId);
    if (!companyResult.isValid) {
      errors.push(...companyResult.errors);
    }

    // Validate store ID (optional)
    const storeResult = this.validateStoreId(storeId);
    if (!storeResult.isValid) {
      errors.push(...storeResult.errors);
    }

    // Validate date range
    const dateRangeResult = this.validateDateRange(fromDate, toDate);
    if (!dateRangeResult.isValid) {
      errors.push(...dateRangeResult.errors);
    }

    // Validate statement type
    const typeResult = this.validateStatementType(type);
    if (!typeResult.isValid) {
      errors.push(...typeResult.errors);
    }

    // Note: 12-month view (get_income_statement_monthly_v2) now supports any date range
    // The RPC will return monthly breakdown for the selected period
    // No additional date range restriction needed

    return {
      isValid: errors.length === 0,
      errors,
    };
  }
}
