/**
 * useTracking Hook
 * Custom hook for tracking management
 */

import { useState, useEffect, useCallback } from 'react';
import { TrackingItem } from '../../domain/entities/TrackingItem';
import { TrackingRepositoryImpl } from '../../data/repositories/TrackingRepositoryImpl';

export const useTracking = (companyId: string, storeId: string | null) => {
  const [items, setItems] = useState<TrackingItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const repository = new TrackingRepositoryImpl();

  const loadItems = useCallback(async () => {
    if (!companyId || !storeId) {
      setItems([]);
      setLoading(false);
      return;
    }

    setLoading(true);
    setError(null);

    try {
      const result = await repository.getTrackingItems(companyId, storeId);

      if (!result.success) {
        setError(result.error || 'Failed to load tracking items');
        setItems([]);
        return;
      }

      setItems(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setItems([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    loadItems();
  }, [loadItems]);

  const refresh = useCallback(() => {
    loadItems();
  }, [loadItems]);

  return {
    items,
    loading,
    error,
    refresh,
  };
};
