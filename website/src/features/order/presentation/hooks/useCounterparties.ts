/**
 * useCounterparties Hook
 * Manages counterparty (supplier) data for orders
 * Follows Clean Architecture: Presentation → Repository → DataSource
 */

import { useState, useEffect, useCallback } from 'react';
import { CounterpartyRepositoryImpl } from '../../data/repositories/CounterpartyRepositoryImpl';
import { Counterparty } from '../../data/models/CounterpartyModel';

export const useCounterparties = (companyId: string | null) => {
  const [counterparties, setCounterparties] = useState<Counterparty[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const repository = new CounterpartyRepositoryImpl();

  const fetchCounterparties = useCallback(async () => {
    if (!companyId) return;

    setLoading(true);
    setError(null);

    try {
      // Use Repository instead of direct supabaseService call
      const result = await repository.getSuppliers(companyId);

      if (!result.success) {
        setError(result.error || 'Failed to fetch suppliers');
        setCounterparties([]);
        return;
      }

      setCounterparties(result.data || []);
    } catch (err) {
      console.error('Error fetching counterparties:', err);
      setError(err instanceof Error ? err.message : 'Failed to fetch suppliers');
      setCounterparties([]);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    if (companyId) {
      fetchCounterparties();
    } else {
      setCounterparties([]);
    }
  }, [companyId, fetchCounterparties]);

  return { counterparties, loading, error, refresh: fetchCounterparties };
};
