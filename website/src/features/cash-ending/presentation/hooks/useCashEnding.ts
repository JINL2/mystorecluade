/**
 * useCashEnding Hook
 * Custom hook for cash ending management
 */

import { useState, useEffect, useCallback } from 'react';
import { CashEnding } from '../../domain/entities/CashEnding';
import { CashEndingRepositoryImpl } from '../../data/repositories/CashEndingRepositoryImpl';

export const useCashEnding = (companyId: string, storeId: string | null) => {
  const [cashEndings, setCashEndings] = useState<CashEnding[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedDate, setSelectedDate] = useState<string>(
    new Date().toISOString().split('T')[0]
  );

  const repository = new CashEndingRepositoryImpl();

  const loadCashEndings = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      const result = await repository.getCashEndings(companyId, storeId);

      if (!result.success) {
        setError(result.error || 'Failed to load cash endings');
        setCashEndings([]);
        return;
      }

      setCashEndings(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setCashEndings([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId]);

  useEffect(() => {
    if (companyId) {
      loadCashEndings();
    }
  }, [companyId, storeId, loadCashEndings]);

  const changeDate = useCallback((date: string) => {
    setSelectedDate(date);
  }, []);

  const refresh = useCallback(() => {
    loadCashEndings();
  }, [loadCashEndings]);

  return {
    cashEndings,
    loading,
    error,
    selectedDate,
    changeDate,
    refresh,
  };
};
