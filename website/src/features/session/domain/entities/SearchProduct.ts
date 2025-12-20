/**
 * SearchProduct Entity
 * Represents a product found through search
 */

export interface ProductStock {
  quantityOnHand: number;
  quantityAvailable: number;
  quantityReserved: number;
}

export interface ProductPrice {
  cost: number;
  selling: number;
  source: string;
}

export interface SearchProduct {
  productId: string;
  productName: string;
  sku: string;
  barcode?: string;
  imageUrls?: string[];
  stock: ProductStock;
  price: ProductPrice;
}

export interface Currency {
  symbol: string;
  code: string;
}

export interface SearchProductResult {
  products: SearchProduct[];
  currency: Currency;
}
