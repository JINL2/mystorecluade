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
import type { IncomeStatementFilters, IncomeStatementType, MessageState } from './types';

export interface IncomeStatementState {
  // ============================================
  // STATE PROPERTIES
  // ============================================

  /** Current company ID */
  companyId: string;

  /** Current store ID (null = all stores) */
  storeId: string | null;

  /** Statement type (monthly or 12month) */
  statementType: IncomeStatementType;

  /** From date (YYYY-MM-DD) */
  fromDate: string;

  /** To date (YYYY-MM-DD) */
  toDate: string;

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
   * Set statement type (monthly or 12month)
   * @param type Statement type
   */
  setStatementType: (type: IncomeStatementType) => void;

  /**
   * Set from date
   * @param date Date string (YYYY-MM-DD)
   */
  setFromDate: (date: string) => void;

  /**
   * Set to date
   * @param date Date string (YYYY-MM-DD)
   */
  setToDate: (date: string) => void;

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
