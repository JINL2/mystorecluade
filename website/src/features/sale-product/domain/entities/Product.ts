/**
 * Product Entity
 * Domain entity representing a product available for sale
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
    public readonly quantityAvailable: number
  ) {}

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
      data.quantityAvailable
    );
  }
}
