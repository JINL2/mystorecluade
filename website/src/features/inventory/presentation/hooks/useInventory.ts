/**
 * useInventory Hook
 * Custom hook for inventory management
 */

import { useState, useEffect, useCallback } from 'react';
import { InventoryItem } from '../../domain/entities/InventoryItem';
import { InventoryRepositoryImpl } from '../../data/repositories/InventoryRepositoryImpl';

export const useInventory = (companyId: string, storeId: string | null, searchQuery: string) => {
  const [inventory, setInventory] = useState<InventoryItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [currencySymbol, setCurrencySymbol] = useState('₩');
  const [currencyCode, setCurrencyCode] = useState('VND');

  const repository = new InventoryRepositoryImpl();

  const loadInventory = useCallback(async () => {
    console.log('🔄 Loading inventory with:', { companyId, storeId, searchQuery });
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
      console.log('✅ Inventory loaded:', result.data?.length, 'items');

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
      const sortedInventory = (result.data || []).sort((a, b) => {
        const dateA = new Date(a.createdAt || 0).getTime();
        const dateB = new Date(b.createdAt || 0).getTime();
        return dateB - dateA; // DESC order (newest first)
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

  return {
    inventory,
    loading,
    error,
    refresh,
    currencySymbol,
    currencyCode,
  };
};
