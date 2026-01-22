/**
 * useSalesDashboard Hook
 * Fetches sales dashboard data from RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { salesDashboardRepository } from '../../data/repositories/SalesDashboardRepository';
import type { SalesDashboard } from '../../domain/entities/salesDashboard';

export interface UseSalesDashboardOptions {
  autoLoad?: boolean;
}

export interface UseSalesDashboardResult {
  data: SalesDashboard | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

export const useSalesDashboard = (
  companyId: string | undefined,
  storeId?: string,
  options: UseSalesDashboardOptions = {}
): UseSalesDashboardResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<SalesDashboard | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    if (!companyId) {
      setData(null);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await salesDashboardRepository.getSalesDashboard({
        companyId,
        storeId,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch sales dashboard';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, storeId, fetchData]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
  };
};
