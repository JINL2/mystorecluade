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

export const useTransactionHistoryStore = create<TransactionHistoryState>((set, get) => ({
  // Initial State
  journalEntries: [],
  loading: false,
  error: null,
  hasSearched: false,

  // Employee State
  employees: [],
  employeesLoading: false,

  // Account State
  accounts: [],

  // Filter State
  currentStoreId: null,
  currentStartDate: null,
  currentEndDate: null,
  currentCreatedBy: null,
  currentAccountId: null,

  // Actions
  searchJournalEntries: async (storeId, startDate, endDate, createdBy, accountId) => {
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
        accountId,
        createdBy
      );

      if (!result.success) {
        set({
          error: result.error || 'Failed to load journal entries',
          journalEntries: [],
          loading: false,
        });
        return;
      }

      const entries = result.data || [];
      // Extract unique accounts only on initial search (no account filter)
      const accounts = accountId ? get().accounts : extractUniqueAccounts(entries);

      set({
        journalEntries: entries,
        accounts,
        currentStoreId: storeId,
        currentStartDate: startDate,
        currentEndDate: endDate,
        currentCreatedBy: createdBy ?? null,
        currentAccountId: accountId ?? null,
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

  setCreatedByFilter: (createdBy) => {
    set({ currentCreatedBy: createdBy });
  },

  setAccountFilter: (accountId) => {
    set({ currentAccountId: accountId });
  },

  fetchEmployees: async () => {
    const state = get();
    const companyId = (state as any).companyId || '';

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
      hasSearched: false,
      error: null,
      accounts: [],
      currentStoreId: null,
      currentStartDate: null,
      currentEndDate: null,
      currentCreatedBy: null,
      currentAccountId: null,
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
      employees: [],
      employeesLoading: false,
      accounts: [],
      currentStoreId: null,
      currentStartDate: null,
      currentEndDate: null,
      currentCreatedBy: null,
      currentAccountId: null,
    });
  },
}));
