/**
 * Currency State Interface
 *
 * Defines the state structure for currency management feature.
 * Following ARCHITECTURE.md pattern: Zustand + Custom Hooks (2025 Best Practice)
 */

import { Currency } from '../../../domain/entities/Currency';
import type { CurrencyTypeDTO } from '../../../data/models/CurrencyTypeModel';

/**
 * Notification state for user feedback
 */
export interface NotificationState {
  variant: 'success' | 'error';
  message: string;
}

/**
 * Currency feature state interface
 * Contains all state, UI state, and actions for currency management
 */
export interface CurrencyState {
  // ========================================
  // Core Data State
  // ========================================

  /** List of configured currencies for the company */
  currencies: Currency[];

  /** Loading state for async operations */
  loading: boolean;

  /** Error message if operations fail */
  error: string | null;

  /** Company ID context */
  companyId: string;

  /** User ID context */
  userId: string;

  // ========================================
  // UI State
  // ========================================

  /** Currency being edited in modal */
  editingCurrency: Currency | null;

  /** Show/hide add currency modal */
  showAddModal: boolean;

  /** Currency pending removal confirmation */
  currencyToRemove: Currency | null;

  /** Loading state for remove operation */
  isRemoving: boolean;

  /** Notification state for user feedback */
  notification: NotificationState | null;

  // ========================================
  // Context Actions
  // ========================================

  /**
   * Set company and user context
   * Must be called before any operations
   */
  setContext: (companyId: string, userId: string) => void;

  // ========================================
  // State Actions
  // ========================================

  /** Set currencies list */
  setCurrencies: (currencies: Currency[]) => void;

  /** Set loading state */
  setLoading: (loading: boolean) => void;

  /** Set error message */
  setError: (error: string | null) => void;

  /** Set editing currency */
  setEditingCurrency: (currency: Currency | null) => void;

  /** Set add modal visibility */
  setShowAddModal: (show: boolean) => void;

  /** Set currency to remove */
  setCurrencyToRemove: (currency: Currency | null) => void;

  /** Set notification */
  setNotification: (notification: NotificationState | null) => void;

  /** Clear notification after delay */
  clearNotification: () => void;

  // ========================================
  // Async Operations (Repository Calls)
  // ========================================

  /**
   * Load currencies for the current company
   * Fetches all configured currencies with exchange rates
   */
  loadCurrencies: () => Promise<void>;

  /**
   * Get all available currency types
   * Used for populating currency selector in add modal
   * @returns Promise resolving to array of available currency types
   */
  getAllCurrencyTypes: () => Promise<CurrencyTypeDTO[]>;

  /**
   * Update exchange rate for a currency
   * @param currencyId - Currency ID to update
   * @param newRate - New exchange rate value
   * @returns Promise with success/error result
   */
  updateExchangeRate: (currencyId: string, newRate: number | string) => Promise<{ success: boolean; error?: string }>;

  /**
   * Add a new currency to the company
   * @param currencyId - Currency ID to add
   * @param exchangeRate - Initial exchange rate
   * @returns Promise with success/error result
   */
  addCurrency: (currencyId: string, exchangeRate: number | string) => Promise<{ success: boolean; error?: string }>;

  /**
   * Remove a currency from the company
   * Performs soft delete (sets is_deleted flag)
   * @param currencyId - Currency ID to remove
   * @returns Promise with success/error result
   */
  removeCurrency: (currencyId: string) => Promise<{ success: boolean; error?: string }>;

  /**
   * Set a currency as the default/base currency
   * @param currencyId - Currency ID to set as default
   * @returns Promise with success/error result
   */
  setDefaultCurrency: (currencyId: string) => Promise<{ success: boolean; error?: string }>;

  /**
   * Handle edit currency action
   * Opens edit modal with selected currency
   * @param currency - Currency to edit
   */
  handleEditCurrency: (currency: Currency) => void;

  /**
   * Handle remove currency action
   * Shows confirmation modal or displays error for base currency
   * @param currency - Currency to remove
   */
  handleRemoveCurrency: (currency: Currency) => void;

  /**
   * Confirm and execute currency removal
   * Performs validation and removal, then shows notification
   */
  confirmRemoveCurrency: () => Promise<void>;

  /**
   * Reset all state to initial values
   * Used for cleanup or resetting the feature
   */
  reset: () => void;
}
