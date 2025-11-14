/**
 * useDashboard Hook
 * Presentation layer - Custom hook for dashboard data management
 *
 * Following 2025 Best Practice:
 * - Zustand store wrapper (selector pattern)
 * - Clean separation of concerns
 * - No direct useState usage
 * - Auto-loads data on mount
 */

import { useEffect } from 'react';
import { useDashboardStore } from '../providers/dashboard_provider';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export interface UseDashboardOptions {
  autoLoad?: boolean;
}

export const useDashboard = (
  companyId: string,
  options: UseDashboardOptions = {}
) => {
  const { autoLoad = true } = options;

  // Select state from Zustand store
  const data = useDashboardStore((state) => state.data);
  const loading = useDashboardStore((state) => state.loading);
  const error = useDashboardStore((state) => state.error);
  const errorDialog = useDashboardStore((state) => state.errorDialog);

  // Select actions from Zustand store
  const loadDashboardData = useDashboardStore((state) => state.loadDashboardData);
  const refreshStore = useDashboardStore((state) => state.refresh);
  const clearError = useDashboardStore((state) => state.clearError);

  // Auto-load data on mount or when companyId changes
  useEffect(() => {
    if (companyId && autoLoad) {
      const currentDate = DateTimeUtils.nowUtcDate();
      loadDashboardData(companyId, currentDate);
    }
  }, [companyId, autoLoad, loadDashboardData]);

  // Wrapper function for refresh to use current companyId
  const refresh = () => {
    refreshStore(companyId);
  };

  return {
    // State
    data,
    loading,
    error,
    errorDialog,

    // Actions
    refresh,
    clearError,
  };
};
