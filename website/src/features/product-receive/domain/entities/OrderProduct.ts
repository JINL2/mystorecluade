/**
 * OrderProduct Entity
 * Represents a product in a purchase order
 */

export interface OrderProduct {
  productId: string;
  sku: string;
  productName: string;
  quantityOrdered: number;
  quantityReceived: number;
  quantityRemaining: number;
  unit: string;
}

export class OrderProductEntity implements OrderProduct {
  productId: string;
  sku: string;
  productName: string;
  quantityOrdered: number;
  quantityReceived: number;
  quantityRemaining: number;
  unit: string;

  constructor(data: OrderProduct) {
    this.productId = data.productId;
    this.sku = data.sku;
    this.productName = data.productName;
    this.quantityOrdered = data.quantityOrdered;
    this.quantityReceived = data.quantityReceived;
    this.quantityRemaining = data.quantityRemaining;
    this.unit = data.unit;
  }

  get isFullyReceived(): boolean {
    return this.quantityReceived >= this.quantityOrdered;
  }

  get progressPercentage(): number {
    if (this.quantityOrdered === 0) return 0;
    return Math.round((this.quantityReceived / this.quantityOrdered) * 100);
  }

  canReceiveMore(additionalQuantity: number): boolean {
    return this.quantityReceived + additionalQuantity <= this.quantityOrdered;
  }

  getDisplayName(): string {
    return `${this.productName} (${this.sku})`;
  }
}
