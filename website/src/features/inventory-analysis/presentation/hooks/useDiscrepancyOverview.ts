/**
 * useDiscrepancyOverview Hook
 * Fetches discrepancy overview data from RPC
 */

import { useState, useEffect, useCallback } from 'react';
import { discrepancyRepository } from '../../data/repositories/DiscrepancyRepository';
import type { DiscrepancyOverview } from '../../domain/entities/discrepancyOverview';

export interface UseDiscrepancyOverviewOptions {
  autoLoad?: boolean;
  period?: '7d' | '30d';
}

export interface UseDiscrepancyOverviewResult {
  data: DiscrepancyOverview | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

export const useDiscrepancyOverview = (
  companyId: string | undefined,
  options: UseDiscrepancyOverviewOptions = {}
): UseDiscrepancyOverviewResult => {
  const { autoLoad = true, period } = options;

  const [data, setData] = useState<DiscrepancyOverview | null>(null);
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
      const result = await discrepancyRepository.getDiscrepancyOverview({
        companyId,
        period,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch discrepancy overview';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, period]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, period, fetchData]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
  };
};
