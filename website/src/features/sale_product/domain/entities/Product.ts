/**
 * Product Entity
 * Domain entity representing a product available for sale
 * v6: Added variant support
 */

export class Product {
  constructor(
    public readonly id: string,
    public readonly sku: string,
    public readonly name: string,
    public readonly brandName: string,
    public readonly categoryName: string,
    public readonly unit: string,
    public readonly imageUrls: string[],
    public readonly sellingPrice: number,
    public readonly costPrice: number,
    public readonly quantityAvailable: number,
    // v6: variant fields
    public readonly variantId: string | null = null,
    public readonly variantName: string | null = null,
    public readonly displayName: string = name,
    public readonly displaySku: string = sku,
    public readonly hasVariants: boolean = false
  ) {}

  // v6: unique key combining product_id + variant_id for cart identification
  get uniqueKey(): string {
    return this.variantId ? `${this.id}-${this.variantId}` : this.id;
  }

  get isAvailable(): boolean {
    return this.quantityAvailable > 0;
  }

  get formattedPrice(): string {
    return this.sellingPrice.toLocaleString();
  }

  static create(data: {
    id: string;
    sku: string;
    name: string;
    brandName: string;
    categoryName: string;
    unit: string;
    imageUrls: string[];
    sellingPrice: number;
    costPrice: number;
    quantityAvailable: number;
    // v6: variant fields
    variantId?: string | null;
    variantName?: string | null;
    displayName?: string;
    displaySku?: string;
    hasVariants?: boolean;
  }): Product {
    return new Product(
      data.id,
      data.sku,
      data.name,
      data.brandName,
      data.categoryName,
      data.unit,
      data.imageUrls,
      data.sellingPrice,
      data.costPrice,
      data.quantityAvailable,
      data.variantId ?? null,
      data.variantName ?? null,
      data.displayName ?? data.name,
      data.displaySku ?? data.sku,
      data.hasVariants ?? false
    );
  }
}
