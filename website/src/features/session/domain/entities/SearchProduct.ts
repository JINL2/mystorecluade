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

export interface ProductStatus {
  stockLevel: 'normal' | 'low' | 'out_of_stock' | 'overstock';
  isActive: boolean;
}

export interface SearchProduct {
  // 제품 정보
  productId: string;
  productName: string;
  productSku: string;
  productBarcode?: string;
  productType: string;
  brandId?: string;
  brandName?: string;
  categoryId?: string;
  categoryName?: string;
  unit: string;
  imageUrls?: string[];

  // 변형 정보
  variantId?: string;
  variantName?: string;
  variantSku?: string;
  variantBarcode?: string;

  // 표시용
  displayName: string;
  displaySku: string;
  displayBarcode?: string;

  // 재고, 가격, 상태
  stock: ProductStock;
  price: ProductPrice;
  status: ProductStatus;

  // 메타
  hasVariants: boolean;
  createdAt: string;
}

export interface Currency {
  symbol: string;
  code: string;
  name?: string;
}

export interface SearchProductResult {
  products: SearchProduct[];
  currency: Currency;
}
