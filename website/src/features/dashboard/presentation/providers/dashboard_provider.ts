/**
 * Dashboard Provider
 * Zustand store for dashboard feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import type { DashboardState } from './states/dashboard_state';
import { DashboardRepositoryImpl } from '../../data/repositories/DashboardRepositoryImpl';
import { DashboardValidator } from '../../domain/validators/DashboardValidator';
import { DashboardMessages } from '../../domain/constants/DashboardMessages';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new DashboardRepositoryImpl();

/**
 * Dashboard Store
 * Zustand store for dashboard feature state
 */
export const useDashboardStore = create<DashboardState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  data: null,
  loading: true,
  error: null,
  errorDialog: {
    variant: 'error',
    title: DashboardMessages.errors.loadFailedTitle,
    message: '',
    isOpen: false,
  },

  // ============================================
  // SYNCHRONOUS ACTIONS (SETTERS)
  // ============================================

  setData: (data) => set({ data }),

  setLoading: (loading) => set({ loading }),

  setError: (error) =>
    set({
      error,
      errorDialog: {
        variant: 'error',
        title: DashboardMessages.errors.loadFailedTitle,
        message: error || '',
        isOpen: !!error && !get().loading,
      },
    }),

  clearError: () =>
    set({
      error: null,
      errorDialog: {
        variant: 'error',
        title: DashboardMessages.errors.loadFailedTitle,
        message: '',
        isOpen: false,
      },
    }),

  // ============================================
  // ASYNCHRONOUS ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load dashboard data
   * Fetches dashboard metrics and updates state
   */
  loadDashboardData: async (companyId: string, currentDate: string) => {
    // Validate company ID before making request
    const companyIdValidation = DashboardValidator.validateCompanyId(companyId);
    if (!companyIdValidation.isValid) {
      set({
        error:
          companyIdValidation.error || DashboardMessages.errors.invalidCompanyId,
        loading: false,
      });
      get().setError(
        companyIdValidation.error || DashboardMessages.errors.invalidCompanyId
      );
      return;
    }

    set({ loading: true, error: null });
    get().clearError();

    try {
      // Validate date format
      const dateValidation = DashboardValidator.validateDateFormat(currentDate);
      if (!dateValidation.isValid) {
        set({
          error: dateValidation.error || DashboardMessages.errors.invalidDate,
          loading: false,
        });
        get().setError(
          dateValidation.error || DashboardMessages.errors.invalidDate
        );
        return;
      }

      const result = await repository.getDashboardData(companyId, currentDate);

      if (!result.success || !result.data) {
        set({
          error: result.error || DashboardMessages.errors.loadFailed,
          data: null,
          loading: false,
        });
        get().setError(result.error || DashboardMessages.errors.loadFailed);
        return;
      }

      // Validate dashboard data integrity (optional, but good practice)
      const validation = DashboardValidator.validateDashboardData({
        todayRevenue: result.data.todayRevenue,
        todayExpense: result.data.todayExpense,
        thisMonthRevenue: result.data.thisMonthRevenue,
        lastMonthRevenue: result.data.lastMonthRevenue,
        currency: result.data.currency,
        expenseBreakdown: result.data.expenseBreakdown,
        recentTransactions: result.data.recentTransactions,
      });

      if (!validation.isValid) {
        console.warn(
          DashboardMessages.technical.validationWarnings(validation.errors)
        );
        // Don't block rendering for data integrity issues, just log warnings
      }

      set({
        data: result.data,
        loading: false,
        error: null,
      });
      get().clearError();
    } catch (err) {
      const errorMessage =
        err instanceof Error
          ? err.message
          : DashboardMessages.errors.unexpectedError;
      set({
        error: errorMessage,
        data: null,
        loading: false,
      });
      get().setError(errorMessage);
    }
  },

  /**
   * Refresh dashboard data
   * Reloads dashboard data with current date
   */
  refresh: async (companyId: string) => {
    const currentDate = DateTimeUtils.nowUtcDate();
    await get().loadDashboardData(companyId, currentDate);
  },
}));
