/**
 * OrderValidator
 * Domain validation rules for order creation and management
 * Contains static methods that define validation logic (no execution)
 */

import { OrderItem } from '../entities/Order';

export interface ValidationError {
  field: string;
  message: string;
}

/**
 * Supplier information for validation
 */
export interface SupplierInfo {
  name: string;
  contact?: string;
  phone?: string;
  email?: string;
  address?: string;
  bank_account?: string;
  memo?: string;
}

/**
 * OrderValidator - Static validation rules
 */
export class OrderValidator {
  /**
   * Validate order date
   */
  static validateOrderDate(orderDate: string): ValidationError | null {
    if (!orderDate || orderDate.trim() === '') {
      return { field: 'orderDate', message: 'Order date is required' };
    }

    const date = new Date(orderDate);
    if (isNaN(date.getTime())) {
      return { field: 'orderDate', message: 'Invalid order date format' };
    }

    // Check if date is not too far in the future (e.g., 1 year)
    const oneYearFromNow = new Date();
    oneYearFromNow.setFullYear(oneYearFromNow.getFullYear() + 1);
    if (date > oneYearFromNow) {
      return { field: 'orderDate', message: 'Order date cannot be more than 1 year in the future' };
    }

    return null;
  }

  /**
   * Validate supplier from counterparty
   */
  static validateCounterpartySupplier(supplierId: string | null): ValidationError | null {
    if (!supplierId || supplierId.trim() === '') {
      return { field: 'supplier', message: 'Please select a supplier' };
    }
    return null;
  }

  /**
   * Validate supplier info (for "Others" tab)
   */
  static validateSupplierInfo(supplierInfo: SupplierInfo): ValidationError[] {
    const errors: ValidationError[] = [];

    // Name is required
    if (!supplierInfo.name || supplierInfo.name.trim() === '') {
      errors.push({ field: 'supplier.name', message: 'Supplier name is required' });
    }

    // Validate email format if provided
    if (supplierInfo.email && supplierInfo.email.trim() !== '') {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(supplierInfo.email)) {
        errors.push({ field: 'supplier.email', message: 'Invalid email format' });
      }
    }

    // Validate phone format if provided (basic validation)
    if (supplierInfo.phone && supplierInfo.phone.trim() !== '') {
      const phoneRegex = /^[\d\s\-\+\(\)]+$/;
      if (!phoneRegex.test(supplierInfo.phone)) {
        errors.push({ field: 'supplier.phone', message: 'Invalid phone format' });
      }
    }

    return errors;
  }

  /**
   * Validate order items
   */
  static validateOrderItems(items: OrderItem[]): ValidationError[] {
    const errors: ValidationError[] = [];

    // Check if items exist
    if (!items || items.length === 0) {
      errors.push({ field: 'items', message: 'At least one product must be added to the order' });
      return errors;
    }

    // Validate each item
    items.forEach((item, index) => {
      // Validate quantity
      if (!item.quantity_ordered || item.quantity_ordered <= 0) {
        errors.push({
          field: `items[${index}].quantity_ordered`,
          message: `Item "${item.product_name}": Quantity must be greater than 0`,
        });
      }

      // Validate unit price
      if (item.unit_price === undefined || item.unit_price === null || item.unit_price < 0) {
        errors.push({
          field: `items[${index}].unit_price`,
          message: `Item "${item.product_name}": Unit price must be 0 or greater`,
        });
      }

      // Validate total_amount consistency
      const expectedTotal = item.quantity_ordered * item.unit_price;
      if (Math.abs(item.total_amount - expectedTotal) > 0.01) {
        errors.push({
          field: `items[${index}].total_amount`,
          message: `Item "${item.product_name}": Total amount calculation mismatch`,
        });
      }

      // Validate product_id
      if (!item.product_id || item.product_id.trim() === '') {
        errors.push({
          field: `items[${index}].product_id`,
          message: `Item "${item.product_name}": Missing product ID`,
        });
      }
    });

    return errors;
  }

  /**
   * Validate entire order form (combined validation)
   */
  static validateOrderForm(
    orderDate: string,
    supplierType: 'counter-party' | 'others',
    supplierId: string | null,
    supplierInfo: SupplierInfo | null,
    items: OrderItem[]
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // Validate order date
    const dateError = this.validateOrderDate(orderDate);
    if (dateError) {
      errors.push(dateError);
    }

    // Validate supplier based on type
    if (supplierType === 'counter-party') {
      const supplierError = this.validateCounterpartySupplier(supplierId);
      if (supplierError) {
        errors.push(supplierError);
      }
    } else if (supplierType === 'others') {
      if (!supplierInfo) {
        errors.push({ field: 'supplier', message: 'Supplier information is required' });
      } else {
        const supplierErrors = this.validateSupplierInfo(supplierInfo);
        errors.push(...supplierErrors);
      }
    }

    // Validate order items
    const itemErrors = this.validateOrderItems(items);
    errors.push(...itemErrors);

    return errors;
  }

  /**
   * Check if order form is valid (convenience method)
   */
  static isValidOrderForm(
    orderDate: string,
    supplierType: 'counter-party' | 'others',
    supplierId: string | null,
    supplierInfo: SupplierInfo | null,
    items: OrderItem[]
  ): boolean {
    const errors = this.validateOrderForm(orderDate, supplierType, supplierId, supplierInfo, items);
    return errors.length === 0;
  }
}
