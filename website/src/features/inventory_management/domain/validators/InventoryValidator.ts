/**
 * InventoryValidator
 * Validation rules for inventory products
 */

export interface ValidationError {
  field: string;
  message: string;
}

export interface ProductValidationData {
  productName?: string;
  sku?: string;
  costPrice?: number;
  sellingPrice?: number;
  currentStock?: number;
  minStock?: number;
  maxStock?: number;
  reorderPoint?: number;
}

export class InventoryValidator {
  /**
   * Validate product data
   * Static method that defines validation rules
   */
  static validateProduct(product: ProductValidationData): ValidationError[] {
    const errors: ValidationError[] = [];

    // Product name validation
    if (!product.productName || product.productName.trim() === '') {
      errors.push({
        field: 'productName',
        message: 'Product name is required'
      });
    } else if (product.productName.length > 255) {
      errors.push({
        field: 'productName',
        message: 'Product name must be less than 255 characters'
      });
    }

    // SKU validation
    if (product.sku && product.sku.length > 100) {
      errors.push({
        field: 'sku',
        message: 'SKU must be less than 100 characters'
      });
    }

    // Price validation
    if (product.costPrice !== undefined && product.costPrice < 0) {
      errors.push({
        field: 'costPrice',
        message: 'Cost price cannot be negative'
      });
    }

    if (product.sellingPrice !== undefined && product.sellingPrice < 0) {
      errors.push({
        field: 'sellingPrice',
        message: 'Selling price cannot be negative'
      });
    }

    if (
      product.costPrice !== undefined &&
      product.sellingPrice !== undefined &&
      product.sellingPrice < product.costPrice
    ) {
      errors.push({
        field: 'sellingPrice',
        message: 'Selling price should be higher than or equal to cost price'
      });
    }

    // Stock validation
    if (product.currentStock !== undefined && product.currentStock < 0) {
      errors.push({
        field: 'currentStock',
        message: 'Current stock cannot be negative'
      });
    }

    if (product.minStock !== undefined && product.minStock < 0) {
      errors.push({
        field: 'minStock',
        message: 'Minimum stock cannot be negative'
      });
    }

    if (product.maxStock !== undefined && product.maxStock < 0) {
      errors.push({
        field: 'maxStock',
        message: 'Maximum stock cannot be negative'
      });
    }

    if (
      product.minStock !== undefined &&
      product.maxStock !== undefined &&
      product.maxStock < product.minStock
    ) {
      errors.push({
        field: 'maxStock',
        message: 'Maximum stock should be greater than or equal to minimum stock'
      });
    }

    if (product.reorderPoint !== undefined && product.reorderPoint < 0) {
      errors.push({
        field: 'reorderPoint',
        message: 'Reorder point cannot be negative'
      });
    }

    return errors;
  }

  /**
   * Validate search query
   */
  static validateSearchQuery(query: string): ValidationError[] {
    const errors: ValidationError[] = [];

    if (query.length > 255) {
      errors.push({
        field: 'search',
        message: 'Search query must be less than 255 characters'
      });
    }

    return errors;
  }

  /**
   * Check if product data is valid
   */
  static isValid(product: ProductValidationData): boolean {
    return this.validateProduct(product).length === 0;
  }
}
