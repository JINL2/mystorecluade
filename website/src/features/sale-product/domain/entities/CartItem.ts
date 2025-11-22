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
    public readonly unitPrice: number
  ) {}

  get totalPrice(): number {
    return this.quantity * this.unitPrice;
  }

  incrementQuantity(): CartItem {
    return new CartItem(
      this.productId,
      this.sku,
      this.productName,
      this.quantity + 1,
      this.unitPrice
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
      this.unitPrice
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
      this.unitPrice
    );
  }

  static fromProduct(
    productId: string,
    sku: string,
    productName: string,
    unitPrice: number,
    quantity: number = 1
  ): CartItem {
    return new CartItem(productId, sku, productName, quantity, unitPrice);
  }
}
