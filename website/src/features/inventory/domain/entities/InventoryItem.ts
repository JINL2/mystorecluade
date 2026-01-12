/**
 * InventoryItem Entity
 * Represents an inventory item with stock information
 */

export class InventoryItem {
  constructor(
    public readonly productId: string,
    public readonly productCode: string,
    public readonly productName: string,
    public readonly categoryName: string,
    public readonly brandName: string,
    public readonly currentStock: number,
    public readonly minStock: number,
    public readonly maxStock: number,
    public readonly unitPrice: number,
    public readonly totalValue: number,
    public readonly unit: string,
    public readonly currencySymbol: string,
    // Additional fields needed for editing
    public readonly categoryId: string | null = null,
    public readonly brandId: string | null = null,
    public readonly sku: string = '',
    public readonly barcode: string = '',
    public readonly productType: string = 'commodity',
    public readonly costPrice: number = 0,
    public readonly createdAt?: Date,  // Date 객체로 변경 (Local 시간)
    public readonly imageUrls: string[] = [],  // 제품 이미지 URL 배열
    // v6 variant fields
    public readonly variantId: string | null = null,
    public readonly variantName: string | null = null,
    public readonly variantSku: string | null = null,
    public readonly variantBarcode: string | null = null,
    public readonly displayName: string | null = null,
    public readonly displaySku: string | null = null,
    public readonly displayBarcode: string | null = null,
    public readonly hasVariants: boolean = false
  ) {}

  /**
   * Get unique identifier for this item (variant_id if exists, otherwise product_id)
   * Used for lookups and selection tracking
   */
  get uniqueId(): string {
    return this.variantId ?? this.productId;
  }

  /**
   * Get display name for UI - uses displayName if available, otherwise productName
   */
  get name(): string {
    return this.displayName ?? this.productName;
  }

  /**
   * Get effective SKU for UI - uses displaySku if available, otherwise sku
   */
  get effectiveSku(): string {
    return this.displaySku ?? this.sku;
  }

  /**
   * Get effective barcode for UI - uses displayBarcode if available, otherwise barcode
   */
  get effectiveBarcode(): string {
    return this.displayBarcode ?? this.barcode;
  }

  /**
   * Check if stock is below minimum
   */
  get isLowStock(): boolean {
    return this.currentStock <= this.minStock;
  }

  /**
   * Check if stock is above maximum
   */
  get isOverStock(): boolean {
    return this.currentStock >= this.maxStock;
  }

  /**
   * Get stock status
   */
  get stockStatus(): 'low' | 'normal' | 'over' {
    if (this.isLowStock) return 'low';
    if (this.isOverStock) return 'over';
    return 'normal';
  }

  /**
   * Format currency amount
   */
  formatCurrency(amount: number): string {
    return `${this.currencySymbol}${amount.toLocaleString('en-US', {
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    })}`;
  }

  /**
   * Get stock percentage
   */
  get stockPercentage(): number {
    if (this.maxStock === 0) return 0;
    return (this.currentStock / this.maxStock) * 100;
  }
}
