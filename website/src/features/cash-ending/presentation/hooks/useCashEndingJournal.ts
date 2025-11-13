/**
 * useCashEndingJournal Hook
 * Custom hook wrapper for journal entry creation
 * Following 2025 Best Practice - Zustand Provider Wrapper Pattern
 */

import { useCashEndingStore } from '../providers/cash_ending_provider';

export type { CreateJournalParams } from '../../domain/validators/CashEndingJournalValidator';

/**
 * Custom hook for cash ending journal entry management
 * Wraps Zustand store journal actions
 */
export const useCashEndingJournal = () => {
  // Select loading state
  const isLoading = useCashEndingStore((state) => state.isCreatingJournal);

  // Select error state
  const error = useCashEndingStore((state) => state.journalError);

  // Select action
  const createJournalEntry = useCashEndingStore((state) => state.createJournalEntry);

  return {
    createJournalEntry,
    isLoading,
    error,
  };
};
