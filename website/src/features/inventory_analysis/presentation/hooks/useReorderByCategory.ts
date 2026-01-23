/**
 * useReorderByCategory Hook
 * Fetches reorder by category data from RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { reorderByCategoryRepository } from '../../data/repositories/ReorderByCategoryRepository';
import type { CategoryReorderItem } from '../../domain/entities/reorderByCategory';

export interface UseReorderByCategoryOptions {
  autoLoad?: boolean;
}

export interface UseReorderByCategoryResult {
  data: CategoryReorderItem[];
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
  // Computed values
  totalAbnormal: number;
  totalStockout: number;
  totalCritical: number;
  totalReorderNeeded: number;
}

export const useReorderByCategory = (
  companyId: string | undefined,
  options: UseReorderByCategoryOptions = {}
): UseReorderByCategoryResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<CategoryReorderItem[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    if (!companyId) {
      setData([]);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await reorderByCategoryRepository.getReorderByCategory({
        companyId,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch reorder by category';
      setError(message);
      setData([]);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, fetchData]);

  // Compute totals
  const totalAbnormal = data.reduce((sum, item) => sum + item.abnormalCount, 0);
  const totalStockout = data.reduce((sum, item) => sum + item.stockoutCount, 0);
  const totalCritical = data.reduce((sum, item) => sum + item.criticalCount, 0);
  const totalReorderNeeded = data.reduce((sum, item) => sum + item.reorderNeededCount, 0);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
    totalAbnormal,
    totalStockout,
    totalCritical,
    totalReorderNeeded,
  };
};
