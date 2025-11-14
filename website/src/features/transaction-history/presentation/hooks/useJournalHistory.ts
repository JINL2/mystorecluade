/**
 * useJournalHistory Hook
 * Custom hook wrapper for transaction history Zustand store
 * Follows 2025 Best Practice: Zustand + Custom Hooks pattern
 */

import { useEffect } from 'react';
import { useTransactionHistoryStore } from '../providers/transaction_history_provider';

export const useJournalHistory = (companyId: string) => {
  // Select only needed state and actions from store
  const journalEntries = useTransactionHistoryStore((state) => state.journalEntries);
  const loading = useTransactionHistoryStore((state) => state.loading);
  const error = useTransactionHistoryStore((state) => state.error);
  const hasSearched = useTransactionHistoryStore((state) => state.hasSearched);

  const searchJournalEntries = useTransactionHistoryStore((state) => state.searchJournalEntries);
  const clearSearch = useTransactionHistoryStore((state) => state.clearSearch);
  const setError = useTransactionHistoryStore((state) => state.setError);

  // Set companyId in store when it changes
  useEffect(() => {
    if (companyId) {
      // Inject companyId into store state
      (useTransactionHistoryStore.setState as any)({ companyId });
    }
  }, [companyId]);

  return {
    journalEntries,
    loading,
    error,
    hasSearched,
    searchJournalEntries,
    clearSearch,
    setError,
  };
};
