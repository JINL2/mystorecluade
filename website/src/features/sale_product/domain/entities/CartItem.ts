/**
 * CartItem Entity
 * Domain entity representing an item in the shopping cart
 * v6: Added variant support
 */

export class CartItem {
  constructor(
    public readonly productId: string,
    public readonly sku: string,
    public readonly productName: string,
    public quantity: number,
    public readonly unitPrice: number,
    public readonly costPrice: number,
    // v6: variant field for unique identification
    public readonly variantId: string | null = null
  ) {}

  // v6: unique key combining product_id + variant_id
  get uniqueKey(): string {
    return this.variantId ? `${this.productId}-${this.variantId}` : this.productId;
  }

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
      this.costPrice,
      this.variantId
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
      this.costPrice,
      this.variantId
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
      this.costPrice,
      this.variantId
    );
  }

  /**
   * Create CartItem from product data
   * v6: Added variantId parameter
   */
  static fromProduct(
    productId: string,
    sku: string,
    productName: string,
    unitPrice: number,
    costPrice: number,
    quantity: number = 1,
    variantId: string | null = null
  ): CartItem {
    return new CartItem(productId, sku, productName, quantity, unitPrice, costPrice, variantId);
  }
}
