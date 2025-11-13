/**
 * Shared state types for balance-sheet feature
 * Following 2025 Best Practice - Zustand State Management
 */

/**
 * Result type for async operations
 */
export interface AsyncOperationResult {
  success: boolean;
  error?: string;
}

/**
 * Filter state
 */
export interface FilterState {
  storeId: string | null;
  startDate: string | null;
  endDate: string | null;
}

/**
 * Loading states
 */
export interface LoadingState {
  isLoading: boolean;
}

/**
 * Error state
 */
export interface ErrorState {
  error: string | null;
  validationErrors: Record<string, string>;
}

/**
 * Data state
 */
export interface DataState {
  balanceSheet: any | null; // BalanceSheetData type
  companyId: string;
}
