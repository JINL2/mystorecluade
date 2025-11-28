/**
 * Transaction History Zustand Store
 * Centralized state management for transaction history feature
 */

import { create } from 'zustand';
import { TransactionHistoryState, AccountInfo } from './states/transaction_history_state';
import { JournalHistoryRepositoryImpl } from '../../data/repositories/JournalHistoryRepositoryImpl';
import { TransactionFilterValidator } from '../../domain/validators/TransactionFilterValidator';
import { TransactionHistoryDataSource } from '../../data/datasources/TransactionHistoryDataSource';
import { JournalEntry } from '../../domain/entities/JournalEntry';

const repository = new JournalHistoryRepositoryImpl();
const dataSource = new TransactionHistoryDataSource();

// Helper function to extract unique accounts from journal entries
const extractUniqueAccounts = (entries: JournalEntry[]): AccountInfo[] => {
  const accountMap = new Map<string, string>();
  entries.forEach((entry) => {
    entry.lines.forEach((line) => {
      if (line.accountId && line.accountName && !accountMap.has(line.accountId)) {
        accountMap.set(line.accountId, line.accountName);
      }
    });
  });
  return Array.from(accountMap.entries())
    .map(([accountId, accountName]) => ({ accountId, accountName }))
    .sort((a, b) => a.accountName.localeCompare(b.accountName));
};

// Helper function to apply filters to entries (client-side filtering)
const applyFilters = (
  entries: JournalEntry[],
  createdByIds: string[],
  accountIds: string[]
): JournalEntry[] => {
  let filtered = entries;

  // Filter by createdBy if any selected
  if (createdByIds.length > 0) {
    filtered = filtered.filter(entry => createdByIds.includes(entry.createdBy));
  }

  // Filter by account if any selected
  if (accountIds.length > 0) {
    filtered = filtered.filter(entry =>
      entry.lines.some(line => accountIds.includes(line.accountId))
    );
  }

  return filtered;
};

export const useTransactionHistoryStore = create<TransactionHistoryState>((set, get) => ({
  // Initial State
  journalEntries: [],
  allJournalEntries: [],
  loading: false,
  error: null,
  hasSearched: false,

  // Company ID (injected by useJournalHistory hook)
  companyId: '',

  // Employee State
  employees: [],
  employeesLoading: false,

  // Account State
  accounts: [],

  // Filter State
  currentStoreId: null,
  currentStartDate: null,
  currentEndDate: null,
  currentCreatedByIds: [],
  currentAccountIds: [],

  // Actions
  searchJournalEntries: async (storeId, startDate, endDate) => {
    const state = get();

    set({ loading: true, error: null, hasSearched: true });

    try {
      // Get companyId from the state (injected by useJournalHistory hook)
      const companyId = state.companyId;

      if (!companyId) {
        set({
          error: 'No company selected',
          journalEntries: [],
          allJournalEntries: [],
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
          allJournalEntries: [],
          loading: false,
        });
        return;
      }

      const result = await repository.getJournalEntries(
        companyId,
        storeId,
        startDate,
        endDate,
        null,
        null
      );

      if (!result.success) {
        set({
          error: result.error || 'Failed to load journal entries',
          journalEntries: [],
          allJournalEntries: [],
          loading: false,
        });
        return;
      }

      const entries = result.data || [];
      const accounts = extractUniqueAccounts(entries);

      set({
        journalEntries: entries,
        allJournalEntries: entries,
        accounts,
        currentStoreId: storeId,
        currentStartDate: startDate,
        currentEndDate: endDate,
        currentCreatedByIds: [],
        currentAccountIds: [],
        loading: false,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        journalEntries: [],
        allJournalEntries: [],
        loading: false,
      });
    }
  },

  setCreatedByFilter: (createdByIds) => {
    const state = get();
    const filtered = applyFilters(state.allJournalEntries, createdByIds, state.currentAccountIds);
    set({
      currentCreatedByIds: createdByIds,
      journalEntries: filtered,
    });
  },

  setAccountFilter: (accountIds) => {
    const state = get();
    const filtered = applyFilters(state.allJournalEntries, state.currentCreatedByIds, accountIds);
    set({
      currentAccountIds: accountIds,
      journalEntries: filtered,
    });
  },

  fetchEmployees: async () => {
    const state = get();
    const companyId = state.companyId;

    if (!companyId) {
      return;
    }

    // Skip if already loaded
    if (state.employees.length > 0) {
      return;
    }

    set({ employeesLoading: true });

    try {
      const employees = await dataSource.getEmployees(companyId);
      set({ employees, employeesLoading: false });
    } catch (err) {
      console.error('Failed to fetch employees:', err);
      set({ employeesLoading: false });
    }
  },

  clearSearch: () => {
    set({
      journalEntries: [],
      allJournalEntries: [],
      hasSearched: false,
      error: null,
      accounts: [],
      currentStoreId: null,
      currentStartDate: null,
      currentEndDate: null,
      currentCreatedByIds: [],
      currentAccountIds: [],
    });
  },

  setError: (error) => {
    set({ error });
  },

  reset: () => {
    const state = get();
    set({
      journalEntries: [],
      allJournalEntries: [],
      loading: false,
      error: null,
      hasSearched: false,
      companyId: state.companyId, // Preserve companyId on reset
      employees: [],
      employeesLoading: false,
      accounts: [],
      currentStoreId: null,
      currentStartDate: null,
      currentEndDate: null,
      currentCreatedByIds: [],
      currentAccountIds: [],
    });
  },
}));
