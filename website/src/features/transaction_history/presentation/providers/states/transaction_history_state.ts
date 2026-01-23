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
  journalEntries: JournalEntry[];       // Filtered entries for display
  allJournalEntries: JournalEntry[];    // Original unfiltered entries from RPC
  loading: boolean;
  error: string | null;
  hasSearched: boolean;

  // Company ID (injected by useJournalHistory hook)
  companyId: string;

  // Employee State
  employees: EmployeeInfo[];
  employeesLoading: boolean;

  // Account State (extracted from search results)
  accounts: AccountInfo[];

  // Filter State
  currentStoreId: string | null;
  currentStartDate: string | null;
  currentEndDate: string | null;
  currentCreatedByIds: string[];
  currentAccountIds: string[];

  // Actions
  searchJournalEntries: (
    storeId: string | null,
    startDate: string | null,
    endDate: string | null
  ) => Promise<void>;
  setCreatedByFilter: (createdByIds: string[]) => void;
  setAccountFilter: (accountIds: string[]) => void;
  fetchEmployees: () => Promise<void>;
  clearSearch: () => void;
  setError: (error: string | null) => void;
  reset: () => void;
}
