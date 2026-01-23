/**
 * Schedule Validator
 * Domain layer - Validation rules for schedule operations
 */

export interface ValidationError {
  field: string;
  message: string;
}

export class ScheduleValidator {
  /**
   * Validate schedule assignment creation
   * @param data - Assignment data to validate
   * @returns Array of validation errors (empty if valid)
   */
  static validateAssignment(data: {
    shiftId: string;
    employeeId: string;
    date: string;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate shift selection
    if (!data.shiftId || !data.shiftId.trim()) {
      errors.push({
        field: 'shiftId',
        message: 'Please select a shift',
      });
    }

    // Validate employee selection
    if (!data.employeeId || !data.employeeId.trim()) {
      errors.push({
        field: 'employeeId',
        message: 'Please select an employee',
      });
    }

    // Validate date
    if (!data.date || !data.date.trim()) {
      errors.push({
        field: 'date',
        message: 'Date is required',
      });
    } else {
      // Validate date format (YYYY-MM-DD)
      const dateRegex = /^\d{4}-\d{2}-\d{2}$/;
      if (!dateRegex.test(data.date)) {
        errors.push({
          field: 'date',
          message: 'Invalid date format (expected YYYY-MM-DD)',
        });
      } else {
        // Validate date is not in the past (optional, can be removed if past dates are allowed)
        const selectedDate = new Date(data.date);
        const today = new Date();
        today.setHours(0, 0, 0, 0);

        if (selectedDate < today) {
          errors.push({
            field: 'date',
            message: 'Cannot create assignment for past dates',
          });
        }
      }
    }

    return errors;
  }

  /**
   * Validate date range for schedule queries
   * @param startDate - Start date (YYYY-MM-DD)
   * @param endDate - End date (YYYY-MM-DD)
   * @returns Array of validation errors (empty if valid)
   */
  static validateDateRange(startDate: string, endDate: string): ValidationError[] {
    const errors: ValidationError[] = [];

    if (!startDate || !startDate.trim()) {
      errors.push({
        field: 'startDate',
        message: 'Start date is required',
      });
    }

    if (!endDate || !endDate.trim()) {
      errors.push({
        field: 'endDate',
        message: 'End date is required',
      });
    }

    if (startDate && endDate) {
      const start = new Date(startDate);
      const end = new Date(endDate);

      if (start > end) {
        errors.push({
          field: 'dateRange',
          message: 'Start date must be before or equal to end date',
        });
      }

      // Validate maximum range (e.g., 90 days)
      const daysDiff = Math.floor((end.getTime() - start.getTime()) / (1000 * 60 * 60 * 24));
      if (daysDiff > 90) {
        errors.push({
          field: 'dateRange',
          message: 'Date range cannot exceed 90 days',
        });
      }
    }

    return errors;
  }

  /**
   * Validate company and store IDs
   * @param companyId - Company identifier
   * @param storeId - Store identifier
   * @returns Array of validation errors (empty if valid)
   */
  static validateContext(companyId: string, storeId: string): ValidationError[] {
    const errors: ValidationError[] = [];

    if (!companyId || !companyId.trim()) {
      errors.push({
        field: 'companyId',
        message: 'Company ID is required',
      });
    }

    if (!storeId || !storeId.trim()) {
      errors.push({
        field: 'storeId',
        message: 'Store ID is required',
      });
    }

    return errors;
  }
}
