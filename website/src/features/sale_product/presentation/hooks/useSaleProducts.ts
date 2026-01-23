/**
 * useSaleProducts Hook
 * Hook for loading products for sale
 *
 * Following Clean Architecture:
 * - Uses Repository instead of DataSource directly
 * - Properly abstracts data access layer
 */

import { useState, useEffect, useMemo, useCallback } from 'react';
import { SaleProductRepositoryImpl } from '../../data/repositories/SaleProductRepositoryImpl';
import { ProductModel, ProductForSale } from '../../data/models/ProductModel';
import { Product } from '../../domain/entities/Product';

// Repository instance created inside hook for better testability
export const useSaleProducts = (companyId: string | undefined, storeId: string | null) => {
  // Memoize repository to prevent unnecessary re-creation
  const repository = useMemo(() => new SaleProductRepositoryImpl(), []);
  const [products, setProducts] = useState<ProductForSale[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currencySymbol, setCurrencySymbol] = useState('₩');
  const [searchQuery, setSearchQuery] = useState('');
  const [currentPage, setCurrentPage] = useState(1);
  const [totalPages, setTotalPages] = useState(1);
  const [totalCount, setTotalCount] = useState(0);

  // Load base currency
  const loadBaseCurrency = async () => {
    if (!companyId) return;

    try {
      const { symbol } = await repository.getBaseCurrency(companyId);
      setCurrencySymbol(symbol);
    } catch (err) {
      console.error('Failed to load base currency:', err);
      // Keep default currency symbol on error
    }
  };

  const loadProducts = async (page: number = 1) => {
    if (!companyId || !storeId) {
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await repository.getProducts(companyId, storeId, page, 20, searchQuery || undefined);

      // Convert Domain Products to ProductForSale for presentation
      // v6: Added variant fields mapping
      const mappedProducts: ProductForSale[] = result.items.map((product: Product) => ({
        product_id: product.id,
        product_name: product.name,
        sku: product.sku,
        barcode: '', // Not available in domain entity
        brand_name: product.brandName,
        category_name: product.categoryName,
        unit: product.unit,
        image_urls: product.imageUrls,
        cost_price: product.costPrice,
        selling_price: product.sellingPrice,
        quantity_available: product.quantityAvailable,
        // v6: variant fields
        variant_id: product.variantId,
        variant_name: product.variantName,
        display_name: product.displayName,
        display_sku: product.displaySku,
        has_variants: product.hasVariants,
      }));

      setProducts(mappedProducts);
      setTotalCount(result.totalCount);
      setTotalPages(result.totalPages);
      setCurrentPage(result.currentPage);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An error occurred');
    } finally {
      setLoading(false);
    }
  };

  // Load base currency on mount or when companyId changes
  useEffect(() => {
    loadBaseCurrency();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [companyId]);

  // Debounced search - wait 300ms after user stops typing
  useEffect(() => {
    const timer = setTimeout(() => {
      loadProducts(1);
      setCurrentPage(1);
    }, 300);

    return () => clearTimeout(timer);
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [companyId, storeId, searchQuery]);

  const goToPage = (page: number) => {
    if (page >= 1 && page <= totalPages) {
      loadProducts(page);
    }
  };

  const nextPage = () => {
    if (currentPage < totalPages) {
      goToPage(currentPage + 1);
    }
  };

  const prevPage = () => {
    if (currentPage > 1) {
      goToPage(currentPage - 1);
    }
  };

  /**
   * Convert ProductForSale to Domain Product Entity
   * This keeps the data layer conversion logic within the hook
   * following Clean Architecture principles
   */
  const convertToDomainProduct = useCallback((saleProduct: ProductForSale): Product => {
    return ProductModel.fromSaleProduct(saleProduct);
  }, []);

  return {
    products,
    loading,
    error,
    currencySymbol,
    searchQuery,
    setSearchQuery,
    currentPage,
    totalPages,
    totalCount,
    goToPage,
    nextPage,
    prevPage,
    refresh: () => loadProducts(currentPage),
    convertToDomainProduct,
  };
};
