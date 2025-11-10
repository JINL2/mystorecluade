/**
 * useProducts Hook
 * Manages product data for order creation
 * Follows Clean Architecture: fetches via RPC, provides search functionality
 */

import { useState, useEffect } from 'react';
import { supabaseService } from '@/core/services/supabase_service';

export interface Product {
  product_id: string;
  product_name: string;
  sku?: string;
  barcode?: string;
  unit_of_measure?: string;
  pricing?: {
    selling_price: number;
  };
  total_stock_summary?: {
    total_quantity_on_hand: number;
  };
  status?: {
    is_active: boolean;
    is_deleted: boolean;
  };
}

interface ProductData {
  company: {
    company_name: string;
    currency: {
      code: string;
      symbol: string;
    };
  } | null;
  products: Product[];
  summary: any;
}

export const useProducts = (companyId: string | null) => {
  const [products, setProducts] = useState<Product[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [currencySymbol, setCurrencySymbol] = useState<string>('₩');

  useEffect(() => {
    if (companyId) {
      fetchProducts();
    } else {
      setProducts([]);
      setCurrencySymbol('₩');
    }
  }, [companyId]);

  const fetchProducts = async () => {
    if (!companyId) return;

    setLoading(true);
    setError(null);

    try {
      const { data, error: fetchError } = await supabaseService
        .getClient()
        .rpc('get_inventory_product_list_company', {
          p_company_id: companyId,
        });

      if (fetchError) throw fetchError;

      if (!data || !data.success) {
        throw new Error('Failed to fetch products');
      }

      const productData: ProductData = {
        company: data.data.company || null,
        products: data.data.products || [],
        summary: data.data.summary || null,
      };

      setProducts(productData.products);

      // Update currency symbol if available
      if (productData.company?.currency?.symbol) {
        setCurrencySymbol(productData.company.currency.symbol);
      }
    } catch (err) {
      console.error('Error fetching products:', err);
      setError(err instanceof Error ? err.message : 'Failed to fetch products');
      setProducts([]);
    } finally {
      setLoading(false);
    }
  };

  // Get active products only (not deleted)
  const getActiveProducts = (): Product[] => {
    return products.filter(
      (p) => p.status?.is_active && !p.status?.is_deleted
    );
  };

  // Search products by name, SKU, or barcode
  const searchProducts = (searchTerm: string): Product[] => {
    if (!searchTerm || searchTerm.length < 1) {
      return [];
    }

    const lowerSearchTerm = searchTerm.toLowerCase();
    const activeProducts = getActiveProducts();

    return activeProducts.filter((product) => {
      const productName = (product.product_name || '').toLowerCase();
      const sku = (product.sku || '').toLowerCase();
      const barcode = (product.barcode || '').toLowerCase();

      return (
        productName.includes(lowerSearchTerm) ||
        sku.includes(lowerSearchTerm) ||
        barcode.includes(lowerSearchTerm)
      );
    });
  };

  // Get product by ID
  const getProductById = (productId: string): Product | null => {
    return products.find((p) => p.product_id === productId) || null;
  };

  // Get product by SKU
  const getProductBySKU = (sku: string): Product | null => {
    return products.find((p) => p.sku === sku) || null;
  };

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
