/**
 * BalanceSheetProvider
 * Zustand store for balance-sheet feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import { BalanceSheetState } from './states/balance_sheet_state';
import { BalanceSheetRepositoryImpl } from '../../data/repositories/BalanceSheetRepositoryImpl';
import { BalanceSheetValidator } from '../../domain/validators/BalanceSheetValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new BalanceSheetRepositoryImpl();

/**
 * Helper functions to get current month's first and last day
 * Uses DateTimeUtils to avoid timezone-related date shifting
 */
const getFirstDayOfMonth = (): string => {
  const now = new Date();
  const firstDay = new Date(now.getFullYear(), now.getMonth(), 1);
  return DateTimeUtils.toDateOnly(firstDay);
};

const getLastDayOfMonth = (): string => {
  const now = new Date();
  const lastDay = new Date(now.getFullYear(), now.getMonth() + 1, 0);
  return DateTimeUtils.toDateOnly(lastDay);
};

/**
 * Balance Sheet Store
 * Zustand store for balance sheet state management
 */
export const useBalanceSheetStore = create<BalanceSheetState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  companyId: '',
  storeId: null,
  startDate: getFirstDayOfMonth(),
  endDate: getLastDayOfMonth(),
  balanceSheet: null,
  loading: false,
  error: null,
  validationErrors: {},

  // ============================================
  // STATE ACTIONS (SETTERS)
  // ============================================

  setCompanyId: (companyId: string) => {
    set({ companyId });
  },

  setStoreId: (storeId: string | null) => {
    set({ storeId, validationErrors: {} });
  },

  setDateRange: (startDate: string | null, endDate: string | null) => {
    set({ startDate, endDate, validationErrors: {} });
  },

  setStartDate: (startDate: string | null) => {
    set({ startDate, validationErrors: {} });
  },

  setEndDate: (endDate: string | null) => {
    set({ endDate, validationErrors: {} });
  },

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  loadBalanceSheet: async (
    overrideStoreId?: string | null,
    overrideStartDate?: string | null,
    overrideEndDate?: string | null
  ) => {
    const state = get();

    // Use override values if provided, otherwise use state values
    const finalStoreId = overrideStoreId !== undefined ? overrideStoreId : state.storeId;
    const finalStartDate = overrideStartDate !== undefined ? overrideStartDate : state.startDate;
    const finalEndDate = overrideEndDate !== undefined ? overrideEndDate : state.endDate;

    // Step 1: Validate filters using Validator
    const validationResult = BalanceSheetValidator.validateFilters({
      companyId: state.companyId,
      storeId: finalStoreId,
      startDate: finalStartDate,
      endDate: finalEndDate,
    });

    if (validationResult.length > 0) {
      console.log('🚫 Validation errors:', validationResult);

      // Convert validation errors to map
      const errorMap: Record<string, string> = {};
      validationResult.forEach((err) => {
        errorMap[err.field] = err.message;
      });

      set({
        validationErrors: errorMap,
        error: 'Please fix validation errors',
        balanceSheet: null,
      });

      return { success: false, error: 'Validation failed' };
    }

    // Clear validation errors
    set({ validationErrors: {}, loading: true, error: null });

    try {
      // Step 2: Call Repository for data
      const result = await repository.getBalanceSheet(
        state.companyId,
        finalStoreId,
        finalStartDate,
        finalEndDate
      );

      if (!result.success) {
        set({
          error: result.error || 'Failed to load balance sheet',
          balanceSheet: null,
          loading: false,
        });
        return { success: false, error: result.error };
      }

      // Step 3: Validate balance equation (business rule check)
      if (result.data) {
        const balanceCheck = BalanceSheetValidator.validateBalanceEquation(
          result.data.totalAssets,
          result.data.totalLiabilitiesAndEquity
        );

        if (!balanceCheck.valid) {
          console.warn('⚠️ Balance equation warning:', balanceCheck.message);
        }
      }

      set({
        balanceSheet: result.data || null,
        loading: false,
      });

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      set({
        error: errorMessage,
        balanceSheet: null,
        loading: false,
      });
      return { success: false, error: errorMessage };
    }
  },

  refresh: async () => {
    await get().loadBalanceSheet();
  },

  reset: () => {
    set({
      storeId: null,
      startDate: getFirstDayOfMonth(),
      endDate: getLastDayOfMonth(),
      balanceSheet: null,
      loading: false,
      error: null,
      validationErrors: {},
    });
  },

  clearFilters: () => {
    set({
      storeId: null,
      startDate: getFirstDayOfMonth(),
      endDate: getLastDayOfMonth(),
      validationErrors: {},
    });
  },
}));
