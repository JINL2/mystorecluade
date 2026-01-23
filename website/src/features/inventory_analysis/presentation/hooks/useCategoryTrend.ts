/**
 * useCategoryTrend Hook
 * Fetches category trend time series data from inventory_statistic_sales_daily
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { supabaseService } from '@/core/services/supabase.service';
import type { TrendDataPoint, CategoryOption } from '../components/CategoryTrendChart/CategoryTrendChart.types';

export interface UseCategoryTrendOptions {
  autoLoad?: boolean;
}

export interface UseCategoryTrendResult {
  data: TrendDataPoint[];
  categories: CategoryOption[];
  selectedCategoryId: string | null;
  setSelectedCategoryId: (id: string | null) => void;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
}

interface DailySalesData {
  sale_date: string;
  category_id: string | null;
  category_name: string | null;
  revenue: number;
}

export const useCategoryTrend = (
  companyId: string | undefined,
  storeId?: string,
  options: UseCategoryTrendOptions = {}
): UseCategoryTrendResult => {
  const { autoLoad = true } = options;

  const [rawData, setRawData] = useState<DailySalesData[]>([]);
  const [categories, setCategories] = useState<CategoryOption[]>([]);
  const [selectedCategoryId, setSelectedCategoryId] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const fetchData = useCallback(async () => {
    if (!companyId) {
      setRawData([]);
      setCategories([]);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      // Calculate date range (last 30 days)
      const thirtyDaysAgo = new Date();
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);
      const startDate = thirtyDaysAgo.toISOString().split('T')[0];

      // Query from pre-aggregated statistics table
      const supabase = supabaseService.getClient();
      let query = supabase
        .from('inventory_statistic_sales_daily')
        .select('sale_date, category_id, category_name, revenue')
        .eq('company_id', companyId)
        .gte('sale_date', startDate);

      if (storeId) {
        query = query.eq('store_id', storeId);
      }

      const { data, error: fetchError } = await query;

      if (fetchError) {
        throw fetchError;
      }

      if (!data || data.length === 0) {
        setRawData([]);
        setCategories([]);
        return;
      }

      setRawData(data);

      // Extract unique categories sorted by total revenue
      const categoryTotals = new Map<string, { name: string; revenue: number }>();
      data.forEach((item) => {
        if (item.category_id && item.category_name) {
          const existing = categoryTotals.get(item.category_id);
          if (existing) {
            existing.revenue += item.revenue || 0;
          } else {
            categoryTotals.set(item.category_id, {
              name: item.category_name,
              revenue: item.revenue || 0,
            });
          }
        }
      });

      const sortedCategories = Array.from(categoryTotals.entries())
        .sort((a, b) => b[1].revenue - a[1].revenue)
        .map(([id, { name }]) => ({ id, name }));

      setCategories(sortedCategories);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch trend data';
      setError(message);
      setRawData([]);
      setCategories([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, storeId, fetchData]);

  // Process and filter data based on selected category
  const filteredData = useMemo(() => {
    if (rawData.length === 0) return [];

    // Group by date
    const dateMap = new Map<string, number>();

    rawData.forEach((item) => {
      // Filter by category if selected
      if (selectedCategoryId && item.category_id !== selectedCategoryId) {
        return;
      }

      const dateKey = item.sale_date.split('T')[0];
      const existing = dateMap.get(dateKey) || 0;
      dateMap.set(dateKey, existing + (item.revenue || 0));
    });

    // Convert to array and sort by date
    const result: TrendDataPoint[] = Array.from(dateMap.entries())
      .map(([date, value]) => ({ date, value }))
      .sort((a, b) => a.date.localeCompare(b.date));

    return result;
  }, [rawData, selectedCategoryId]);

  return {
    data: filteredData,
    categories,
    selectedCategoryId,
    setSelectedCategoryId,
    loading,
    error,
    refetch: fetchData,
  };
};
