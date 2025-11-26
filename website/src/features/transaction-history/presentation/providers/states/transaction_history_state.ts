/**
 * Transaction History State Interface
 * State type definitions for transaction history feature using Zustand
 */

import { JournalEntry } from '../../../domain/entities/JournalEntry';
import { EmployeeInfo } from '../../../data/datasources/TransactionHistoryDataSource';

export interface AccountInfo {
  accountId: string;
  accountName: string;
}

export interface TransactionHistoryState {
  // State
  journalEntries: JournalEntry[];
  loading: boolean;
  error: string | null;
  hasSearched: boolean;

  // Employee State
  employees: EmployeeInfo[];
  employeesLoading: boolean;

  // Account State (extracted from search results)
  accounts: AccountInfo[];

  // Filter State
  currentStoreId: string | null;
  currentStartDate: string | null;
  currentEndDate: string | null;
  currentCreatedBy: string | null;
  currentAccountId: string | null;

  // Actions
  searchJournalEntries: (
    storeId: string | null,
    startDate: string | null,
    endDate: string | null,
    createdBy?: string | null,
    accountId?: string | null
  ) => Promise<void>;
  setCreatedByFilter: (createdBy: string | null) => void;
  setAccountFilter: (accountId: string | null) => void;
  fetchEmployees: () => Promise<void>;
  clearSearch: () => void;
  setError: (error: string | null) => void;
  reset: () => void;
}
