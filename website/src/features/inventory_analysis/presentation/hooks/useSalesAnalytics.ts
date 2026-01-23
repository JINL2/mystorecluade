/**
 * useSalesAnalytics Hook
 * Fetches sales analytics data from RPC with flexible parameters
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { salesAnalyticsRepository } from '../../data/repositories/SalesAnalyticsRepository';
import type {
  SalesAnalytics,
  SalesGroupBy,
  SalesDimension,
  SalesMetric,
  OrderDirection,
} from '../../domain/entities/salesAnalytics';

export interface UseSalesAnalyticsOptions {
  autoLoad?: boolean;
  groupBy?: SalesGroupBy;
  dimension?: SalesDimension;
  metric?: SalesMetric;
  categoryId?: string;
  comparePrevious?: boolean;
  orderBy?: OrderDirection;
  topN?: number;
}

export interface UseSalesAnalyticsResult {
  data: SalesAnalytics | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

/**
 * Get current month date range
 */
function getCurrentMonthRange(): { startDate: string; endDate: string } {
  const now = new Date();
  const year = now.getFullYear();
  const month = now.getMonth();

  const startDate = new Date(year, month, 1);
  const endDate = new Date(year, month + 1, 0);

  return {
    startDate: startDate.toISOString().split('T')[0],
    endDate: endDate.toISOString().split('T')[0],
  };
}

/**
 * Get last N days date range
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

export const useSalesAnalytics = (
  companyId: string | undefined,
  storeId?: string,
  dateRange?: { startDate: string; endDate: string },
  options: UseSalesAnalyticsOptions = {}
): UseSalesAnalyticsResult => {
  const {
    autoLoad = true,
    groupBy = 'monthly',
    dimension = 'total',
    metric = 'revenue',
    categoryId,
    comparePrevious = true,
    orderBy = 'DESC',
    topN,
  } = options;

  const [data, setData] = useState<SalesAnalytics | null>(null);
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
      const result = await salesAnalyticsRepository.getSalesAnalytics({
        companyId,
        storeId,
        startDate: effectiveDateRange.startDate,
        endDate: effectiveDateRange.endDate,
        groupBy,
        dimension,
        metric,
        categoryId,
        comparePrevious,
        orderBy,
        topN,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch sales analytics';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [
    companyId,
    storeId,
    effectiveDateRange.startDate,
    effectiveDateRange.endDate,
    groupBy,
    dimension,
    metric,
    categoryId,
    comparePrevious,
    orderBy,
    topN,
  ]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [
    autoLoad,
    companyId,
    storeId,
    effectiveDateRange.startDate,
    effectiveDateRange.endDate,
    groupBy,
    dimension,
    metric,
    categoryId,
    comparePrevious,
    orderBy,
    topN,
    fetchData,
  ]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
  };
};

// Export helper functions for external use
export { getCurrentMonthRange, getLastNDaysRange };
