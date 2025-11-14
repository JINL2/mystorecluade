/**
 * BalanceSheetState Interface
 * State management interface for balance-sheet feature
 *
 * Following Clean Architecture and 2025 Best Practice:
 * - Zustand for state management
 * - Clear separation between state and actions
 * - Async operations handled in store
 */

import type { BalanceSheetData } from '../../../domain/entities/BalanceSheetData';
import type { AsyncOperationResult } from './types';

/**
 * Balance Sheet State Interface
 */
export interface BalanceSheetState {
  // ============================================
  // STATE PROPERTIES
  // ============================================

  /**
   * Current company ID
   */
  companyId: string;

  /**
   * Current store ID (optional)
   */
  storeId: string | null;

  /**
   * Start date filter (YYYY-MM-DD)
   */
  startDate: string | null;

  /**
   * End date filter (YYYY-MM-DD)
   */
  endDate: string | null;

  /**
   * Balance sheet data
   */
  balanceSheet: BalanceSheetData | null;

  /**
   * Loading state
   */
  loading: boolean;

  /**
   * Error message
   */
  error: string | null;

  /**
   * Validation errors (field -> message)
   */
  validationErrors: Record<string, string>;

  // ============================================
  // STATE ACTIONS (SETTERS)
  // ============================================

  /**
   * Set company ID
   */
  setCompanyId: (companyId: string) => void;

  /**
   * Set store ID
   */
  setStoreId: (storeId: string | null) => void;

  /**
   * Set date range
   */
  setDateRange: (startDate: string | null, endDate: string | null) => void;

  /**
   * Set start date
   */
  setStartDate: (startDate: string | null) => void;

  /**
   * Set end date
   */
  setEndDate: (endDate: string | null) => void;

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load balance sheet data
   * Validates filters and fetches data from repository
   */
  loadBalanceSheet: (
    overrideStoreId?: string | null,
    overrideStartDate?: string | null,
    overrideEndDate?: string | null
  ) => Promise<AsyncOperationResult>;

  /**
   * Refresh balance sheet (reload with current filters)
   */
  refresh: () => Promise<void>;

  /**
   * Reset store to initial state
   */
  reset: () => void;

  /**
   * Clear filters (but keep company ID)
   */
  clearFilters: () => void;
}
