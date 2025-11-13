/**
 * Shared state types for cash-ending feature
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
 * Modal state for Make Error and Foreign Currency Translation
 */
export interface ModalState {
  isOpen: boolean;
  type: 'error' | 'exchange' | null;
  locationId: string | null;
  locationName: string;
  storeId: string | null;
  difference: number;
}

/**
 * Loading states
 */
export interface LoadingState {
  isLoading: boolean;
  isCreatingJournal: boolean;
}

/**
 * Error state
 */
export interface ErrorState {
  error: string | null;
  journalError: string | null;
}

/**
 * Data state
 */
export interface DataState {
  cashEndings: any[]; // CashEnding[] type
  selectedDate: string;
  companyId: string;
  storeId: string | null;
}
