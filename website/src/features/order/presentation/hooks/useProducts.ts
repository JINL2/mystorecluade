/**
 * useProducts Hook
 * Manages product data for order creation
 * Follows Clean Architecture: Presentation → Repository → DataSource
 */

import { useState, useEffect, useCallback } from 'react';
import { ProductRepositoryImpl } from '../../data/repositories/ProductRepositoryImpl';
import { Product } from '../../data/models/ProductModel';

export const useProducts = (companyId: string | null) => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [currencySymbol, setCurrencySymbol] = useState<string>('₩');

  const repository = new ProductRepositoryImpl();

  const fetchProducts = useCallback(async () => {
    if (!companyId) return;

    setLoading(true);
    setError(null);

    try {
      // Use Repository instead of direct supabaseService call
      const result = await repository.getProducts(companyId);

      if (!result.success) {
        setError(result.error || 'Failed to fetch products');
        setProducts([]);
        return;
      }

      if (result.data) {
        setProducts(result.data.products);
        setCurrencySymbol(result.data.currencySymbol);
      }
    } catch (err) {
      console.error('Error fetching products:', err);
      setError(err instanceof Error ? err.message : 'Failed to fetch products');
      setProducts([]);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    if (companyId) {
      fetchProducts();
    } else {
      setProducts([]);
      setCurrencySymbol('₩');
    }
  }, [companyId, fetchProducts]);

  // Get active products only (not deleted)
  const getActiveProducts = useCallback((): Product[] => {
    return products.filter((p) => p.is_active && !p.is_deleted);
  }, [products]);

  // Search products by name, SKU, or barcode
  const searchProducts = useCallback(
    (searchTerm: string): Product[] => {
      const activeProducts = getActiveProducts();
      return repository.searchProducts(activeProducts, searchTerm);
    },
    [products, getActiveProducts]
  );

  // Get product by ID
  const getProductById = useCallback(
    (productId: string): Product | null => {
      return repository.getProductById(products, productId);
    },
    [products]
  );

  // Get product by SKU
  const getProductBySKU = useCallback(
    (sku: string): Product | null => {
      return repository.getProductBySKU(products, sku);
    },
    [products]
  );

  return {
    products,
    loading,
    error,
    currencySymbol,
    refresh: fetchProducts,
    getActiveProducts,
    searchProducts,
    getProductById,
    getProductBySKU,
  };
};
