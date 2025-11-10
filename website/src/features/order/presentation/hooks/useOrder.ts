/**
 * useOrder Hook
 * Custom hook for order management
 */

import { useState, useEffect, useCallback } from 'react';
import { Order } from '../../domain/entities/Order';
import { OrderRepositoryImpl } from '../../data/repositories/OrderRepositoryImpl';

export const useOrder = (companyId: string, storeId: string | null) => {
  const [orders, setOrders] = useState<Order[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  const repository = new OrderRepositoryImpl();

  const loadOrders = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const result = await repository.getOrders(companyId, storeId);

      if (!result.success) {
        setError(result.error || 'Failed to load orders');
        setOrders([]);
        return;
      }

      setOrders(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setOrders([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    if (companyId) {
      loadOrders();
    }
  }, [companyId, storeId, loadOrders]);

  const refresh = useCallback(() => {
    loadOrders();
  }, [loadOrders]);

  return {
    orders,
    loading,
    error,
    refresh,
  };
};
