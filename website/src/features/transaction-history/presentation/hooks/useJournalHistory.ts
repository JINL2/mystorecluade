/**
 * useJournalHistory Hook
 * Custom hook for journal entry history management with search
 */

import { useState, useCallback } from 'react';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { JournalHistoryRepositoryImpl } from '../../data/repositories/JournalHistoryRepositoryImpl';

export const useJournalHistory = (companyId: string) => {
  const [journalEntries, setJournalEntries] = useState<JournalEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasSearched, setHasSearched] = useState(false);

  const repository = new JournalHistoryRepositoryImpl();

  const searchJournalEntries = useCallback(
    async (storeId: string | null, startDate: string | null, endDate: string | null) => {
      if (!companyId) {
        setError('No company selected');
        return;
      }

      setLoading(true);
      setError(null);
      setHasSearched(true);

      try {
        const result = await repository.getJournalEntries(
          companyId,
          storeId,
          startDate,
          endDate,
          null
        );

        if (!result.success) {
          setError(result.error || 'Failed to load journal entries');
          setJournalEntries([]);
          return;
        }

        setJournalEntries(result.data || []);
      } catch (err) {
        setError(err instanceof Error ? err.message : 'An unexpected error occurred');
        setJournalEntries([]);
      } finally {
        setLoading(false);
      }
    },
    [companyId, repository]
  );

  const clearSearch = useCallback(() => {
    setJournalEntries([]);
    setHasSearched(false);
    setError(null);
  }, []);

  return {
    journalEntries,
    loading,
    error,
    hasSearched,
    searchJournalEntries,
    clearSearch,
  };
};
