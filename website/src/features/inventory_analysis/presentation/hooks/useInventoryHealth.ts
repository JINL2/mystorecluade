/**
 * useInventoryHealth Hook
 * Fetches inventory health dashboard data from RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { inventoryHealthRepository } from '../../data/repositories/InventoryHealthRepository';
import type { InventoryHealthDashboard } from '../../domain/entities/inventoryHealthDashboard';

export interface UseInventoryHealthOptions {
  autoLoad?: boolean;
}

export interface UseInventoryHealthResult {
  data: InventoryHealthDashboard | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

export const useInventoryHealth = (
  companyId: string | undefined,
  options: UseInventoryHealthOptions = {}
): UseInventoryHealthResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<InventoryHealthDashboard | null>(null);
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
      const result = await inventoryHealthRepository.getInventoryHealth({
        companyId,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch inventory health';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, fetchData]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
  };
};
