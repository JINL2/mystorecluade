/**
 * CartItem Entity
 * Domain entity representing an item in the shopping cart
 */

export class CartItem {
  constructor(
    public readonly productId: string,
    public readonly sku: string,
    public readonly productName: string,
    public quantity: number,
    public readonly unitPrice: number,
    public readonly costPrice: number
  ) {}

  get totalPrice(): number {
    return this.quantity * this.unitPrice;
  }

  get totalCost(): number {
    return this.quantity * this.costPrice;
  }

  incrementQuantity(): CartItem {
    return new CartItem(
      this.productId,
      this.sku,
      this.productName,
      this.quantity + 1,
      this.unitPrice,
      this.costPrice
    );
  }

  decrementQuantity(): CartItem | null {
    if (this.quantity <= 1) {
      return null; // Item should be removed from cart
    }
    return new CartItem(
      this.productId,
      this.sku,
      this.productName,
      this.quantity - 1,
      this.unitPrice,
      this.costPrice
    );
  }

  updateQuantity(newQuantity: number): CartItem | null {
    if (newQuantity <= 0) {
      return null; // Item should be removed from cart
    }
    return new CartItem(
      this.productId,
      this.sku,
      this.productName,
      newQuantity,
      this.unitPrice,
      this.costPrice
    );
  }

  static fromProduct(
    productId: string,
    sku: string,
    productName: string,
    unitPrice: number,
    costPrice: number,
    quantity: number = 1
  ): CartItem {
    return new CartItem(productId, sku, productName, quantity, unitPrice, costPrice);
  }
}
