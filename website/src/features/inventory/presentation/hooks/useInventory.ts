/**
 * useInventory Hook
 * Custom hook for inventory management
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { InventoryItem } from '../../domain/entities/InventoryItem';
import { InventoryRepositoryImpl } from '../../data/repositories/InventoryRepositoryImpl';
import { InventoryValidator } from '../../domain/validators/InventoryValidator';
import type { UpdateProductData } from '../../domain/repositories/IInventoryRepository';

export const useInventory = (companyId: string, storeId: string | null, searchQuery: string) => {
  const [inventory, setInventory] = useState<InventoryItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currencySymbol, setCurrencySymbol] = useState('₩');
  const [currencyCode, setCurrencyCode] = useState('VND');

  // Create repository instance once using useMemo
  const repository = useMemo(() => new InventoryRepositoryImpl(), []);

  const loadInventory = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      // Pass search query to backend (pagination handled by backend)
      const result = await repository.getInventory(
        companyId,
        storeId,
        1, // page
        1000, // limit - set high to get all items for now
        searchQuery || undefined
      );

      if (!result.success) {
        setError(result.error || 'Failed to load inventory');
        setInventory([]);
        return;
      }

      // Set currency symbol and code from API response
      if (result.currency?.symbol) {
        setCurrencySymbol(result.currency.symbol);
      }
      if (result.currency?.code) {
        setCurrencyCode(result.currency.code);
      }

      // Sort products by created_at DESC (newest first) on client-side
      // This ensures the order remains consistent even after editing products
      // createdAt is now a Date object (Local time) from InventoryItemModel
      const sortedInventory = (result.data || []).sort((a, b) => {
        // Handle missing dates - put items without dates at the end
        if (!a.createdAt && !b.createdAt) return 0;
        if (!a.createdAt) return 1;
        if (!b.createdAt) return -1;

        // Both dates exist - compare timestamps
        return b.createdAt.getTime() - a.createdAt.getTime(); // DESC order (newest first)
      });

      setInventory(sortedInventory);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setInventory([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId, searchQuery]);

  useEffect(() => {
    if (companyId) {
      loadInventory();
    }
  }, [companyId, storeId, searchQuery, loadInventory]);

  const refresh = useCallback(() => {
    loadInventory();
  }, [loadInventory]);

  // Update product function with validation
  const updateProduct = useCallback(
    async (
      productId: string,
      data: UpdateProductData
    ): Promise<{ success: boolean; error?: string }> => {
      if (!companyId || !storeId) {
        return {
          success: false,
          error: 'Company ID and Store ID are required',
        };
      }

      // 1. Validate product data using domain validator
      const validationErrors = InventoryValidator.validateProduct({
        productName: data.productName,
        sku: data.sku,
        costPrice: data.costPrice,
        sellingPrice: data.sellingPrice,
        currentStock: data.currentStock,
      });

      if (validationErrors.length > 0) {
        // Return first validation error
        return {
          success: false,
          error: validationErrors[0].message,
        };
      }

      // 2. Call repository to update product
      try {
        const result = await repository.updateProduct(productId, companyId, storeId, data);

        if (result.success) {
          // Refresh inventory after successful update
          await loadInventory();
        }

        return result;
      } catch (err) {
        return {
          success: false,
          error: err instanceof Error ? err.message : 'An unexpected error occurred',
        };
      }
    },
    [companyId, storeId, repository, loadInventory]
  );

  return {
    inventory,
    loading,
    error,
    refresh,
    currencySymbol,
    currencyCode,
    updateProduct,
  };
};
