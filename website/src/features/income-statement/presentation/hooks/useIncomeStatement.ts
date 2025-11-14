/**
 * useIncomeStatement Hook
 * Custom hook wrapper for income statement provider
 *
 * Following ARCHITECTURE.md pattern:
 * - Hook is a simple wrapper around Zustand provider
 * - No useState or business logic in hook
 * - All state and actions come from provider
 * - Selector optimization to prevent unnecessary re-renders
 */

import { useIncomeStatementStore } from '../providers/income_statement_provider';

/**
 * useIncomeStatement Hook
 * Provides access to income statement state and actions
 *
 * @returns Income statement state and actions
 */
export const useIncomeStatement = () => {
  // Select state with optimized selectors
  const companyId = useIncomeStatementStore((state) => state.companyId);
  const storeId = useIncomeStatementStore((state) => state.storeId);
  const monthlyData = useIncomeStatementStore((state) => state.monthlyData);
  const twelveMonthData = useIncomeStatementStore((state) => state.twelveMonthData);
  const currentFilters = useIncomeStatementStore((state) => state.currentFilters);
  const currency = useIncomeStatementStore((state) => state.currency);
  const loading = useIncomeStatementStore((state) => state.loading);
  const error = useIncomeStatementStore((state) => state.error);
  const messageState = useIncomeStatementStore((state) => state.messageState);

  // Select actions
  const setCompanyId = useIncomeStatementStore((state) => state.setCompanyId);
  const setStoreId = useIncomeStatementStore((state) => state.setStoreId);
  const setCurrentFilters = useIncomeStatementStore((state) => state.setCurrentFilters);
  const closeMessage = useIncomeStatementStore((state) => state.closeMessage);
  const loadMonthlyData = useIncomeStatementStore((state) => state.loadMonthlyData);
  const load12MonthData = useIncomeStatementStore((state) => state.load12MonthData);
  const clearData = useIncomeStatementStore((state) => state.clearData);
  const reset = useIncomeStatementStore((state) => state.reset);

  return {
    // State
    companyId,
    storeId,
    monthlyData,
    twelveMonthData,
    currentFilters,
    currency,
    loading,
    error,
    messageState,

    // Actions
    setCompanyId,
    setStoreId,
    setCurrentFilters,
    closeMessage,
    loadMonthlyData,
    load12MonthData,
    clearData,
    reset,
  };
};
