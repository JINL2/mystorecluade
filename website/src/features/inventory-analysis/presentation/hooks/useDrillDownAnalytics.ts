/**
 * useDrillDownAnalytics Hook
 * Fetches drill down analytics data from RPC with hierarchical navigation
 */

import { useState, useEffect, useCallback, useMemo } from 'react';
import { drillDownAnalyticsRepository } from '../../data/repositories/DrillDownAnalyticsRepository';
import type {
  DrillDownAnalytics,
  DrillDownLevel,
} from '../../domain/entities/drillDownAnalytics';

export interface UseDrillDownAnalyticsOptions {
  autoLoad?: boolean;
}

export interface UseDrillDownAnalyticsResult {
  data: DrillDownAnalytics | null;
  loading: boolean;
  error: string | null;
  refetch: () => Promise<void>;
  // Navigation helpers
  drillDown: (itemId: string) => void;
  drillUp: () => void;
  resetToRoot: () => void;
  currentLevel: DrillDownLevel;
  currentParentId: string | null;
  breadcrumbs: BreadcrumbItem[];
}

export interface BreadcrumbItem {
  level: DrillDownLevel;
  parentId: string | null;
  label: string;
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
 * Get next drill down level
 */
function getNextLevel(currentLevel: DrillDownLevel): DrillDownLevel | null {
  switch (currentLevel) {
    case 'category':
      return 'brand';
    case 'brand':
      return 'product';
    case 'product':
      return null; // No more levels
  }
}

/**
 * Get previous drill down level
 */
function getPreviousLevel(currentLevel: DrillDownLevel): DrillDownLevel | null {
  switch (currentLevel) {
    case 'category':
      return null; // Already at root
    case 'brand':
      return 'category';
    case 'product':
      return 'brand';
  }
}

export const useDrillDownAnalytics = (
  companyId: string | undefined,
  storeId?: string,
  dateRange?: { startDate: string; endDate: string },
  options: UseDrillDownAnalyticsOptions = {}
): UseDrillDownAnalyticsResult => {
  const { autoLoad = true } = options;

  const [data, setData] = useState<DrillDownAnalytics | null>(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  // Navigation state
  const [currentLevel, setCurrentLevel] = useState<DrillDownLevel>('category');
  const [currentParentId, setCurrentParentId] = useState<string | null>(null);
  const [breadcrumbs, setBreadcrumbs] = useState<BreadcrumbItem[]>([
    { level: 'category', parentId: null, label: 'Categories' },
  ]);

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
      const result = await drillDownAnalyticsRepository.getDrillDownAnalytics({
        companyId,
        storeId,
        startDate: effectiveDateRange.startDate,
        endDate: effectiveDateRange.endDate,
        level: currentLevel,
        parentId: currentParentId ?? undefined,
      });
      setData(result);
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to fetch drill down analytics';
      setError(message);
      setData(null);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId, effectiveDateRange.startDate, effectiveDateRange.endDate, currentLevel, currentParentId]);

  // Drill down to next level
  const drillDown = useCallback((itemId: string) => {
    const nextLevel = getNextLevel(currentLevel);
    if (!nextLevel) return; // Already at deepest level

    // Find the item name from current data
    let itemName = itemId;
    if (data?.success) {
      const item = data.data.find((d) => d.itemId === itemId);
      if (item) {
        itemName = item.itemName;
      }
    }

    setBreadcrumbs((prev) => [
      ...prev,
      { level: nextLevel, parentId: itemId, label: itemName },
    ]);
    setCurrentLevel(nextLevel);
    setCurrentParentId(itemId);
  }, [currentLevel, data]);

  // Drill up to previous level
  const drillUp = useCallback(() => {
    if (breadcrumbs.length <= 1) return; // Already at root

    const newBreadcrumbs = breadcrumbs.slice(0, -1);
    const previousCrumb = newBreadcrumbs[newBreadcrumbs.length - 1];

    setBreadcrumbs(newBreadcrumbs);
    setCurrentLevel(previousCrumb.level);
    setCurrentParentId(previousCrumb.parentId);
  }, [breadcrumbs]);

  // Reset to root level
  const resetToRoot = useCallback(() => {
    setBreadcrumbs([{ level: 'category', parentId: null, label: 'Categories' }]);
    setCurrentLevel('category');
    setCurrentParentId(null);
  }, []);

  useEffect(() => {
    if (autoLoad && companyId) {
      fetchData();
    }
  }, [autoLoad, companyId, storeId, effectiveDateRange.startDate, effectiveDateRange.endDate, currentLevel, currentParentId, fetchData]);

  return {
    data,
    loading,
    error,
    refetch: fetchData,
    drillDown,
    drillUp,
    resetToRoot,
    currentLevel,
    currentParentId,
    breadcrumbs,
  };
};

// Export helper functions for external use
export { getCurrentMonthRange, getNextLevel, getPreviousLevel };
