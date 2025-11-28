/**
 * useJournalHistory Hook
 * Custom hook wrapper for transaction history Zustand store
 * Follows 2025 Best Practice: Zustand + Custom Hooks pattern
 */

import { useEffect } from 'react';
import { useTransactionHistoryStore } from '../providers/transaction_history_provider';

export const useJournalHistory = (companyId: string) => {
  // Select only needed state and actions from store
  const journalEntries = useTransactionHistoryStore((state) => state.journalEntries);
  const loading = useTransactionHistoryStore((state) => state.loading);
  const error = useTransactionHistoryStore((state) => state.error);
  const hasSearched = useTransactionHistoryStore((state) => state.hasSearched);

  // Employee state
  const employees = useTransactionHistoryStore((state) => state.employees);
  const employeesLoading = useTransactionHistoryStore((state) => state.employeesLoading);

  // Account state
  const accounts = useTransactionHistoryStore((state) => state.accounts);

  // Filter state
  const currentCreatedByIds = useTransactionHistoryStore((state) => state.currentCreatedByIds);
  const currentAccountIds = useTransactionHistoryStore((state) => state.currentAccountIds);
  const currentStoreId = useTransactionHistoryStore((state) => state.currentStoreId);
  const currentStartDate = useTransactionHistoryStore((state) => state.currentStartDate);
  const currentEndDate = useTransactionHistoryStore((state) => state.currentEndDate);

  const searchJournalEntries = useTransactionHistoryStore((state) => state.searchJournalEntries);
  const setCreatedByFilter = useTransactionHistoryStore((state) => state.setCreatedByFilter);
  const setAccountFilter = useTransactionHistoryStore((state) => state.setAccountFilter);
  const fetchEmployees = useTransactionHistoryStore((state) => state.fetchEmployees);
  const clearSearch = useTransactionHistoryStore((state) => state.clearSearch);
  const setError = useTransactionHistoryStore((state) => state.setError);

  // Set companyId in store when it changes and fetch employees
  useEffect(() => {
    if (companyId) {
      // Inject companyId into store state
      (useTransactionHistoryStore.setState as any)({ companyId });
      // Fetch employees on page load
      fetchEmployees();
    }
  }, [companyId, fetchEmployees]);

  return {
    journalEntries,
    loading,
    error,
    hasSearched,
    employees,
    employeesLoading,
    accounts,
    currentCreatedByIds,
    currentAccountIds,
    currentStoreId,
    currentStartDate,
    currentEndDate,
    searchJournalEntries,
    setCreatedByFilter,
    setAccountFilter,
    fetchEmployees,
    clearSearch,
    setError,
  };
};
