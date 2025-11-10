/**
 * useBalanceSheet Hook
 * Custom hook for balance sheet data management
 */

import { useState, useEffect, useCallback } from 'react';
import { BalanceSheetData } from '../../domain/entities/BalanceSheetData';
import { BalanceSheetRepositoryImpl } from '../../data/repositories/BalanceSheetRepositoryImpl';

export const useBalanceSheet = (companyId: string, initialStoreId: string | null) => {
  const [balanceSheet, setBalanceSheet] = useState<BalanceSheetData | null>(null);
  const [loading, setLoading] = useState(false); // Start with false - no auto-load
  const [error, setError] = useState<string | null>(null);
  const [storeId, setStoreId] = useState<string | null>(initialStoreId);
  const [startDate, setStartDate] = useState<string | null>(null);
  const [endDate, setEndDate] = useState<string | null>(null);

  const repository = new BalanceSheetRepositoryImpl();

  const loadBalanceSheet = useCallback(
    async (
      overrideStoreId?: string | null,
      overrideStartDate?: string | null,
      overrideEndDate?: string | null
    ) => {
      setLoading(true);
      setError(null);

      // Use override values if provided, otherwise use state values
      const finalStoreId = overrideStoreId !== undefined ? overrideStoreId : storeId;
      const finalStartDate = overrideStartDate !== undefined ? overrideStartDate : startDate;
      const finalEndDate = overrideEndDate !== undefined ? overrideEndDate : endDate;

      try {
        const result = await repository.getBalanceSheet(
          companyId,
          finalStoreId,
          finalStartDate,
          finalEndDate
        );

        if (!result.success) {
          setError(result.error || 'Failed to load balance sheet');
          setBalanceSheet(null);
          return;
        }

        setBalanceSheet(result.data || null);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An unexpected error occurred');
        setBalanceSheet(null);
      } finally {
        setLoading(false);
      }
    },
    [companyId, storeId, startDate, endDate]
  );

  // Removed auto-load useEffect - user must click Search button to load data

  const changeDateRange = useCallback((start: string | null, end: string | null) => {
    setStartDate(start);
    setEndDate(end);
  }, []);

  const changeStore = useCallback((store: string | null) => {
    setStoreId(store);
  }, []);

  const refresh = useCallback(() => {
    loadBalanceSheet();
  }, [loadBalanceSheet]);

  return {
    balanceSheet,
    loading,
    error,
    storeId,
    startDate,
    endDate,
    changeDateRange,
    changeStore,
    refresh,
    loadBalanceSheet, // Expose for manual triggering
  };
};
