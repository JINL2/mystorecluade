/**
 * SaleInvoice Entity
 * Domain entity representing a complete sales invoice
 */

import { CartItem } from './CartItem';

export type DiscountType = 'amount' | 'percent';

export class SaleInvoice {
  constructor(
    public readonly items: CartItem[],
    public readonly discountType: DiscountType,
    public readonly discountValue: number,
    public readonly cashLocationId: string,
    public readonly companyId: string,
    public readonly storeId: string
  ) {}

  get subtotal(): number {
    return this.items.reduce((sum, item) => sum + item.totalPrice, 0);
  }

  get discountAmount(): number {
    if (this.discountType === 'percent') {
      return (this.subtotal * this.discountValue) / 100;
    }
    return this.discountValue;
  }

  get total(): number {
    return Math.max(0, this.subtotal - this.discountAmount);
  }

  get itemCount(): number {
    return this.items.length;
  }

  get totalQuantity(): number {
    return this.items.reduce((sum, item) => sum + item.quantity, 0);
  }

  hasItems(): boolean {
    return this.items.length > 0;
  }

  hasCashLocation(): boolean {
    return this.cashLocationId.trim().length > 0;
  }

  static create(data: {
    items: CartItem[];
    discountType: DiscountType;
    discountValue: number;
    cashLocationId: string;
    companyId: string;
    storeId: string;
  }): SaleInvoice {
    return new SaleInvoice(
      data.items,
      data.discountType,
      data.discountValue,
      data.cashLocationId,
      data.companyId,
      data.storeId
    );
  }
}
