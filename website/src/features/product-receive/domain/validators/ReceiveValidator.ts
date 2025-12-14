/**
 * ReceiveValidator
 * Validation rules for product receiving operations
 */

import type { SaveItem, SubmitItem } from '../entities';

export interface ValidationResult {
  isValid: boolean;
  errors: string[];
}

export class ReceiveValidator {
  /**
   * Validate a single save item
   */
  static validateSaveItem(item: SaveItem): ValidationResult {
    const errors: string[] = [];

    if (!item.productId || item.productId.trim() === '') {
      errors.push('Product ID is required');
    }

    if (item.quantity < 0) {
      errors.push('Quantity cannot be negative');
    }

    if (item.quantityRejected < 0) {
      errors.push('Rejected quantity cannot be negative');
    }

    if (item.quantityRejected > item.quantity) {
      errors.push('Rejected quantity cannot exceed total quantity');
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate multiple save items
   */
  static validateSaveItems(items: SaveItem[]): ValidationResult {
    const errors: string[] = [];

    if (items.length === 0) {
      errors.push('At least one item is required');
    }

    items.forEach((item, index) => {
      const result = this.validateSaveItem(item);
      if (!result.isValid) {
        result.errors.forEach((error) => {
          errors.push(`Item ${index + 1}: ${error}`);
        });
      }
    });

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate a single submit item
   */
  static validateSubmitItem(item: SubmitItem): ValidationResult {
    const errors: string[] = [];

    if (!item.productId || item.productId.trim() === '') {
      errors.push('Product ID is required');
    }

    if (item.quantity < 0) {
      errors.push('Quantity cannot be negative');
    }

    if (item.quantityRejected < 0) {
      errors.push('Rejected quantity cannot be negative');
    }

    if (item.quantityRejected > item.quantity) {
      errors.push('Rejected quantity cannot exceed total quantity');
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate multiple submit items
   */
  static validateSubmitItems(items: SubmitItem[]): ValidationResult {
    const errors: string[] = [];

    if (items.length === 0) {
      errors.push('At least one item is required for submission');
    }

    items.forEach((item, index) => {
      const result = this.validateSubmitItem(item);
      if (!result.isValid) {
        result.errors.forEach((error) => {
          errors.push(`Item ${index + 1}: ${error}`);
        });
      }
    });

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate session ID
   */
  static validateSessionId(sessionId: string): ValidationResult {
    const errors: string[] = [];

    if (!sessionId || sessionId.trim() === '') {
      errors.push('Session ID is required');
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate search query
   */
  static validateSearchQuery(query: string, minLength: number = 1): ValidationResult {
    const errors: string[] = [];

    if (!query || query.trim().length < minLength) {
      errors.push(`Search query must be at least ${minLength} character(s)`);
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }
}
