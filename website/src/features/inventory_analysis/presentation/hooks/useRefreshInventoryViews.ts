/**
 * useRefreshInventoryViews Hook
 * Refreshes inventory materialized views
 */

import { useState, useCallback } from 'react';
import { refreshInventoryViewsRepository } from '../../data/repositories/RefreshInventoryViewsRepository';

export interface UseRefreshInventoryViewsResult {
  refresh: () => Promise<boolean>;
  loading: boolean;
  error: string | null;
  lastRefreshed: Date | null;
}

export const useRefreshInventoryViews = (): UseRefreshInventoryViewsResult => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [lastRefreshed, setLastRefreshed] = useState<Date | null>(null);

  const refresh = useCallback(async (): Promise<boolean> => {
    setLoading(true);
    setError(null);

    try {
      await refreshInventoryViewsRepository.refreshViews();
      setLastRefreshed(new Date());
      return true;
    } catch (err) {
      const message = err instanceof Error ? err.message : 'Failed to refresh inventory views';
      setError(message);
      return false;
    } finally {
      setLoading(false);
    }
  }, []);

  return {
    refresh,
    loading,
    error,
    lastRefreshed,
  };
};
