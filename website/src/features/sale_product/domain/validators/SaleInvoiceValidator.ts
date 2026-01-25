/**
 * SaleInvoiceValidator
 * Validation rules for sale invoice
 */

import { SaleInvoice } from '../entities/SaleInvoice';

export interface ValidationError {
  field: string;
  message: string;
}

export class SaleInvoiceValidator {
  /**
   * Validate complete sale invoice
   */
  static validateInvoice(invoice: SaleInvoice): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate items
    if (!invoice.hasItems()) {
      errors.push({
        field: 'items',
        message: 'At least one product is required',
      });
    }

    // Validate cash location
    if (!invoice.hasCashLocation()) {
      errors.push({
        field: 'cashLocation',
        message: 'Cash location is required',
      });
    }

    // Validate discount
    const discountErrors = this.validateDiscount(
      invoice.discountType,
      invoice.discountValue,
      invoice.subtotal
    );
    errors.push(...discountErrors);

    // Validate company and store
    if (!invoice.companyId || invoice.companyId.trim().length === 0) {
      errors.push({
        field: 'companyId',
        message: 'Company ID is required',
      });
    }

    if (!invoice.storeId || invoice.storeId.trim().length === 0) {
      errors.push({
        field: 'storeId',
        message: 'Store ID is required',
      });
    }

    return errors;
  }

  /**
   * Validate discount value
   */
  static validateDiscount(
    discountType: 'amount' | 'percent',
    discountValue: number,
    subtotal: number
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    if (discountValue < 0) {
      errors.push({
        field: 'discount',
        message: 'Discount cannot be negative',
      });
      return errors;
    }

    if (discountType === 'percent') {
      if (discountValue > 100) {
        errors.push({
          field: 'discount',
          message: 'Discount percent cannot exceed 100%',
        });
      }
    } else {
      // Amount discount
      if (discountValue > subtotal) {
        errors.push({
          field: 'discount',
          message: 'Discount amount cannot exceed subtotal',
        });
      }
    }

    return errors;
  }

  /**
   * Validate cart items
   */
  static validateItems(itemCount: number): ValidationError | null {
    if (itemCount === 0) {
      return {
        field: 'items',
        message: 'At least one product is required',
      };
    }
    return null;
  }

  /**
   * Validate cash location selection
   */
  static validateCashLocation(cashLocationId: string): ValidationError | null {
    if (!cashLocationId || cashLocationId.trim().length === 0) {
      return {
        field: 'cashLocation',
        message: 'Cash location is required',
      };
    }
    return null;
  }
}
