/**
 * Currency Provider (Zustand Store)
 *
 * Centralized state management for currency feature.
 * Following ARCHITECTURE.md pattern: Zustand + Custom Hooks (2025 Best Practice)
 *
 * Key principles:
 * - All state management logic in one place
 * - Repository calls within async actions
 * - Selector optimization for performance
 * - Complete separation from UI components
 */

import { create } from 'zustand';
import { CurrencyState, NotificationState } from './states/currency_state';
import { Currency } from '../../domain/entities/Currency';
import { CurrencyRepositoryImpl } from '../../data/repositories/CurrencyRepositoryImpl';
import { CurrencyValidator } from '../../domain/validators/CurrencyValidator';

// Initialize repository (singleton pattern)
const repository = new CurrencyRepositoryImpl();

/**
 * Currency Zustand Store
 *
 * Manages all state and business logic for currency management.
 * Components consume this through the useCurrency hook for optimal re-rendering.
 */
export const useCurrencyStore = create<CurrencyState>((set, get) => ({
  // ========================================
  // Initial State
  // ========================================
  currencies: [],
  loading: false,
  error: null,
  companyId: '',
  userId: '',
  editingCurrency: null,
  showAddModal: false,
  currencyToRemove: null,
  isRemoving: false,
  notification: null,

  // ========================================
  // Context Actions
  // ========================================
  setContext: (companyId: string, userId: string) => {
    set({ companyId, userId });
  },

  // ========================================
  // State Actions
  // ========================================
  setCurrencies: (currencies) => set({ currencies }),

  setLoading: (loading) => set({ loading }),

  setError: (error) => set({ error }),

  setEditingCurrency: (currency) => set({ editingCurrency: currency }),

  setShowAddModal: (show) => set({ showAddModal: show }),

  setCurrencyToRemove: (currency) => set({ currencyToRemove: currency }),

  setNotification: (notification) => set({ notification }),

  clearNotification: () => set({ notification: null }),

  // ========================================
  // Async Operations
  // ========================================

  /**
   * Load currencies for the current company
   */
  loadCurrencies: async () => {
    const { companyId } = get();

    if (!companyId) {
      set({ error: 'No company selected' });
      return;
    }

    set({ loading: true, error: null });

    try {
      const result = await repository.getCurrencies(companyId);

      if (result.success) {
        set({
          currencies: result.data || [],
          loading: false,
          error: null,
        });
      } else {
        set({
          loading: false,
          error: result.error || 'Failed to load currencies',
        });
      }
    } catch (error) {
      set({
        loading: false,
        error: error instanceof Error ? error.message : 'Unknown error',
      });
    }
  },

  /**
   * Get all available currency types
   */
  getAllCurrencyTypes: async () => {
    try {
      const result = await repository.getAllCurrencyTypes();
      return result.success ? (result.data || []) : [];
    } catch (error) {
      console.error('Failed to get currency types:', error);
      return [];
    }
  },

  /**
   * Update exchange rate for a currency
   */
  updateExchangeRate: async (currencyId: string, newRate: number | string) => {
    const { companyId, userId } = get();

    if (!companyId) {
      return { success: false, error: 'No company selected' };
    }

    if (!userId) {
      return { success: false, error: 'No user ID' };
    }

    // Validate using domain validator
    const validationResult = CurrencyValidator.validateExchangeRate(newRate);
    if (!validationResult.isValid) {
      return { success: false, error: validationResult.error };
    }

    try {
      const rate = typeof newRate === 'string' ? parseFloat(newRate) : newRate;
      const result = await repository.updateExchangeRate(currencyId, companyId, rate, userId);

      if (result.success) {
        // Reload currencies to get updated data
        await get().loadCurrencies();

        // Show success notification
        set({
          notification: {
            variant: 'success',
            message: 'Exchange rate updated successfully!',
          },
          editingCurrency: null, // Close edit modal
        });

        // Auto-clear notification after 2 seconds
        setTimeout(() => {
          get().clearNotification();
        }, 2000);

        return { success: true };
      }

      return result;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Failed to update exchange rate';
      return { success: false, error: errorMessage };
    }
  },

  /**
   * Add a new currency to the company
   */
  addCurrency: async (currencyId: string, exchangeRate: number | string) => {
    const { companyId, userId } = get();

    if (!companyId) {
      return { success: false, error: 'No company selected' };
    }

    if (!userId) {
      return { success: false, error: 'No user ID' };
    }

    // Validate using domain validator
    const validationResult = CurrencyValidator.validateAddCurrency(currencyId, exchangeRate);
    if (!validationResult.isValid) {
      return { success: false, error: validationResult.error };
    }

    try {
      const rate = typeof exchangeRate === 'string' ? parseFloat(exchangeRate) : exchangeRate;
      const result = await repository.addCurrency(currencyId, companyId, rate, userId);

      if (result.success) {
        // Reload currencies to get updated data
        await get().loadCurrencies();

        // Get currency name for notification
        const allTypes = await get().getAllCurrencyTypes();
        const addedCurrency = allTypes.find(ct => ct.currencyId === currencyId);

        // Show success notification
        set({
          notification: {
            variant: 'success',
            message: `${addedCurrency?.code || 'Currency'} added successfully!`,
          },
          showAddModal: false, // Close add modal
        });

        // Auto-clear notification after 2 seconds
        setTimeout(() => {
          get().clearNotification();
        }, 2000);

        return { success: true };
      }

      return result;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Failed to add currency';
      return { success: false, error: errorMessage };
    }
  },

  /**
   * Remove a currency from the company
   */
  removeCurrency: async (currencyId: string) => {
    const { companyId } = get();

    if (!companyId) {
      return { success: false, error: 'No company selected' };
    }

    set({ isRemoving: true });

    try {
      const result = await repository.removeCurrency(currencyId, companyId);

      if (result.success) {
        // Reload currencies to get updated data
        await get().loadCurrencies();

        const removedCurrency = get().currencyToRemove;

        // Show success notification
        set({
          notification: {
            variant: 'success',
            message: `${removedCurrency?.code || 'Currency'} removed successfully!`,
          },
          currencyToRemove: null, // Close confirmation modal
          isRemoving: false,
        });

        // Auto-clear notification after 2 seconds
        setTimeout(() => {
          get().clearNotification();
        }, 2000);

        return { success: true };
      }

      set({ isRemoving: false });
      return result;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Failed to remove currency';
      set({ isRemoving: false });
      return { success: false, error: errorMessage };
    }
  },

  /**
   * Set a currency as the default/base currency
   */
  setDefaultCurrency: async (currencyId: string) => {
    const { companyId } = get();

    if (!companyId) {
      return { success: false, error: 'No company selected' };
    }

    try {
      const result = await repository.setDefaultCurrency(currencyId, companyId);

      if (result.success) {
        // Reload currencies to get updated data
        await get().loadCurrencies();

        // Show success notification
        set({
          notification: {
            variant: 'success',
            message: 'Default currency updated successfully!',
          },
        });

        // Auto-clear notification after 2 seconds
        setTimeout(() => {
          get().clearNotification();
        }, 2000);

        return { success: true };
      }

      return result;
    } catch (error) {
      const errorMessage = error instanceof Error ? error.message : 'Failed to set default currency';
      return { success: false, error: errorMessage };
    }
  },

  // ========================================
  // UI Action Handlers
  // ========================================

  /**
   * Handle edit currency action
   */
  handleEditCurrency: (currency: Currency) => {
    set({ editingCurrency: currency });
  },

  /**
   * Handle remove currency action
   */
  handleRemoveCurrency: (currency: Currency) => {
    // Prevent removing base currency
    if (currency.isDefault) {
      set({
        notification: {
          variant: 'error',
          message: 'Cannot remove the base currency. Please change the base currency in company settings first.',
        },
      });

      // Auto-clear notification after 3 seconds
      setTimeout(() => {
        get().clearNotification();
      }, 3000);

      return;
    }

    // Show confirmation modal
    set({ currencyToRemove: currency });
  },

  /**
   * Confirm and execute currency removal
   */
  confirmRemoveCurrency: async () => {
    const { currencyToRemove } = get();

    if (!currencyToRemove) return;

    const result = await get().removeCurrency(currencyToRemove.currencyId);

    if (!result.success) {
      // Show error notification
      set({
        notification: {
          variant: 'error',
          message: result.error || 'Failed to remove currency',
        },
        isRemoving: false,
      });

      // Auto-clear notification after 3 seconds
      setTimeout(() => {
        get().clearNotification();
      }, 3000);
    }
  },

  /**
   * Reset all state to initial values
   */
  reset: () => {
    set({
      currencies: [],
      loading: false,
      error: null,
      companyId: '',
      userId: '',
      editingCurrency: null,
      showAddModal: false,
      currencyToRemove: null,
      isRemoving: false,
      notification: null,
    });
  },
}));
