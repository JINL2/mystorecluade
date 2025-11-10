/**
 * useTransactionHistory Hook
 * Custom hook for transaction history management
 */

import { useState, useEffect, useCallback } from 'react';
import { Transaction } from '../../domain/entities/Transaction';
import { TransactionHistoryRepositoryImpl } from '../../data/repositories/TransactionHistoryRepositoryImpl';

export const useTransactionHistory = (companyId: string, storeId: string | null) => {
  const [transactions, setTransactions] = useState<Transaction[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);
  const [selectedMonth, setSelectedMonth] = useState<string>(
    new Date().toISOString().split('T')[0].substring(0, 7) // YYYY-MM
  );

  const repository = new TransactionHistoryRepositoryImpl();

  const loadTransactions = useCallback(async () => {
    setLoading(true);
    setError(null);

    try {
      // Get start and end dates for selected month
      const [year, month] = selectedMonth.split('-').map(Number);
      const startDate = new Date(year, month - 1, 1).toISOString().split('T')[0];
      const endDate = new Date(year, month, 0).toISOString().split('T')[0];

      const result = await repository.getTransactions(companyId, storeId, startDate, endDate);

      if (!result.success) {
        setError(result.error || 'Failed to load transactions');
        setTransactions([]);
        return;
      }

      setTransactions(result.data || []);
    } catch (err) {
      setError(err instanceof Error ? err.message : 'An unexpected error occurred');
      setTransactions([]);
    } finally {
      setLoading(false);
    }
  }, [companyId, storeId, selectedMonth]);

  useEffect(() => {
    if (companyId) {
      loadTransactions();
    }
  }, [companyId, storeId, selectedMonth, loadTransactions]);

  const changeMonth = useCallback((month: string) => {
    setSelectedMonth(month);
  }, []);

  const refresh = useCallback(() => {
    loadTransactions();
  }, [loadTransactions]);

  return {
    transactions,
    loading,
    error,
    selectedMonth,
    changeMonth,
    refresh,
  };
};
