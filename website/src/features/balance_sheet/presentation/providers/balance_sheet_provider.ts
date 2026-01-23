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

/**
 * Create repository instance (singleton pattern)
 */
const repository = new BalanceSheetRepositoryImpl();

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

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  loadBalanceSheet: async (overrideStoreId?: string | null) => {
    const state = get();

    // Use override values if provided, otherwise use state values
    const finalStoreId = overrideStoreId !== undefined ? overrideStoreId : state.storeId;

    // Step 1: Validate filters using Validator
    const validationResult = BalanceSheetValidator.validateFilters({
      companyId: state.companyId,
      storeId: finalStoreId,
    });

    if (validationResult.length > 0) {
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
      const result = await repository.getBalanceSheet(state.companyId, finalStoreId);

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
        BalanceSheetValidator.validateBalanceEquation(
          result.data.totalAssets,
          result.data.totalLiabilitiesAndEquity
        );
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
      balanceSheet: null,
      loading: false,
      error: null,
      validationErrors: {},
    });
  },

  clearFilters: () => {
    set({
      storeId: null,
      validationErrors: {},
      balanceSheet: null,
    });
  },
}));
