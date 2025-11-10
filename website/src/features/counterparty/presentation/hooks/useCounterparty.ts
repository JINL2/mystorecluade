/**
 * useCounterparty Hook
 */

import { useState, useEffect, useCallback } from 'react';
import { Counterparty, CounterpartyType } from '../../domain/entities/Counterparty';
import { CounterpartyRepositoryImpl } from '../../data/repositories/CounterpartyRepositoryImpl';

export const useCounterparty = (companyId: string) => {
  const [counterparties, setCounterparties] = useState<Counterparty[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const repository = new CounterpartyRepositoryImpl();

  const loadCounterparties = useCallback(async () => {
    if (!companyId) {
      setCounterparties([]);
      setLoading(false);
      return;
    }
    setLoading(true);
    setError(null);
    try {
      const result = await repository.getCounterparties(companyId);
      if (!result.success) {
        setError(result.error || 'Failed to load');
        setCounterparties([]);
        return;
      }
      setCounterparties(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'Error occurred');
      setCounterparties([]);
    } finally {
      setLoading(false);
    }
  }, [companyId]);

  useEffect(() => {
    loadCounterparties();
  }, [loadCounterparties]);

  const createCounterparty = useCallback(
    async (name: string, type: CounterpartyType, contact: string | null, email: string | null, phone: string | null, address: string | null) => {
      if (!companyId) return { success: false, error: 'Company ID required' };
      const result = await repository.createCounterparty(companyId, name, type, contact, email, phone, address);
      if (result.success) await loadCounterparties();
      return result;
    },
    [companyId, loadCounterparties]
  );

  const updateCounterparty = useCallback(
    async (counterpartyId: string, name: string, contact: string | null, email: string | null, phone: string | null, address: string | null) => {
      const result = await repository.updateCounterparty(counterpartyId, name, contact, email, phone, address);
      if (result.success) await loadCounterparties();
      return result;
    },
    [loadCounterparties]
  );

  const deleteCounterparty = useCallback(
    async (counterpartyId: string) => {
      const result = await repository.deleteCounterparty(counterpartyId);
      if (result.success) await loadCounterparties();
      return result;
    },
    [loadCounterparties]
  );

  return { counterparties, loading, error, createCounterparty, updateCounterparty, deleteCounterparty, refresh: loadCounterparties };
};
