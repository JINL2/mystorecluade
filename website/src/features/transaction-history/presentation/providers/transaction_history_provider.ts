/**
 * Transaction History Zustand Store
 * Centralized state management for transaction history feature
 */

import { create } from 'zustand';
import { TransactionHistoryState } from './states/transaction_history_state';
import { JournalHistoryRepositoryImpl } from '../../data/repositories/JournalHistoryRepositoryImpl';
import { TransactionFilterValidator } from '../../domain/validators/TransactionFilterValidator';

const repository = new JournalHistoryRepositoryImpl();

export const useTransactionHistoryStore = create<TransactionHistoryState>((set, get) => ({
  // Initial State
  journalEntries: [],
  loading: false,
  error: null,
  hasSearched: false,

  // Filter State
  currentStoreId: null,
  currentStartDate: null,
  currentEndDate: null,

  // Actions
  searchJournalEntries: async (storeId, startDate, endDate) => {
    const state = get();

    set({ loading: true, error: null, hasSearched: true });

    try {
      // Get companyId from the current state or expect it to be set externally
      // Note: companyId should be set when the store is initialized
      const companyId = (state as any).companyId || '';

      if (!companyId) {
        set({
          error: 'No company selected',
          journalEntries: [],
          loading: false
        });
        return;
      }

      // Validate filter parameters
      const validationErrors = TransactionFilterValidator.validateJournalFilter(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (validationErrors.length > 0) {
        set({
          error: validationErrors.map((e) => e.message).join(', '),
          journalEntries: [],
          loading: false,
        });
        return;
      }

      const result = await repository.getJournalEntries(
        companyId,
        storeId,
        startDate,
        endDate,
        null
      );

      if (!result.success) {
        set({
          error: result.error || 'Failed to load journal entries',
          journalEntries: [],
          loading: false,
        });
        return;
      }

      set({
        journalEntries: result.data || [],
        currentStoreId: storeId,
        currentStartDate: startDate,
        currentEndDate: endDate,
        loading: false,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        journalEntries: [],
        loading: false,
      });
    }
  },

  clearSearch: () => {
    set({
      journalEntries: [],
      hasSearched: false,
      error: null,
      currentStoreId: null,
      currentStartDate: null,
      currentEndDate: null,
    });
  },

  setError: (error) => {
    set({ error });
  },

  reset: () => {
    set({
      journalEntries: [],
      loading: false,
      error: null,
      hasSearched: false,
      currentStoreId: null,
      currentStartDate: null,
      currentEndDate: null,
    });
  },
}));
