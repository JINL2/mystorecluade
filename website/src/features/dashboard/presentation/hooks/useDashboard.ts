/**
 * useDashboard Hook
 * Presentation layer - Custom hook for dashboard data management
 */

import { useState, useEffect } from 'react';
import { DashboardData } from '../../domain/entities/DashboardData';
import { DashboardRepositoryImpl } from '../../data/repositories/DashboardRepositoryImpl';

export const useDashboard = (companyId: string) => {
  const [data, setData] = useState<DashboardData | null>(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const repository = new DashboardRepositoryImpl();

  const loadDashboardData = async () => {
    setLoading(true);
    setError(null);

    try {
      // Get current date in ISO format
      const currentDate = new Date().toISOString();

      const result = await repository.getDashboardData(companyId, currentDate);

      if (!result.success || !result.data) {
        setError(result.error || 'Failed to load dashboard data');
        setData(null);
        return;
      }

      setData(result.data);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setData(null);
    } finally {
      setLoading(false);
    }
  };

  useEffect(() => {
    if (companyId) {
      loadDashboardData();
    }
  }, [companyId]);

  const refresh = () => {
    loadDashboardData();
  };

  return {
    data,
    loading,
    error,
    refresh,
  };
};
