/**
 * ScannedItem Entity
 * Represents a scanned item during receiving process
 */

export interface ScannedItem {
  sku: string;
  productId: string;
  productName: string;
  count: number;
  scannedAt: Date;
  lastScannedAt: Date;
}

export class ScannedItemEntity implements ScannedItem {
  sku: string;
  productId: string;
  productName: string;
  count: number;
  scannedAt: Date;
  lastScannedAt: Date;

  constructor(
    sku: string,
    productId: string,
    productName: string,
    initialCount: number = 1
  ) {
    this.sku = sku;
    this.productId = productId;
    this.productName = productName;
    this.count = initialCount;
    this.scannedAt = new Date();
    this.lastScannedAt = new Date();
  }

  incrementCount(): void {
    this.count++;
    this.lastScannedAt = new Date();
  }

  decrementCount(): void {
    if (this.count > 0) {
      this.count--;
      this.lastScannedAt = new Date();
    }
  }

  setCount(newCount: number): void {
    if (newCount >= 0) {
      this.count = newCount;
      this.lastScannedAt = new Date();
    }
  }

  get displayName(): string {
    return `${this.productName} (${this.sku})`;
  }

  get formattedTime(): string {
    const now = new Date();
    const diff = now.getTime() - this.lastScannedAt.getTime();
    const seconds = Math.floor(diff / 1000);

    if (seconds < 60) return 'Just now';
    const minutes = Math.floor(seconds / 60);
    if (minutes < 60) return `${minutes}m ago`;
    const hours = Math.floor(minutes / 60);
    return `${hours}h ago`;
  }
}
