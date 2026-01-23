/**
 * Income Statement Provider
 * Zustand store for income statement feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import { IncomeStatementState } from './states/income_statement_state';
import { IncomeStatementRepositoryImpl } from '../../data/repositories/IncomeStatementRepositoryImpl';
import { IncomeStatementValidator } from '../../domain/validators/IncomeStatementValidator';
import type { IncomeStatementFilters, IncomeStatementType } from './states/types';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new IncomeStatementRepositoryImpl();

/**
 * Helper functions for default dates
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

const getFirstDayOfYear = (): string => {
  const now = new Date();
  const firstDay = new Date(now.getFullYear(), 0, 1);
  return DateTimeUtils.toDateOnly(firstDay);
};

const getLastDayOfYear = (): string => {
  const now = new Date();
  const lastDay = new Date(now.getFullYear(), 11, 31);
  return DateTimeUtils.toDateOnly(lastDay);
};

/**
 * Income Statement Store
 * Zustand store for income statement state management
 */
export const useIncomeStatementStore = create<IncomeStatementState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  companyId: '',
  storeId: null,
  statementType: 'monthly',
  fromDate: getFirstDayOfMonth(),
  toDate: getLastDayOfMonth(),
  monthlyData: null,
  twelveMonthData: null,
  currentFilters: null,
  currency: '$',
  loading: false,
  error: null,
  messageState: {
    isOpen: false,
    variant: 'info',
    title: '',
    message: '',
  },

  // ============================================
  // SYNC ACTIONS (STATE SETTERS)
  // ============================================

  setCompanyId: (companyId: string) => {
    set({ companyId });
  },

  setStoreId: (storeId: string | null) => {
    set({ storeId });
  },

  setStatementType: (type: IncomeStatementType) => {
    // Update dates based on type
    if (type === '12month') {
      set({
        statementType: type,
        fromDate: getFirstDayOfYear(),
        toDate: getLastDayOfYear(),
      });
    } else {
      set({
        statementType: type,
        fromDate: getFirstDayOfMonth(),
        toDate: getLastDayOfMonth(),
      });
    }
  },

  setFromDate: (date: string) => {
    set({ fromDate: date });
  },

  setToDate: (date: string) => {
    set({ toDate: date });
  },

  setCurrentFilters: (filters: IncomeStatementFilters | null) => {
    set({ currentFilters: filters });
  },

  closeMessage: () => {
    set({
      messageState: {
        isOpen: false,
        variant: 'info',
        title: '',
        message: '',
      },
    });
  },

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  loadMonthlyData: async (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => {
    console.log('🔄 [Provider] Loading monthly income statement:', {
      companyId,
      storeId,
      startDate,
      endDate,
    });

    set({ loading: true, twelveMonthData: null, error: null });

    try {
      // Step 1: Execute validation using Validator
      const validationResult = IncomeStatementValidator.validateQuery(
        companyId,
        storeId,
        startDate,
        endDate,
        'monthly'
      );

      if (!validationResult.isValid) {
        const errorMessages = validationResult.errors.map((e) => e.message).join(', ');
        console.error('❌ [Provider] Validation failed:', validationResult.errors);

        set({
          monthlyData: null,
          loading: false,
          error: errorMessages,
          messageState: {
            isOpen: true,
            variant: 'warning',
            title: 'Validation Error',
            message: errorMessages,
          },
        });
        return;
      }

      // Step 2: Call Repository
      const result = await repository.getMonthlyIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!result.success) {
        console.error('❌ [Provider] Repository error:', result.error);

        // Determine message variant based on error type
        const isNoData = result.error?.includes('No') || result.error?.includes('available');
        const variant = isNoData ? 'info' : 'error';
        const title = isNoData ? 'No Data Available' : 'Error Loading Data';
        const message =
          result.error ||
          (isNoData
            ? 'No income statement data found for the selected period.'
            : 'Failed to load income statement. Please try again.');

        set({
          monthlyData: null,
          loading: false,
          error: result.error || 'Failed to load data',
          messageState: {
            isOpen: true,
            variant,
            title,
            message,
          },
        });
        return;
      }

      // Step 3: Success - Update state
      set({
        monthlyData: result.data || null,
        currency: result.currency || '$',
        loading: false,
        error: null,
      });

      console.log('✅ [Provider] Monthly income statement loaded successfully');
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      console.error('❌ [Provider] Error loading monthly data:', err);

      set({
        monthlyData: null,
        loading: false,
        error: errorMessage,
        messageState: {
          isOpen: true,
          variant: 'error',
          title: 'Unexpected Error',
          message: errorMessage,
        },
      });
    }
  },

  load12MonthData: async (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => {
    console.log('🔄 [Provider] Loading 12-month income statement:', {
      companyId,
      storeId,
      startDate,
      endDate,
    });

    set({ loading: true, monthlyData: null, error: null });

    try {
      // Step 1: Execute validation using Validator
      const validationResult = IncomeStatementValidator.validateQuery(
        companyId,
        storeId,
        startDate,
        endDate,
        '12month'
      );

      if (!validationResult.isValid) {
        const errorMessages = validationResult.errors.map((e) => e.message).join(', ');
        console.error('❌ [Provider] Validation failed:', validationResult.errors);

        set({
          twelveMonthData: null,
          loading: false,
          error: errorMessages,
          messageState: {
            isOpen: true,
            variant: 'warning',
            title: 'Validation Error',
            message: errorMessages,
          },
        });
        return;
      }

      // Step 2: Call Repository
      const result = await repository.get12MonthIncomeStatement(
        companyId,
        storeId,
        startDate,
        endDate
      );

      if (!result.success) {
        console.error('❌ [Provider] Repository error:', result.error);

        // Determine message variant based on error type
        const isNoData = result.error?.includes('No') || result.error?.includes('available');
        const variant = isNoData ? 'info' : 'error';
        const title = isNoData ? 'No Data Available' : 'Error Loading Data';
        const message =
          result.error ||
          (isNoData
            ? 'No income statement data found for the selected period.'
            : 'Failed to load income statement. Please try again.');

        set({
          twelveMonthData: null,
          loading: false,
          error: result.error || 'Failed to load data',
          messageState: {
            isOpen: true,
            variant,
            title,
            message,
          },
        });
        return;
      }

      // Step 3: Success - Update state
      set({
        twelveMonthData: result.data || null,
        currency: result.currency || '$',
        loading: false,
        error: null,
      });

      console.log('✅ [Provider] 12-month income statement loaded successfully');
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'An unexpected error occurred';
      console.error('❌ [Provider] Error loading 12-month data:', err);

      set({
        twelveMonthData: null,
        loading: false,
        error: errorMessage,
        messageState: {
          isOpen: true,
          variant: 'error',
          title: 'Unexpected Error',
          message: errorMessage,
        },
      });
    }
  },

  clearData: () => {
    console.log('🧹 [Provider] Clearing income statement data');
    set({
      storeId: null,
      statementType: 'monthly',
      fromDate: getFirstDayOfMonth(),
      toDate: getLastDayOfMonth(),
      monthlyData: null,
      twelveMonthData: null,
      currentFilters: null,
      currency: '$',
      error: null,
    });
  },

  reset: () => {
    console.log('🔄 [Provider] Resetting income statement state');
    set({
      companyId: '',
      storeId: null,
      statementType: 'monthly',
      fromDate: getFirstDayOfMonth(),
      toDate: getLastDayOfMonth(),
      monthlyData: null,
      twelveMonthData: null,
      currentFilters: null,
      currency: '$',
      loading: false,
      error: null,
      messageState: {
        isOpen: false,
        variant: 'info',
        title: '',
        message: '',
      },
    });
  },
}));
