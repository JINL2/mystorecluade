/**
 * Employee Validator
 * Domain layer - Validation rules for employee operations
 *
 * Following ARCHITECTURE.md pattern: validators define rules (static methods),
 * presentation layer (hooks/components) executes validation.
 */

export interface ValidationResult {
  isValid: boolean;
  error?: string;
}

export class EmployeeValidator {
  /**
   * Validate salary amount
   * @param amount - Salary amount to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateSalaryAmount(amount: number): ValidationResult {
    // Check if valid number
    if (isNaN(amount)) {
      return {
        isValid: false,
        error: 'Please enter a valid salary amount',
      };
    }

    // Check if non-negative
    if (amount < 0) {
      return {
        isValid: false,
        error: 'Salary amount cannot be negative',
      };
    }

    // Check if not zero (employees should have salary)
    if (amount === 0) {
      return {
        isValid: false,
        error: 'Salary amount must be greater than 0',
      };
    }

    // Reasonable salary range: 1 ~ 1,000,000,000
    if (amount > 1000000000) {
      return {
        isValid: false,
        error: 'Salary amount exceeds maximum limit (1,000,000,000)',
      };
    }

    return { isValid: true };
  }

  /**
   * Validate currency selection
   * @param currencyId - Currency ID to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateCurrencyId(currencyId: string): ValidationResult {
    if (!currencyId || currencyId.trim() === '') {
      return {
        isValid: false,
        error: 'Please select a currency',
      };
    }

    // UUID format validation (basic)
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(currencyId)) {
      return {
        isValid: false,
        error: 'Invalid currency ID format',
      };
    }

    return { isValid: true };
  }

  /**
   * Validate salary type
   * @param salaryType - Salary type to validate ('monthly' or 'hourly')
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateSalaryType(salaryType: string): ValidationResult {
    if (!salaryType || salaryType.trim() === '') {
      return {
        isValid: false,
        error: 'Please select a salary type',
      };
    }

    if (!['monthly', 'hourly'].includes(salaryType)) {
      return {
        isValid: false,
        error: 'Invalid salary type. Must be "monthly" or "hourly"',
      };
    }

    return { isValid: true };
  }

  /**
   * Validate employee email format
   * @param email - Email to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateEmail(email: string): ValidationResult {
    if (!email || email.trim() === '') {
      return {
        isValid: false,
        error: 'Email is required',
      };
    }

    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return {
        isValid: false,
        error: 'Invalid email format',
      };
    }

    return { isValid: true };
  }

  /**
   * Validate employee full name
   * @param fullName - Full name to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateFullName(fullName: string): ValidationResult {
    if (!fullName || fullName.trim() === '') {
      return {
        isValid: false,
        error: 'Full name is required',
      };
    }

    if (fullName.trim().length < 2) {
      return {
        isValid: false,
        error: 'Full name must be at least 2 characters',
      };
    }

    if (fullName.length > 100) {
      return {
        isValid: false,
        error: 'Full name must not exceed 100 characters',
      };
    }

    return { isValid: true };
  }

  /**
   * Validate complete salary update
   * Validates all required fields for updating employee salary
   *
   * @param salaryAmount - Salary amount (number)
   * @param currencyId - Currency ID (UUID)
   * @param salaryType - Salary type ('monthly' or 'hourly')
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateSalaryUpdate(
    salaryAmount: number,
    currencyId: string,
    salaryType: 'monthly' | 'hourly'
  ): ValidationResult {
    // Validate amount first (most critical)
    const amountResult = EmployeeValidator.validateSalaryAmount(salaryAmount);
    if (!amountResult.isValid) {
      return amountResult;
    }

    // Validate currency
    const currencyResult = EmployeeValidator.validateCurrencyId(currencyId);
    if (!currencyResult.isValid) {
      return currencyResult;
    }

    // Validate salary type
    const typeResult = EmployeeValidator.validateSalaryType(salaryType);
    if (!typeResult.isValid) {
      return typeResult;
    }

    return { isValid: true };
  }

  /**
   * Validate salary ID (for update operations)
   * @param salaryId - Salary ID to validate
   * @returns ValidationResult with isValid flag and error message if invalid
   */
  static validateSalaryId(salaryId: string): ValidationResult {
    if (!salaryId || salaryId.trim() === '') {
      return {
        isValid: false,
        error: 'Salary ID is required',
      };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(salaryId)) {
      return {
        isValid: false,
        error: 'Invalid salary ID format',
      };
    }

    return { isValid: true };
  }
}
