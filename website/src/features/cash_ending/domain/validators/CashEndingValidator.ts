/**
 * CashEndingValidator
 * Validation rules for cash ending operations
 */

import type { LocationType } from '../entities/CashLocation';

export interface ValidationError {
  field: string;
  message: string;
}

export class CashEndingValidator {
  /**
   * Validate submit parameters
   */
  static validateSubmit(params: {
    companyId: string;
    storeId: string | null;
    locationId: string;
    locationType: LocationType;
    denomQuantities: Record<string, number>;
    bankAmounts: Record<string, number>;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    if (!params.companyId) {
      errors.push({ field: 'companyId', message: 'Company ID is required' });
    }

    if (!params.storeId) {
      errors.push({ field: 'storeId', message: 'Please select a store' });
    }

    if (!params.locationId) {
      errors.push({ field: 'locationId', message: 'Please select a cash location' });
    }

    if (params.locationType === 'bank') {
      const hasAmount = Object.values(params.bankAmounts).some(amt => amt > 0);
      if (!hasAmount) {
        errors.push({ field: 'bankAmounts', message: 'Please enter at least one bank amount' });
      }
    } else {
      const hasQuantity = Object.values(params.denomQuantities).some(qty => qty > 0);
      if (!hasQuantity) {
        errors.push({ field: 'denomQuantities', message: 'Please enter at least one denomination quantity' });
      }
    }

    return errors;
  }

  /**
   * Validate adjustment parameters
   */
  static validateAdjustment(params: {
    companyId: string;
    storeId: string | null;
    locationId: string;
    userId: string;
    difference: number;
    adjustmentType: 'error' | 'forex' | null;
  }): ValidationError[] {
    const errors: ValidationError[] = [];

    if (!params.companyId) {
      errors.push({ field: 'companyId', message: 'Company ID is required' });
    }

    if (!params.storeId) {
      errors.push({ field: 'storeId', message: 'Store ID is required' });
    }

    if (!params.locationId) {
      errors.push({ field: 'locationId', message: 'Location ID is required' });
    }

    if (!params.userId) {
      errors.push({ field: 'userId', message: 'User ID is required' });
    }

    if (params.difference === 0) {
      errors.push({ field: 'difference', message: 'No difference to adjust' });
    }

    if (!params.adjustmentType) {
      errors.push({ field: 'adjustmentType', message: 'Adjustment type is required' });
    }

    return errors;
  }

  /**
   * Validate denomination quantity
   */
  static validateQuantity(value: number): boolean {
    return Number.isInteger(value) && value >= 0;
  }

  /**
   * Validate bank amount
   */
  static validateBankAmount(value: number): boolean {
    return typeof value === 'number' && value >= 0 && isFinite(value);
  }
}
