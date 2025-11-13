/**
 * Income Statement State Interface
 * State interface definition for Zustand store
 *
 * Following ARCHITECTURE.md pattern:
 * - State properties
 * - Sync actions (setters)
 * - Async actions (business logic with Repository calls)
 */

import type {
  MonthlyIncomeStatementData,
  TwelveMonthIncomeStatementData
} from '../../../domain/entities/IncomeStatementData';
import type { IncomeStatementFilters, MessageState } from './types';

export interface IncomeStatementState {
  // ============================================
  // STATE PROPERTIES
  // ============================================

  /** Current company ID */
  companyId: string;

  /** Current store ID (null = all stores) */
  storeId: string | null;

  /** Monthly income statement data */
  monthlyData: MonthlyIncomeStatementData | null;

  /** 12-month income statement data */
  twelveMonthData: TwelveMonthIncomeStatementData | null;

  /** Current applied filters */
  currentFilters: IncomeStatementFilters | null;

  /** Currency symbol */
  currency: string;

  /** Loading state */
  loading: boolean;

  /** Error state */
  error: string | null;

  /** Message state for ErrorMessage component */
  messageState: MessageState;

  // ============================================
  // SYNC ACTIONS (STATE SETTERS)
  // ============================================

  /**
   * Set company ID
   * @param companyId Company ID
   */
  setCompanyId: (companyId: string) => void;

  /**
   * Set store ID
   * @param storeId Store ID (null = all stores)
   */
  setStoreId: (storeId: string | null) => void;

  /**
   * Set current filters
   * @param filters Filter values
   */
  setCurrentFilters: (filters: IncomeStatementFilters | null) => void;

  /**
   * Close message dialog
   */
  closeMessage: () => void;

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load monthly income statement data
   * Executes validation and calls repository
   *
   * @param companyId Company ID
   * @param storeId Store ID (null = all stores)
   * @param startDate Start date (YYYY-MM-DD)
   * @param endDate End date (YYYY-MM-DD)
   */
  loadMonthlyData: (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => Promise<void>;

  /**
   * Load 12-month income statement data
   * Executes validation and calls repository
   *
   * @param companyId Company ID
   * @param storeId Store ID (null = all stores)
   * @param startDate Start date (YYYY-MM-DD)
   * @param endDate End date (YYYY-MM-DD)
   */
  load12MonthData: (
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) => Promise<void>;

  /**
   * Clear all data and reset filters
   */
  clearData: () => void;

  /**
   * Reset to initial state
   */
  reset: () => void;
}
