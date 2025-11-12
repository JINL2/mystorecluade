/**
 * useJournalHistory Hook
 * Custom hook for journal entry history management with search and validation
 */

import { useState, useCallback } from 'react';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { journalHistoryRepository } from '../../data/repositories/JournalHistoryRepositoryImpl';
import { TransactionFilterValidator } from '../../domain/validators/TransactionFilterValidator';

export const useJournalHistory = (companyId: string) => {
  const [journalEntries, setJournalEntries] = useState<JournalEntry[]>([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [hasSearched, setHasSearched] = useState(false);

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
        // Validate filter parameters
        const validationErrors = TransactionFilterValidator.validateJournalFilter(
          companyId,
          storeId,
          startDate,
          endDate
        );

        if (validationErrors.length > 0) {
          setError(validationErrors.map((e) => e.message).join(', '));
          setJournalEntries([]);
          setLoading(false);
          return;
        }

        const result = await journalHistoryRepository.getJournalEntries(
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
    [companyId]
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
