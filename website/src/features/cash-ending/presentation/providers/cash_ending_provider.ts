/**
 * Cash Ending Zustand Provider
 * Following 2025 Best Practice - Zustand State Management
 */

import { create } from 'zustand';
import { CashEndingState } from './states/cash_ending_state';
import { CashEndingRepositoryImpl } from '../../data/repositories/CashEndingRepositoryImpl';
import { CashEndingJournalValidator } from '../../domain/validators/CashEndingJournalValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import type { CashEnding } from '../../domain/entities/CashEnding';
import type { CreateJournalParams } from '../../domain/validators/CashEndingJournalValidator';

// Repository instance
const repository = new CashEndingRepositoryImpl();

/**
 * Initial modal state
 */
const initialModalState = {
  isOpen: false,
  type: null as 'error' | 'exchange' | null,
  locationId: null,
  locationName: '',
  storeId: null,
  difference: 0,
};

/**
 * Zustand store for cash-ending feature
 */
export const useCashEndingStore = create<CashEndingState>((set, get) => ({
  // ==================== Initial State ====================

  // Data state
  cashEndings: [],
  selectedDate: DateTimeUtils.toDateOnly(new Date()),
  companyId: '',
  storeId: null,

  // Loading state
  isLoading: false,
  isCreatingJournal: false,

  // Error state
  error: null,
  journalError: null,

  // Modal state
  modalState: initialModalState,

  // ==================== Data Actions ====================

  setCashEndings: (cashEndings) => set({ cashEndings }),

  setSelectedDate: (date) => set({ selectedDate: date }),

  setCompanyId: (companyId) => set({ companyId }),

  setStoreId: (storeId) => set({ storeId }),

  // ==================== Loading Actions ====================

  setLoading: (loading) => set({ isLoading: loading }),

  setCreatingJournal: (creating) => set({ isCreatingJournal: creating }),

  // ==================== Error Actions ====================

  setError: (error) => set({ error }),

  setJournalError: (journalError) => set({ journalError }),

  clearErrors: () => set({ error: null, journalError: null }),

  // ==================== Modal Actions ====================

  openErrorModal: (cashEnding: CashEnding) => {
    set({
      modalState: {
        isOpen: true,
        type: 'error',
        locationId: cashEnding.locationId,
        locationName: cashEnding.locationName,
        storeId: cashEnding.storeId,
        difference: cashEnding.difference,
      },
    });
  },

  openExchangeModal: (cashEnding: CashEnding) => {
    set({
      modalState: {
        isOpen: true,
        type: 'exchange',
        locationId: cashEnding.locationId,
        locationName: cashEnding.locationName,
        storeId: cashEnding.storeId,
        difference: cashEnding.difference,
      },
    });
  },

  closeModal: () => {
    set({ modalState: initialModalState });
  },

  resetModal: () => {
    set({ modalState: initialModalState });
  },

  // ==================== Async Actions ====================

  /**
   * Load cash endings for company and store
   */
  loadCashEndings: async (companyId: string, storeId: string | null) => {
    set({ isLoading: true, error: null });

    try {
      const result = await repository.getCashEndings(companyId, storeId);

      if (!result.success) {
        set({
          error: result.error || 'Failed to load cash endings',
          cashEndings: [],
          isLoading: false,
        });
        return {
          success: false,
          error: result.error || 'Failed to load cash endings',
        };
      }

      set({
        cashEndings: result.data || [],
        companyId,
        storeId,
        error: null,
        isLoading: false,
      });

      return { success: true };
    } catch (err) {
      const errorMessage =
        err instanceof Error ? err.message : 'An unexpected error occurred';

      set({
        error: errorMessage,
        cashEndings: [],
        isLoading: false,
      });

      return {
        success: false,
        error: errorMessage,
      };
    }
  },

  /**
   * Refresh current cash endings
   */
  refresh: async () => {
    const state = get();
    return await state.loadCashEndings(state.companyId, state.storeId);
  },

  /**
   * Create journal entry for Make Error or Foreign Currency Translation
   */
  createJournalEntry: async (params: CreateJournalParams) => {
    set({ isCreatingJournal: true, journalError: null });

    try {
      // 1. Validate parameters using CashEndingJournalValidator (Domain Layer)
      const validationErrors = CashEndingJournalValidator.validateJournalParams(params);

      if (validationErrors.length > 0) {
        const errorMessage = validationErrors.map((e) => e.message).join(', ');
        set({
          journalError: errorMessage,
          isCreatingJournal: false,
        });
        return {
          success: false,
          error: errorMessage,
        };
      }

      // 2. Call Repository (Data Layer)
      const result = await repository.createJournalEntry(params);

      if (!result.success) {
        set({
          journalError: result.error || 'Failed to create journal entry',
          isCreatingJournal: false,
        });
        return {
          success: false,
          error: result.error || 'Failed to create journal entry',
        };
      }

      set({
        isCreatingJournal: false,
        journalError: null,
      });

      return { success: true };
    } catch (err) {
      const errorMessage =
        err instanceof Error ? err.message : 'Unknown error occurred';

      console.error('Error in createJournalEntry:', err);

      set({
        journalError: errorMessage,
        isCreatingJournal: false,
      });

      return {
        success: false,
        error: errorMessage,
      };
    }
  },

  // ==================== Reset ====================

  /**
   * Reset entire state to initial values
   */
  reset: () => {
    set({
      cashEndings: [],
      selectedDate: DateTimeUtils.toDateOnly(new Date()),
      companyId: '',
      storeId: null,
      isLoading: false,
      isCreatingJournal: false,
      error: null,
      journalError: null,
      modalState: initialModalState,
    });
  },
}));
