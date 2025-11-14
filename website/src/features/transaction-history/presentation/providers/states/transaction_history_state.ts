/**
 * Transaction History State Interface
 * State type definitions for transaction history feature using Zustand
 */

import { JournalEntry } from '../../../domain/entities/JournalEntry';

export interface TransactionHistoryState {
  // State
  journalEntries: JournalEntry[];
  loading: boolean;
  error: string | null;
  hasSearched: boolean;

  // Filter State
  currentStoreId: string | null;
  currentStartDate: string | null;
  currentEndDate: string | null;

  // Actions
  searchJournalEntries: (
    storeId: string | null,
    startDate: string | null,
    endDate: string | null
  ) => Promise<void>;
  clearSearch: () => void;
  setError: (error: string | null) => void;
  reset: () => void;
}
