/**
 * TrackingItem Entity
 * Represents an inventory tracking item
 */

export class TrackingItem {
  constructor(
    public readonly productId: string,
    public readonly sku: string,
    public readonly productName: string,
    public readonly categoryName: string,
    public readonly brandName: string,
    public readonly currentStock: number,
    public readonly minStock: number,
    public readonly maxStock: number,
    public readonly unitPrice: number,
    public readonly currencySymbol: string
  ) {}

  /**
   * Get total value of stock
   */
  get totalValue(): number {
    return this.currentStock * this.unitPrice;
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
   * Get formatted total value
   */
  get formattedTotalValue(): string {
    return this.formatCurrency(this.totalValue);
  }

  /**
   * Check if item is low on stock
   */
  get isLowStock(): boolean {
    return this.currentStock <= this.minStock;
  }

  /**
   * Check if item is over stock
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
   * Get stock percentage
   */
  get stockPercentage(): number {
    if (this.maxStock === 0) return 0;
    return Math.min(100, (this.currentStock / this.maxStock) * 100);
  }
}
