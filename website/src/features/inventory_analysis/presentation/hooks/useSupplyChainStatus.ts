/**
 * useSupplyChainStatus Hook
 * Fetches supply chain status data from RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { supplyChainRepository } from '../../data/repositories/SupplyChainRepository';
import type { SupplyChainStatus } from '../../domain/entities/supplyChainStatus';

export interface UseSupplyChainStatusOptions {
  autoLoad?: boolean;
}

export interface UseSupplyChainStatusResult {
  data: SupplyChainStatus | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

export const useSupplyChainStatus = (
  companyId: string | undefined,
  options: UseSupplyChainStatusOptions = {}
): UseSupplyChainStatusResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<SupplyChainStatus | null>(null);
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
      const result = await supplyChainRepository.getSupplyChainStatus({
        companyId,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch supply chain status';
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
