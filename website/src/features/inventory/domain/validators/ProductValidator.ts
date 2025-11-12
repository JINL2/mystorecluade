/**
 * Product Validator
 * Domain layer - Validation rules for inventory product operations
 *
 * Following ARCHITECTURE.md pattern: validators define rules (static methods),
 * presentation layer (hooks/components) executes validation.
 */

export interface ValidationError {
  field: string;
  message: string;
}

export interface ValidationResult {
  isValid: boolean;
  errors: ValidationError[];
}

export class ProductValidator {
  /**
   * Validate product name
   * @param name - Product name
   * @returns ValidationResult with errors if invalid
   */
  static validateProductName(name: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!name || name.trim() === '') {
      errors.push({
        field: 'productName',
        message: 'Product name is required',
      });
      return { isValid: false, errors };
    }

    if (name.length < 2) {
      errors.push({
        field: 'productName',
        message: 'Product name must be at least 2 characters',
      });
    }

    if (name.length > 200) {
      errors.push({
        field: 'productName',
        message: 'Product name cannot exceed 200 characters',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate SKU format
   * @param sku - Stock Keeping Unit code
   * @returns ValidationResult with errors if invalid
   */
  static validateSKU(sku: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!sku || sku.trim() === '') {
      errors.push({
        field: 'sku',
        message: 'SKU is required',
      });
      return { isValid: false, errors };
    }

    // SKU should contain only alphanumeric characters, hyphens, and underscores
    const skuRegex = /^[A-Za-z0-9-_]+$/;
    if (!skuRegex.test(sku)) {
      errors.push({
        field: 'sku',
        message: 'SKU can only contain letters, numbers, hyphens, and underscores',
      });
    }

    if (sku.length > 50) {
      errors.push({
        field: 'sku',
        message: 'SKU cannot exceed 50 characters',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate barcode format (optional field)
   * @param barcode - Product barcode
   * @returns ValidationResult with errors if invalid
   */
  static validateBarcode(barcode: string): ValidationResult {
    const errors: ValidationError[] = [];

    // Barcode is optional
    if (!barcode || barcode.trim() === '') {
      return { isValid: true, errors };
    }

    // Barcode should contain only digits and hyphens
    const barcodeRegex = /^[0-9-]+$/;
    if (!barcodeRegex.test(barcode)) {
      errors.push({
        field: 'barcode',
        message: 'Barcode can only contain numbers and hyphens',
      });
    }

    if (barcode.length > 50) {
      errors.push({
        field: 'barcode',
        message: 'Barcode cannot exceed 50 characters',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate price (cost or selling price)
   * @param price - Price value
   * @param fieldName - Field name for error messages
   * @returns ValidationResult with errors if invalid
   */
  static validatePrice(price: number, fieldName: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (price === null || price === undefined) {
      errors.push({
        field: fieldName,
        message: `${fieldName} is required`,
      });
      return { isValid: false, errors };
    }

    if (price < 0) {
      errors.push({
        field: fieldName,
        message: `${fieldName} must be a positive number`,
      });
    }

    if (price > 999999999) {
      errors.push({
        field: fieldName,
        message: `${fieldName} is too large`,
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate stock quantity
   * @param quantity - Stock quantity
   * @returns ValidationResult with errors if invalid
   */
  static validateStockQuantity(quantity: number): ValidationResult {
    const errors: ValidationError[] = [];

    if (quantity === null || quantity === undefined) {
      errors.push({
        field: 'currentStock',
        message: 'Stock quantity is required',
      });
      return { isValid: false, errors };
    }

    if (quantity < 0) {
      errors.push({
        field: 'currentStock',
        message: 'Stock quantity cannot be negative',
      });
    }

    if (!Number.isInteger(quantity)) {
      errors.push({
        field: 'currentStock',
        message: 'Stock quantity must be a whole number',
      });
    }

    if (quantity > 999999999) {
      errors.push({
        field: 'currentStock',
        message: 'Stock quantity is too large',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate category ID (UUID format)
   * @param categoryId - Category identifier
   * @returns ValidationResult with errors if invalid
   */
  static validateCategoryId(categoryId: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!categoryId || categoryId.trim() === '') {
      errors.push({
        field: 'category',
        message: 'Category is required',
      });
      return { isValid: false, errors };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(categoryId)) {
      errors.push({
        field: 'category',
        message: 'Invalid category ID format',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate brand ID (UUID format, optional)
   * @param brandId - Brand identifier
   * @returns ValidationResult with errors if invalid
   */
  static validateBrandId(brandId: string): ValidationResult {
    const errors: ValidationError[] = [];

    // Brand is optional
    if (!brandId || brandId.trim() === '') {
      return { isValid: true, errors };
    }

    // UUID format validation
    const uuidRegex = /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i;
    if (!uuidRegex.test(brandId)) {
      errors.push({
        field: 'brand',
        message: 'Invalid brand ID format',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate unit
   * @param unit - Product unit (e.g., 'piece', 'kg', 'box')
   * @returns ValidationResult with errors if invalid
   */
  static validateUnit(unit: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!unit || unit.trim() === '') {
      errors.push({
        field: 'unit',
        message: 'Unit is required',
      });
      return { isValid: false, errors };
    }

    if (unit.length > 20) {
      errors.push({
        field: 'unit',
        message: 'Unit cannot exceed 20 characters',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate product type
   * @param productType - Product type (e.g., 'commodity', 'service')
   * @returns ValidationResult with errors if invalid
   */
  static validateProductType(productType: string): ValidationResult {
    const errors: ValidationError[] = [];

    if (!productType || productType.trim() === '') {
      errors.push({
        field: 'productType',
        message: 'Product type is required',
      });
      return { isValid: false, errors };
    }

    const validTypes = ['commodity', 'service', 'digital', 'raw_material', 'finished_goods'];
    if (!validTypes.includes(productType)) {
      errors.push({
        field: 'productType',
        message: `Product type must be one of: ${validTypes.join(', ')}`,
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate price relationship (selling price should be >= cost price)
   * @param costPrice - Cost price
   * @param sellingPrice - Selling price
   * @returns ValidationResult with errors if invalid
   */
  static validatePriceRelationship(costPrice: number, sellingPrice: number): ValidationResult {
    const errors: ValidationError[] = [];

    if (sellingPrice < costPrice) {
      errors.push({
        field: 'sellingPrice',
        message: 'Selling price should be greater than or equal to cost price',
      });
    }

    const profitMargin = ((sellingPrice - costPrice) / costPrice) * 100;
    if (profitMargin < -100) {
      errors.push({
        field: 'sellingPrice',
        message: 'Profit margin is unreasonably low',
      });
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }

  /**
   * Validate complete product data for create/update operations
   * Validates all required fields for a product
   *
   * @param productData - Product data to validate
   * @returns ValidationResult with all errors if invalid
   */
  static validateProductData(productData: {
    productName: string;
    sku: string;
    barcode?: string;
    category: string;
    brand?: string;
    unit: string;
    productType: string;
    costPrice: number;
    sellingPrice: number;
    currentStock: number;
  }): ValidationResult {
    const errors: ValidationError[] = [];

    // Validate product name
    const nameResult = this.validateProductName(productData.productName);
    if (!nameResult.isValid) {
      errors.push(...nameResult.errors);
    }

    // Validate SKU
    const skuResult = this.validateSKU(productData.sku);
    if (!skuResult.isValid) {
      errors.push(...skuResult.errors);
    }

    // Validate barcode (optional)
    if (productData.barcode) {
      const barcodeResult = this.validateBarcode(productData.barcode);
      if (!barcodeResult.isValid) {
        errors.push(...barcodeResult.errors);
      }
    }

    // Validate category
    const categoryResult = this.validateCategoryId(productData.category);
    if (!categoryResult.isValid) {
      errors.push(...categoryResult.errors);
    }

    // Validate brand (optional)
    if (productData.brand) {
      const brandResult = this.validateBrandId(productData.brand);
      if (!brandResult.isValid) {
        errors.push(...brandResult.errors);
      }
    }

    // Validate unit
    const unitResult = this.validateUnit(productData.unit);
    if (!unitResult.isValid) {
      errors.push(...unitResult.errors);
    }

    // Validate product type
    const typeResult = this.validateProductType(productData.productType);
    if (!typeResult.isValid) {
      errors.push(...typeResult.errors);
    }

    // Validate cost price
    const costPriceResult = this.validatePrice(productData.costPrice, 'costPrice');
    if (!costPriceResult.isValid) {
      errors.push(...costPriceResult.errors);
    }

    // Validate selling price
    const sellingPriceResult = this.validatePrice(productData.sellingPrice, 'sellingPrice');
    if (!sellingPriceResult.isValid) {
      errors.push(...sellingPriceResult.errors);
    }

    // Validate price relationship (only if both prices are valid)
    if (costPriceResult.isValid && sellingPriceResult.isValid) {
      const priceRelationResult = this.validatePriceRelationship(
        productData.costPrice,
        productData.sellingPrice
      );
      if (!priceRelationResult.isValid) {
        errors.push(...priceRelationResult.errors);
      }
    }

    // Validate stock quantity
    const stockResult = this.validateStockQuantity(productData.currentStock);
    if (!stockResult.isValid) {
      errors.push(...stockResult.errors);
    }

    return {
      isValid: errors.length === 0,
      errors,
    };
  }
}
