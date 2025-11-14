/**
 * Salary Validator
 * Domain layer - Validation rules for salary operations
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class SalaryValidator {
  /**
   * Validate company ID format (UUID)
   * @param companyId - Company identifier
   * @returns Array of validation errors (empty if valid)
   */
  static validateCompanyId(companyId: string): ValidationError[] {
    const errors: ValidationError[] = [];

    if (!companyId || companyId.trim() === '') {
      errors.push({
        field: 'companyId',
        message: 'Company ID is required',
      });
      return errors;
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(companyId)) {
      errors.push({
        field: 'companyId',
        message: 'Invalid company ID format',
      });
    }

    return errors;
  }

  /**
   * Validate month format (YYYY-MM)
   * @param month - Month in YYYY-MM format
   * @returns Array of validation errors (empty if valid)
   */
  static validateMonthFormat(month: string): ValidationError[] {
    const errors: ValidationError[] = [];

    if (!month || month.trim() === '') {
      errors.push({
        field: 'month',
        message: 'Month is required',
      });
      return errors;
    }

    // YYYY-MM format validation
    const monthRegex = /^\d{4}-(0[1-9]|1[0-2])$/;
    if (!monthRegex.test(month)) {
      errors.push({
        field: 'month',
        message: 'Invalid month format. Expected YYYY-MM (e.g., 2025-11)',
      });
      return errors;
    }

    // Validate date is not in the future
    const [year, monthNum] = month.split('-').map(Number);
    const inputDate = new Date(year, monthNum - 1, 1);
    const now = new Date();
    const currentMonth = new Date(now.getFullYear(), now.getMonth(), 1);

    if (inputDate > currentMonth) {
      errors.push({
        field: 'month',
        message: 'Cannot query future months',
      });
    }

    // Validate date is not too old (e.g., max 5 years back)
    const fiveYearsAgo = new Date(now.getFullYear() - 5, now.getMonth(), 1);
    if (inputDate < fiveYearsAgo) {
      errors.push({
        field: 'month',
        message: 'Cannot query data older than 5 years',
      });
    }

    return errors;
  }

  /**
   * Validate salary data query parameters
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   * @returns Array of validation errors (empty if valid)
   */
  static validateSalaryQuery(companyId: string, month: string): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate company ID
    const companyErrors = this.validateCompanyId(companyId);
    errors.push(...companyErrors);

    // Validate month format
    const monthErrors = this.validateMonthFormat(month);
    errors.push(...monthErrors);

    return errors;
  }

  /**
   * Validate Excel export parameters
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   * @param companyName - Company name for filename
   * @param storeName - Store name for filename
   * @returns Array of validation errors (empty if valid)
   */
  static validateExcelExport(
    companyId: string,
    month: string,
    companyName: string,
    storeName: string
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate query parameters
    const queryErrors = this.validateSalaryQuery(companyId, month);
    errors.push(...queryErrors);

    // Validate filename components
    if (!companyName || companyName.trim() === '') {
      errors.push({
        field: 'companyName',
        message: 'Company name is required for export',
      });
    } else if (companyName.length > 100) {
      errors.push({
        field: 'companyName',
        message: 'Company name is too long (max 100 characters)',
      });
    }

    if (!storeName || storeName.trim() === '') {
      errors.push({
        field: 'storeName',
        message: 'Store name is required for export',
      });
    } else if (storeName.length > 100) {
      errors.push({
        field: 'storeName',
        message: 'Store name is too long (max 100 characters)',
      });
    }

    return errors;
  }

  /**
   * Validate store ID (optional parameter)
   * @param storeId - Store identifier (can be null for "All Stores")
   * @returns Array of validation errors (empty if valid)
   */
  static validateStoreId(storeId: string | null): ValidationError[] {
    const errors: ValidationError[] = [];

    // Store ID is optional (null means "All Stores")
    if (storeId === null || storeId === '') {
      return errors;
    }

    // If provided, validate UUID format
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(storeId)) {
      errors.push({
        field: 'storeId',
        message: 'Invalid store ID format',
      });
    }

    return errors;
  }
}
