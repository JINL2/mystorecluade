/**
 * ReceiveValidator
 * Validation rules for product receiving operations
 */

import { ScannedItem } from '../entities/ScannedItem';
import { OrderProduct } from '../entities/OrderProduct';
import { Order } from '../entities/Order';

export interface ValidationError {
  field: string;
  message: string;
}

/**
 * Product Receive Validation Rules
 */
export class ReceiveValidator {
  /**
   * Validate a single scanned item against order product
   */
  static validateScannedItem(
    item: ScannedItem,
    orderProduct: OrderProduct
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // Check if quantity is positive
    if (item.count <= 0) {
      errors.push({
        field: 'quantity',
        message: 'Quantity must be greater than 0',
      });
    }

    // Check if quantity exceeds remaining quantity
    if (item.count > orderProduct.quantityRemaining) {
      errors.push({
        field: 'quantity',
        message: `Cannot receive ${item.count} items. Only ${orderProduct.quantityRemaining} items remaining in order`,
      });
    }

    // Check if SKU matches
    if (item.sku !== orderProduct.sku) {
      errors.push({
        field: 'sku',
        message: 'SKU mismatch',
      });
    }

    return errors;
  }

  /**
   * Validate all scanned items before submission
   */
  static validateSubmission(
    scannedItems: ScannedItem[],
    order: Order | null,
    orderProducts: OrderProduct[]
  ): ValidationError[] {
    const errors: ValidationError[] = [];

    // Check if order is selected
    if (!order) {
      errors.push({
        field: 'order',
        message: 'No order selected. Please select an order first',
      });
      return errors;
    }

    // Check if order is receivable
    if (!order.isReceivable) {
      errors.push({
        field: 'order',
        message: `Order status "${order.status}" is not receivable. Only pending or partial orders can receive products`,
      });
    }

    // Check if there are scanned items
    if (scannedItems.length === 0) {
      errors.push({
        field: 'items',
        message: 'No items scanned. Please scan at least one product',
      });
      return errors;
    }

    // Validate each scanned item
    for (const scannedItem of scannedItems) {
      // Find matching product in order
      const orderProduct = orderProducts.find((p) => p.sku === scannedItem.sku);

      if (!orderProduct) {
        errors.push({
          field: `item_${scannedItem.sku}`,
          message: `Product ${scannedItem.sku} is not in this order`,
        });
        continue;
      }

      // Validate item quantity
      const itemErrors = this.validateScannedItem(scannedItem, orderProduct);
      errors.push(...itemErrors);
    }

    return errors;
  }

  /**
   * Validate SKU input
   */
  static validateSKUInput(sku: string): ValidationError | null {
    const trimmedSku = sku.trim();

    if (!trimmedSku) {
      return {
        field: 'sku',
        message: 'SKU cannot be empty',
      };
    }

    if (trimmedSku.length < 2) {
      return {
        field: 'sku',
        message: 'SKU must be at least 2 characters',
      };
    }

    // Check for invalid characters (optional - adjust based on your SKU format)
    const validSkuPattern = /^[a-zA-Z0-9-_]+$/;
    if (!validSkuPattern.test(trimmedSku)) {
      return {
        field: 'sku',
        message: 'SKU contains invalid characters. Only letters, numbers, hyphens, and underscores are allowed',
      };
    }

    return null;
  }

  /**
   * Validate quantity input
   */
  static validateQuantity(
    quantity: number,
    maxQuantity: number
  ): ValidationError | null {
    if (quantity <= 0) {
      return {
        field: 'quantity',
        message: 'Quantity must be greater than 0',
      };
    }

    if (!Number.isInteger(quantity)) {
      return {
        field: 'quantity',
        message: 'Quantity must be a whole number',
      };
    }

    if (quantity > maxQuantity) {
      return {
        field: 'quantity',
        message: `Quantity cannot exceed ${maxQuantity}`,
      };
    }

    return null;
  }

  /**
   * Check if product is in order
   */
  static isProductInOrder(sku: string, orderProducts: OrderProduct[]): boolean {
    return orderProducts.some((p) => p.sku === sku);
  }

  /**
   * Get remaining quantity for a product
   */
  static getRemainingQuantity(
    sku: string,
    orderProducts: OrderProduct[]
  ): number {
    const product = orderProducts.find((p) => p.sku === sku);
    return product ? product.quantityRemaining : 0;
  }

  /**
   * Check if all products in order are fully received
   */
  static isOrderFullyReceived(orderProducts: OrderProduct[]): boolean {
    return orderProducts.every((p) => p.isFullyReceived);
  }

  /**
   * Calculate total quantity to be received
   */
  static calculateTotalQuantity(scannedItems: ScannedItem[]): number {
    return scannedItems.reduce((sum, item) => sum + item.count, 0);
  }

  /**
   * Check for duplicate SKUs in scanned items
   */
  static hasDuplicateSKUs(scannedItems: ScannedItem[]): boolean {
    const skus = scannedItems.map((item) => item.sku);
    const uniqueSkus = new Set(skus);
    return skus.length !== uniqueSkus.size;
  }
}
