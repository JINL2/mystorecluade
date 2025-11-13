/**
 * Cash Ending State Interface
 * Following 2025 Best Practice - Zustand State Management
 */

import type { CashEnding } from '../../../domain/entities/CashEnding';
import type { CreateJournalParams } from '../../../domain/validators/CashEndingJournalValidator';
import type {
  AsyncOperationResult,
  ModalState,
} from './types';

/**
 * Complete state interface for cash-ending feature
 */
export interface CashEndingState {
  // ==================== State ====================

  // Data state
  cashEndings: CashEnding[];
  selectedDate: string;
  companyId: string;
  storeId: string | null;

  // Loading state
  isLoading: boolean;
  isCreatingJournal: boolean;

  // Error state
  error: string | null;
  journalError: string | null;

  // Modal state
  modalState: ModalState;

  // ==================== Actions ====================

  // Data actions
  setCashEndings: (cashEndings: CashEnding[]) => void;
  setSelectedDate: (date: string) => void;
  setCompanyId: (companyId: string) => void;
  setStoreId: (storeId: string | null) => void;

  // Loading actions
  setLoading: (loading: boolean) => void;
  setCreatingJournal: (creating: boolean) => void;

  // Error actions
  setError: (error: string | null) => void;
  setJournalError: (error: string | null) => void;
  clearErrors: () => void;

  // Modal actions
  openErrorModal: (cashEnding: CashEnding) => void;
  openExchangeModal: (cashEnding: CashEnding) => void;
  closeModal: () => void;
  resetModal: () => void;

  // ==================== Async Actions ====================

  /**
   * Load cash endings for company and store
   */
  loadCashEndings: (companyId: string, storeId: string | null) => Promise<AsyncOperationResult>;

  /**
   * Refresh current cash endings
   */
  refresh: () => Promise<AsyncOperationResult>;

  /**
   * Create journal entry for Make Error or Foreign Currency Translation
   */
  createJournalEntry: (params: CreateJournalParams) => Promise<AsyncOperationResult>;

  // ==================== Reset ====================

  /**
   * Reset entire state to initial values
   */
  reset: () => void;
}
