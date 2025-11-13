/**
 * useBalanceSheet Hook
 * Custom hook for balance sheet data management
 *
 * Following Clean Architecture and 2025 Best Practice:
 * - Hook is a wrapper around Zustand Provider
 * - Selector optimization to prevent unnecessary re-renders
 * - Clean API for components
 * - Only exposes PUBLIC actions (ARCHITECTURE.md compliance)
 * - Internal state setters (setBalanceSheet, setLoading, setError) are NOT exposed
 */

import { useBalanceSheetStore } from '../providers/balance_sheet_provider';

/**
 * Balance Sheet Hook
 * Provides optimized selectors for balance sheet state and actions
 */
export const useBalanceSheet = () => {
  // ============================================
  // STATE SELECTORS (optimized)
  // ============================================

  const companyId = useBalanceSheetStore((state) => state.companyId);
  const storeId = useBalanceSheetStore((state) => state.storeId);
  const startDate = useBalanceSheetStore((state) => state.startDate);
  const endDate = useBalanceSheetStore((state) => state.endDate);
  const balanceSheet = useBalanceSheetStore((state) => state.balanceSheet);
  const loading = useBalanceSheetStore((state) => state.loading);
  const error = useBalanceSheetStore((state) => state.error);
  const validationErrors = useBalanceSheetStore((state) => state.validationErrors);

  // ============================================
  // ACTION SELECTORS (PUBLIC API ONLY)
  // ============================================

  const setCompanyId = useBalanceSheetStore((state) => state.setCompanyId);
  const setStoreId = useBalanceSheetStore((state) => state.setStoreId);
  const setDateRange = useBalanceSheetStore((state) => state.setDateRange);
  const setStartDate = useBalanceSheetStore((state) => state.setStartDate);
  const setEndDate = useBalanceSheetStore((state) => state.setEndDate);
  const loadBalanceSheet = useBalanceSheetStore((state) => state.loadBalanceSheet);
  const refresh = useBalanceSheetStore((state) => state.refresh);
  const reset = useBalanceSheetStore((state) => state.reset);
  const clearFilters = useBalanceSheetStore((state) => state.clearFilters);

  // ============================================
  // RETURN API (PUBLIC INTERFACE)
  // ============================================

  return {
    // State (read-only)
    companyId,
    storeId,
    startDate,
    endDate,
    balanceSheet,
    loading,
    error,
    validationErrors,

    // Public Actions (user-facing operations)
    setCompanyId,
    setStoreId,
    setDateRange,
    setStartDate,
    setEndDate,
    loadBalanceSheet,
    refresh,
    reset,
    clearFilters,

    // Convenience aliases (backward compatibility)
    changeStore: setStoreId,
    changeDateRange: setDateRange,
  };
};
