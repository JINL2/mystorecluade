/**
 * Salary State Interface
 * Following 2025 Best Practice - Zustand State Management
 */

import type { SalaryRecord } from '../../../domain/entities/SalaryRecord';
import type { SalarySummary } from '../../../domain/entities/SalarySummary';
import type { SalaryNotification, AsyncOperationResult } from './types';

// Re-export for convenience
export type { AsyncOperationResult } from './types';

/**
 * Complete state interface for employee-salary feature
 */
export interface SalaryState {
  // ==================== State ====================

  // Data state
  records: SalaryRecord[];
  summary: SalarySummary | null;
  currentMonth: string;
  companyId: string;

  // Loading state
  loading: boolean;
  exporting: boolean;

  // Error state
  error: string | null;
  notification: SalaryNotification | null;

  // ==================== Actions ====================

  // Data actions
  setRecords: (records: SalaryRecord[]) => void;
  setSummary: (summary: SalarySummary | null) => void;
  setCurrentMonth: (month: string) => void;
  setCompanyId: (companyId: string) => void;

  // Loading actions
  setLoading: (loading: boolean) => void;
  setExporting: (exporting: boolean) => void;

  // Error actions
  setError: (error: string | null) => void;
  setNotification: (notification: SalaryNotification | null) => void;
  clearErrors: () => void;

  // ==================== Async Actions ====================

  /**
   * Load salary data for company and month
   */
  loadSalaryData: (companyId: string, month: string, storeId?: string | null) => Promise<AsyncOperationResult>;

  /**
   * Refresh current salary data
   */
  refresh: () => Promise<AsyncOperationResult>;

  /**
   * Navigate to previous month
   */
  goToPreviousMonth: () => void;

  /**
   * Navigate to next month
   */
  goToNextMonth: () => void;

  /**
   * Go to current month
   */
  goToCurrentMonth: () => void;

  /**
   * Export to Excel
   * @param storeId - Store ID to filter by (null for all stores)
   * @param companyName - Company name for filename
   * @param storeName - Store name for filename
   * @param selectedColumns - Array of column keys to include in export (optional, all columns if not provided)
   */
  exportToExcel: (
    storeId: string | null,
    companyName: string,
    storeName: string,
    selectedColumns?: string[]
  ) => Promise<AsyncOperationResult>;

  // ==================== Reset ====================

  /**
   * Reset entire state to initial values
   */
  reset: () => void;
}
