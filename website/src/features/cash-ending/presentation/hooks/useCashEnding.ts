/**
 * useCashEnding Hook
 * Custom hook wrapper for cash ending state management
 * Following 2025 Best Practice - Zustand Provider Wrapper Pattern
 */

import { useCallback, useEffect } from 'react';
import { useCashEndingStore } from '../providers/cash_ending_provider';

/**
 * Custom hook for cash ending management
 * Wraps Zustand store and provides selected state/actions
 */
export const useCashEnding = (companyId: string, storeId: string | null) => {
  // Select only needed state to prevent unnecessary re-renders
  const cashEndings = useCashEndingStore((state) => state.cashEndings);
  const loading = useCashEndingStore((state) => state.isLoading);
  const error = useCashEndingStore((state) => state.error);
  const selectedDate = useCashEndingStore((state) => state.selectedDate);

  // Select actions
  const setSelectedDate = useCashEndingStore((state) => state.setSelectedDate);
  const loadCashEndings = useCashEndingStore((state) => state.loadCashEndings);
  const refresh = useCashEndingStore((state) => state.refresh);

  // Load cash endings when companyId or storeId changes
  useEffect(() => {
    if (companyId) {
      loadCashEndings(companyId, storeId);
    }
  }, [companyId, storeId, loadCashEndings]);

  // Wrap changeDate for backward compatibility
  const changeDate = useCallback(
    (date: string) => {
      setSelectedDate(date);
    },
    [setSelectedDate]
  );

  return {
    cashEndings,
    loading,
    error,
    selectedDate,
    changeDate,
    refresh,
  };
};
