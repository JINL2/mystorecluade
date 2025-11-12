/**
 * ProductRepositoryImpl
 * Repository implementation for product operations (order context)
 */

import { ProductDataSource } from '../datasources/ProductDataSource';
import { ProductModel, Product } from '../models/ProductModel';

export interface ProductResult {
  success: boolean;
  data?: {
    products: Product[];
    currencySymbol: string;
    currencyCode: string;
  };
  error?: string;
}

export class ProductRepositoryImpl {
  private dataSource: ProductDataSource;

  constructor() {
    this.dataSource = new ProductDataSource();
  }

  /**
   * Get products for a company
   */
  async getProducts(companyId: string): Promise<ProductResult> {
    try {
      const rawData = await this.dataSource.getProductsByCompany(companyId);

      // Convert DTOs to entities
      const products = ProductModel.fromJsonArray(rawData.products);

      // Extract currency info
      const currencySymbol = rawData.company?.currency?.symbol || '₩';
      const currencyCode = rawData.company?.currency?.code || 'KRW';

      return {
        success: true,
        data: {
          products,
          currencySymbol,
          currencyCode,
        },
      };
    } catch (error) {
      console.error('Repository error fetching products:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch products',
      };
    }
  }

  /**
   * Get active products only
   */
  async getActiveProducts(companyId: string): Promise<ProductResult> {
    const result = await this.getProducts(companyId);

    if (!result.success || !result.data) {
      return result;
    }

    // Filter active products
    const activeProducts = result.data.products.filter(
      (p) => p.is_active && !p.is_deleted
    );

    return {
      success: true,
      data: {
        ...result.data,
        products: activeProducts,
      },
    };
  }

  /**
   * Search products by term
   */
  searchProducts(products: Product[], searchTerm: string): Product[] {
    if (!searchTerm || searchTerm.length < 1) {
      return [];
    }

    const lowerSearchTerm = searchTerm.toLowerCase();

    return products.filter((product) => {
      const productName = (product.product_name || '').toLowerCase();
      const sku = (product.sku || '').toLowerCase();
      const barcode = (product.barcode || '').toLowerCase();

      return (
        productName.includes(lowerSearchTerm) ||
        sku.includes(lowerSearchTerm) ||
        barcode.includes(lowerSearchTerm)
      );
    });
  }

  /**
   * Get product by ID
   */
  getProductById(products: Product[], productId: string): Product | null {
    return products.find((p) => p.product_id === productId) || null;
  }

  /**
   * Get product by SKU
   */
  getProductBySKU(products: Product[], sku: string): Product | null {
    return products.find((p) => p.sku === sku) || null;
  }
}
