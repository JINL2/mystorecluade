/**
 * JournalInput Zustand Store
 * Centralized state management for journal input feature
 */

import { create } from 'zustand';
import { JournalInputState } from './states/journal_input_state';
import { JournalEntry } from '../../domain/entities/JournalEntry';
import { JournalInputRepositoryImpl } from '../../data/repositories/JournalInputRepositoryImpl';
import { JournalDate } from '../../domain/value-objects/JournalDate';

const repository = new JournalInputRepositoryImpl();

export const useJournalInputStore = create<JournalInputState>((set, get) => ({
  // Initial State
  journalEntry: new JournalEntry('', null, JournalDate.today(), []),
  companyId: '',
  storeId: null,
  userId: '',
  accounts: [],
  cashLocations: [],
  counterparties: [],
  loading: false,
  submitting: false,
  error: null,

  // State Management Actions
  setJournalEntry: (entry) => set({ journalEntry: entry }),

  setAccounts: (accounts) => set({ accounts }),

  setCashLocations: (locations) => set({ cashLocations: locations }),

  setCounterparties: (counterparties) => set({ counterparties }),

  // Transaction Operations
  addTransactionLine: (line) => {
    const state = get();
    const newEntry = state.journalEntry.addTransactionLine(line);
    set({ journalEntry: newEntry });
  },

  updateTransactionLine: (index, line) => {
    const state = get();
    const newEntry = state.journalEntry.updateTransactionLine(index, line);
    set({ journalEntry: newEntry });
  },

  removeTransactionLine: (index) => {
    const state = get();
    const newEntry = state.journalEntry.removeTransactionLine(index);
    set({ journalEntry: newEntry });
  },

  // Journal Operations
  changeJournalDate: (date) => {
    const state = get();
    const newEntry = new JournalEntry(
      state.journalEntry.companyId,
      state.journalEntry.storeId,
      date,
      state.journalEntry.transactionLines
    );
    set({ journalEntry: newEntry });
  },

  resetJournalEntry: (newStoreId) => {
    const state = get();
    const newEntry = new JournalEntry(
      state.companyId,
      newStoreId,
      JournalDate.today(),
      []
    );
    set({ journalEntry: newEntry, storeId: newStoreId });
  },

  // Async Actions - Data Loading
  loadInitialData: async () => {
    const state = get();
    set({ loading: true, error: null });

    try {
      const [accountsData, cashLocationsData, counterpartiesData] = await Promise.all([
        repository.getAccounts(state.companyId),
        repository.getCashLocations(state.companyId, state.storeId),
        repository.getCounterparties(state.companyId),
      ]);

      set({
        accounts: accountsData,
        cashLocations: cashLocationsData,
        counterparties: counterpartiesData,
        loading: false,
      });
    } catch (err) {
      // Data loading errors are handled silently
      // Dropdown components will show empty state with "No items found" message
      console.error('Failed to load initial data:', err);
      set({ loading: false });
    }
  },

  // Async Actions - Submit
  submitJournalEntry: async (description) => {
    const state = get();

    if (!state.journalEntry.canSubmit()) {
      return {
        success: false,
        error: 'Journal entry must be balanced with at least 2 transaction lines',
      };
    }

    set({ submitting: true, error: null });

    try {
      const result = await repository.submitJournalEntry(
        state.journalEntry,
        state.userId,
        description
      );

      if (result.success) {
        // Reset journal entry after successful submission
        const newEntry = new JournalEntry(
          state.companyId,
          state.storeId,
          JournalDate.today(),
          []
        );
        set({ journalEntry: newEntry, submitting: false });
      } else {
        set({ submitting: false, error: result.error });
      }

      return result;
    } catch (err) {
      const errorMessage =
        err instanceof Error ? err.message : 'Failed to submit journal entry';
      set({ submitting: false, error: errorMessage });
      return { success: false, error: errorMessage };
    }
  },

  // Async Actions - Counterparty Operations
  checkAccountMapping: async (companyId, counterpartyId, accountId) => {
    try {
      const mapping = await repository.checkAccountMapping(
        companyId,
        counterpartyId,
        accountId
      );
      return mapping !== null;
    } catch (error) {
      console.error('Error checking account mapping:', error);
      return false;
    }
  },

  getCounterpartyStores: async (linkedCompanyId) => {
    try {
      return await repository.getCounterpartyStores(linkedCompanyId);
    } catch (error) {
      console.error('Error fetching counterparty stores:', error);
      return [];
    }
  },

  getCounterpartyCashLocations: async (linkedCompanyId, storeId) => {
    try {
      return await repository.getCashLocations(linkedCompanyId, storeId);
    } catch (error) {
      console.error('Error fetching counterparty cash locations:', error);
      return [];
    }
  },

  // Reset
  reset: () => {
    const state = get();
    set({
      journalEntry: new JournalEntry(state.companyId, state.storeId, JournalDate.today(), []),
      loading: false,
      submitting: false,
      error: null,
    });
  },
}));
