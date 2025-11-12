/**
 * CashEndingValidator
 * Validation rules for cash ending operations
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class CashEndingValidator {
  /**
   * Validate actual balance amount
   */
  static validateActualBalance(actualBalance: number): ValidationError | null {
    if (actualBalance === null || actualBalance === undefined) {
      return { field: 'actualBalance', message: 'Actual balance is required' };
    }

    if (typeof actualBalance !== 'number' || isNaN(actualBalance)) {
      return { field: 'actualBalance', message: 'Actual balance must be a valid number' };
    }

    if (actualBalance < 0) {
      return { field: 'actualBalance', message: 'Actual balance cannot be negative' };
    }

    return null;
  }

  /**
   * Validate expected balance amount
   */
  static validateExpectedBalance(expectedBalance: number): ValidationError | null {
    if (expectedBalance === null || expectedBalance === undefined) {
      return { field: 'expectedBalance', message: 'Expected balance is required' };
    }

    if (typeof expectedBalance !== 'number' || isNaN(expectedBalance)) {
      return { field: 'expectedBalance', message: 'Expected balance must be a valid number' };
    }

    return null;
  }

  /**
   * Validate difference threshold
   */
  static validateDifference(
    difference: number,
    threshold: number = 0.01
  ): ValidationError | null {
    if (difference === null || difference === undefined) {
      return { field: 'difference', message: 'Difference is required' };
    }

    if (typeof difference !== 'number' || isNaN(difference)) {
      return { field: 'difference', message: 'Difference must be a valid number' };
    }

    // Warning if difference exceeds threshold
    if (Math.abs(difference) > threshold) {
      return {
        field: 'difference',
        message: `Difference exceeds threshold: ${Math.abs(difference).toFixed(2)}`,
      };
    }

    return null;
  }

  /**
   * Validate cash location ID
   */
  static validateLocationId(locationId: string): ValidationError | null {
    if (!locationId || locationId.trim() === '') {
      return { field: 'locationId', message: 'Cash location ID is required' };
    }

    return null;
  }

  /**
   * Validate date format
   */
  static validateDate(date: string): ValidationError | null {
    if (!date || date.trim() === '') {
      return { field: 'date', message: 'Date is required' };
    }

    const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
    if (!dateRegex.test(date)) {
      return { field: 'date', message: 'Date must be in YYYY-MM-DD format' };
    }

    const parsedDate = new Date(date);
    if (isNaN(parsedDate.getTime())) {
      return { field: 'date', message: 'Invalid date' };
    }

    return null;
  }

  /**
   * Validate complete cash ending data
   */
  static validateCashEnding(data: {
    locationId: string;
    expectedBalance: number;
    actualBalance: number;
    date: string;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    const locationError = this.validateLocationId(data.locationId);
    if (locationError) errors.push(locationError);

    const expectedError = this.validateExpectedBalance(data.expectedBalance);
    if (expectedError) errors.push(expectedError);

    const actualError = this.validateActualBalance(data.actualBalance);
    if (actualError) errors.push(actualError);

    const dateError = this.validateDate(data.date);
    if (dateError) errors.push(dateError);

    return errors;
  }

  /**
   * Check if difference requires attention
   */
  static requiresAttention(difference: number, threshold: number = 100): boolean {
    return Math.abs(difference) > threshold;
  }

  /**
   * Validate balance is balanced (within tolerance)
   */
  static isBalanced(difference: number, tolerance: number = 0.01): boolean {
    return Math.abs(difference) < tolerance;
  }
}
