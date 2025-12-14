/**
 * ShipmentValidator
 * Validation rules for shipment operations
 * Contains all business validation logic for shipment domain
 */

import type { NewShipmentItem } from '../entities/Shipment';
import type { OneTimeSupplier, SelectionMode } from '../types';

// ===== Validation Result Types =====

export interface ValidationError {
  field: string;
  message: string;
  code: string;
}

export interface ValidationResult {
  isValid: boolean;
  errors: ValidationError[];
}

// ===== Validator Class =====

export class ShipmentValidator {
  // ===== Shipment Item Validation =====

  /**
   * Validate a single shipment item
   */
  static validateItem(item: NewShipmentItem): ValidationResult {
    const errors: ValidationError[] = [];

    // SKU validation
    if (!item.sku || item.sku.trim() === '') {
      errors.push({
        field: 'sku',
        message: 'SKU is required',
        code: 'ITEM_SKU_REQUIRED',
      });
    }

    // Product ID validation
    if (!item.productId || item.productId.trim() === '') {
      errors.push({
        field: 'productId',
        message: 'Product ID is required',
        code: 'ITEM_PRODUCT_ID_REQUIRED',
      });
    }

    // Quantity validation
    if (item.quantity <= 0) {
      errors.push({
        field: 'quantity',
        message: 'Quantity must be greater than 0',
        code: 'ITEM_QUANTITY_INVALID',
      });
    }

    // Max quantity validation (only if maxQuantity is set)
    if (item.maxQuantity > 0 && item.quantity > item.maxQuantity) {
      errors.push({
        field: 'quantity',
        message: `Quantity cannot exceed ${item.maxQuantity}`,
        code: 'ITEM_QUANTITY_EXCEEDS_MAX',
      });
    }

    // Unit price validation (can be 0 for free items)
    if (item.unitPrice < 0) {
      errors.push({
        field: 'unitPrice',
        message: 'Unit price cannot be negative',
        code: 'ITEM_PRICE_NEGATIVE',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate all shipment items
   */
  static validateItems(items: NewShipmentItem[]): ValidationResult {
    const errors: ValidationError[] = [];

    // At least one item required
    if (!items || items.length === 0) {
      errors.push({
        field: 'items',
        message: 'Please add at least one item to the shipment',
        code: 'ITEMS_EMPTY',
      });
      return { isValid: false, errors };
    }

    // Validate each item
    items.forEach((item, index) => {
      const itemResult = this.validateItem(item);
      if (!itemResult.isValid) {
        itemResult.errors.forEach((error) => {
          errors.push({
            ...error,
            field: `items[${index}].${error.field}`,
            message: `Item ${index + 1}: ${error.message}`,
          });
        });
      }
    });

    // Check for duplicate SKUs
    const skuMap = new Map<string, number[]>();
    items.forEach((item, index) => {
      if (item.sku) {
        const existing = skuMap.get(item.sku) || [];
        existing.push(index);
        skuMap.set(item.sku, existing);
      }
    });

    skuMap.forEach((indices, sku) => {
      if (indices.length > 1) {
        errors.push({
          field: 'items',
          message: `Duplicate SKU "${sku}" found at positions: ${indices.map((i) => i + 1).join(', ')}`,
          code: 'ITEMS_DUPLICATE_SKU',
        });
      }
    });

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  // ===== Supplier Validation =====

  /**
   * Validate existing supplier selection
   */
  static validateExistingSupplier(supplierId: string | null): ValidationResult {
    const errors: ValidationError[] = [];

    if (!supplierId || supplierId.trim() === '') {
      errors.push({
        field: 'supplierId',
        message: 'Please select a supplier',
        code: 'SUPPLIER_NOT_SELECTED',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate one-time supplier info
   */
  static validateOneTimeSupplier(supplier: OneTimeSupplier): ValidationResult {
    const errors: ValidationError[] = [];

    // Name is required
    if (!supplier.name || supplier.name.trim() === '') {
      errors.push({
        field: 'name',
        message: 'Supplier name is required',
        code: 'SUPPLIER_NAME_REQUIRED',
      });
    }

    // Email format validation (if provided)
    if (supplier.email && supplier.email.trim() !== '') {
      const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
      if (!emailRegex.test(supplier.email.trim())) {
        errors.push({
          field: 'email',
          message: 'Please enter a valid email address',
          code: 'SUPPLIER_EMAIL_INVALID',
        });
      }
    }

    // Phone format validation (if provided) - basic check
    if (supplier.phone && supplier.phone.trim() !== '') {
      const phoneRegex = /^[0-9+\-\s()]{7,20}$/;
      if (!phoneRegex.test(supplier.phone.trim())) {
        errors.push({
          field: 'phone',
          message: 'Please enter a valid phone number',
          code: 'SUPPLIER_PHONE_INVALID',
        });
      }
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  // ===== Order Validation =====

  /**
   * Validate order selection
   */
  static validateOrderSelection(orderId: string | null): ValidationResult {
    const errors: ValidationError[] = [];

    if (!orderId || orderId.trim() === '') {
      errors.push({
        field: 'orderId',
        message: 'Please select an order',
        code: 'ORDER_NOT_SELECTED',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  // ===== Complete Shipment Validation =====

  /**
   * Validate selection mode
   */
  static validateSelectionMode(selectionMode: SelectionMode): ValidationResult {
    const errors: ValidationError[] = [];

    if (!selectionMode) {
      errors.push({
        field: 'selectionMode',
        message: 'Please select an order or enter supplier information',
        code: 'SELECTION_MODE_REQUIRED',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate complete shipment for creation
   */
  static validateForCreate(
    selectionMode: SelectionMode,
    items: NewShipmentItem[],
    selectedOrder: string | null,
    selectedSupplier: string | null,
    supplierType: 'existing' | 'onetime',
    oneTimeSupplier: OneTimeSupplier,
    companyId: string | null
  ): ValidationResult {
    const errors: ValidationError[] = [];

    // Company validation
    if (!companyId) {
      errors.push({
        field: 'companyId',
        message: 'Company not selected. Please select a company first.',
        code: 'COMPANY_NOT_SELECTED',
      });
    }

    // Selection mode validation
    const modeResult = this.validateSelectionMode(selectionMode);
    errors.push(...modeResult.errors);

    // Items validation
    const itemsResult = this.validateItems(items);
    errors.push(...itemsResult.errors);

    // Supplier/Order validation based on mode
    if (selectionMode === 'order') {
      const orderResult = this.validateOrderSelection(selectedOrder);
      errors.push(...orderResult.errors);
    } else if (selectionMode === 'supplier') {
      if (supplierType === 'existing') {
        const supplierResult = this.validateExistingSupplier(selectedSupplier);
        errors.push(...supplierResult.errors);
      } else {
        const oneTimeResult = this.validateOneTimeSupplier(oneTimeSupplier);
        errors.push(...oneTimeResult.errors);
      }
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  // ===== Tracking Number Validation =====

  /**
   * Validate tracking number format (optional field)
   */
  static validateTrackingNumber(trackingNumber: string | null): ValidationResult {
    const errors: ValidationError[] = [];

    if (trackingNumber && trackingNumber.trim() !== '') {
      // Basic format check - alphanumeric with some special chars
      const trackingRegex = /^[A-Za-z0-9\-_]{3,50}$/;
      if (!trackingRegex.test(trackingNumber.trim())) {
        errors.push({
          field: 'trackingNumber',
          message: 'Tracking number should be 3-50 alphanumeric characters',
          code: 'TRACKING_NUMBER_INVALID',
        });
      }
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  // ===== Utility Methods =====

  /**
   * Get first error message from validation result
   */
  static getFirstErrorMessage(result: ValidationResult): string | null {
    return result.errors.length > 0 ? result.errors[0].message : null;
  }

  /**
   * Get all error messages as array
   */
  static getAllErrorMessages(result: ValidationResult): string[] {
    return result.errors.map((e) => e.message);
  }

  /**
   * Check if specific field has error
   */
  static hasFieldError(result: ValidationResult, fieldName: string): boolean {
    return result.errors.some((e) => e.field === fieldName || e.field.startsWith(`${fieldName}.`) || e.field.startsWith(`${fieldName}[`));
  }

  /**
   * Get errors for specific field
   */
  static getFieldErrors(result: ValidationResult, fieldName: string): ValidationError[] {
    return result.errors.filter((e) => e.field === fieldName || e.field.startsWith(`${fieldName}.`) || e.field.startsWith(`${fieldName}[`));
  }
}
