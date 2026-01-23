/**
 * useBcgMatrix Hook
 * Fetches BCG Matrix V2 data from RPC
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { bcgMatrixRepository } from '../../data/repositories/BcgMatrixRepository';
import type { BcgMatrix } from '../../domain/entities/bcgMatrix';

export interface UseBcgMatrixOptions {
  autoLoad?: boolean;
}

export interface UseBcgMatrixResult {
  data: BcgMatrix | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

/**
 * Get date range for the current month
 */
function getCurrentMonthRange(): { startDate: string; endDate: string } {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();

  // First day of current month
  const startDate = new Date(year, month, 1);

  // Last day of current month
  const endDate = new Date(year, month + 1, 0);

  return {
    startDate: startDate.toISOString().split('T')[0],
    endDate: endDate.toISOString().split('T')[0],
  };
}

/**
 * Get date range for last N days
 */
function getLastNDaysRange(days: number): { startDate: string; endDate: string } {
  const now = new Date();
  const endDate = new Date(now);
  const startDate = new Date(now);
  startDate.setDate(startDate.getDate() - days);

  return {
    startDate: startDate.toISOString().split('T')[0],
    endDate: endDate.toISOString().split('T')[0],
  };
}

export const useBcgMatrix = (
  companyId: string | undefined,
  storeId?: string,
  dateRange?: { startDate: string; endDate: string },
  options: UseBcgMatrixOptions = {}
): UseBcgMatrixResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<BcgMatrix | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Use provided date range or default to current month
  const effectiveDateRange = useMemo(() => {
    return dateRange ?? getCurrentMonthRange();
  }, [dateRange]);

  const fetchData = useCallback(async () => {
    if (!companyId) {
      setData(null);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await bcgMatrixRepository.getBcgMatrix({
        companyId,
        storeId,
        startDate: effectiveDateRange.startDate,
        endDate: effectiveDateRange.endDate,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch BCG matrix';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId, effectiveDateRange.startDate, effectiveDateRange.endDate]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, storeId, effectiveDateRange.startDate, effectiveDateRange.endDate, fetchData]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
  };
};

// Export helper functions for external use
export { getCurrentMonthRange, getLastNDaysRange };
