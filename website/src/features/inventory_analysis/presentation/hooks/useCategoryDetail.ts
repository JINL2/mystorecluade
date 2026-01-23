/**
 * useCategoryDetail Hook
 * Fetches category detail data from RPC
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { categoryDetailRepository } from '../../data/repositories/CategoryDetailRepository';
import type { CategoryDetail } from '../../domain/entities/categoryDetail';

export interface UseCategoryDetailOptions {
  autoLoad?: boolean;
}

export interface UseCategoryDetailResult {
  data: CategoryDetail | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

/**
 * Get current month in YYYY-MM format
 */
function getCurrentMonth(): string {
  const now = new Date();
  const year = now.getFullYear();
  const month = String(now.getMonth() + 1).padStart(2, '0');
  return `${year}-${month}`;
}

export const useCategoryDetail = (
  companyId: string | undefined,
  categoryId: string | undefined,
  month?: string,
  options: UseCategoryDetailOptions = {}
): UseCategoryDetailResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<CategoryDetail | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Use provided month or default to current month
  const effectiveMonth = useMemo(() => {
    return month ?? getCurrentMonth();
  }, [month]);

  const fetchData = useCallback(async () => {
    if (!companyId || !categoryId) {
      setData(null);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await categoryDetailRepository.getCategoryDetail({
        companyId,
        categoryId,
        month: effectiveMonth,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch category detail';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, categoryId, effectiveMonth]);

  useEffect(() => {
    if (autoLoad && companyId && categoryId) {
      fetchData();
    }
  }, [autoLoad, companyId, categoryId, effectiveMonth, fetchData]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
  };
};

// Export helper function for external use
export { getCurrentMonth };
