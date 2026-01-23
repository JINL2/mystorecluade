/**
 * AccountMappingState Interface
 * State management interface for account-mapping feature
 *
 * Following Clean Architecture and 2025 Best Practice:
 * - Zustand for state management
 * - Clear separation between state and actions
 * - Async operations handled in store
 */

import type { AccountMapping } from '../../../domain/entities/AccountMapping';
import type { AccountOption, CompanyOption } from '../../../domain/repositories/IAccountMappingRepository';
import type { AsyncOperationResult } from './types';

/**
 * Account Mapping State Interface
 */
export interface AccountMappingState {
  // ============================================
  // STATE PROPERTIES
  // ============================================

  /**
   * Current company ID
   */
  companyId: string;

  /**
   * List of account mappings
   */
  mappings: AccountMapping[];

  /**
   * Available accounts for current company
   */
  availableAccounts: AccountOption[];

  /**
   * Available companies for mapping
   */
  availableCompanies: CompanyOption[];

  /**
   * Loading state
   */
  loading: boolean;

  /**
   * Creating mapping state
   */
  isCreating: boolean;

  /**
   * Deleting mapping state
   */
  isDeleting: boolean;

  /**
   * Error message
   */
  error: string | null;

  /**
   * Show add modal
   */
  showAddModal: boolean;

  /**
   * Show delete confirmation modal
   */
  showDeleteConfirm: boolean;

  /**
   * Mapping ID being deleted
   */
  deletingMappingId: string | null;

  /**
   * Info about mapping being deleted
   */
  deletingMappingInfo: {
    myAccount: string;
    linkedAccount: string;
  } | null;

  /**
   * Show error message modal
   */
  showErrorMessage: boolean;

  /**
   * Error message text
   */
  errorMessageText: string;

  // ============================================
  // COMPUTED VALUES (GETTERS)
  // ============================================

  /**
   * Get outgoing mappings (created by current company)
   */
  getOutgoingMappings: () => AccountMapping[];

  /**
   * Get incoming mappings (created by other companies, read-only)
   */
  getIncomingMappings: () => AccountMapping[];

  // ============================================
  // STATE ACTIONS (SETTERS)
  // ============================================

  /**
   * Set company ID
   */
  setCompanyId: (companyId: string) => void;

  /**
   * Set mappings
   */
  setMappings: (mappings: AccountMapping[]) => void;

  /**
   * Set loading state
   */
  setLoading: (loading: boolean) => void;

  /**
   * Set error
   */
  setError: (error: string | null) => void;

  /**
   * Set show add modal
   */
  setShowAddModal: (show: boolean) => void;

  /**
   * Set show delete confirm
   */
  setShowDeleteConfirm: (show: boolean) => void;

  /**
   * Set deleting mapping ID
   */
  setDeletingMappingId: (id: string | null) => void;

  /**
   * Set deleting mapping info
   */
  setDeletingMappingInfo: (info: { myAccount: string; linkedAccount: string } | null) => void;

  /**
   * Set available accounts
   */
  setAvailableAccounts: (accounts: AccountOption[]) => void;

  /**
   * Set available companies
   */
  setAvailableCompanies: (companies: CompanyOption[]) => void;

  /**
   * Set show error message
   */
  setShowErrorMessage: (show: boolean) => void;

  /**
   * Set error message text
   */
  setErrorMessageText: (text: string) => void;

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load account mappings for company
   */
  loadMappings: () => Promise<void>;

  /**
   * Create new account mapping
   */
  createMapping: (
    counterpartyCompanyId: string,
    myAccountId: string,
    linkedAccountId: string,
    direction: string,
    createdBy: string
  ) => Promise<AsyncOperationResult>;

  /**
   * Delete account mapping
   */
  deleteMapping: (mappingId: string) => Promise<AsyncOperationResult>;

  /**
   * Get company accounts (for modal)
   */
  getCompanyAccounts: (targetCompanyId: string) => Promise<{
    success: boolean;
    data?: AccountOption[];
    error?: string;
  }>;

  /**
   * Load modal data (accounts and companies)
   */
  loadModalData: (companies: CompanyOption[]) => Promise<void>;

  /**
   * Refresh mappings
   */
  refresh: () => Promise<void>;

  /**
   * Reset store to initial state
   */
  reset: () => void;

  // ============================================
  // UI ACTIONS
  // ============================================

  /**
   * Open add modal
   */
  openAddModal: () => void;

  /**
   * Close add modal
   */
  closeAddModal: () => void;

  /**
   * Open delete confirmation modal
   */
  openDeleteConfirm: (mappingId: string, myAccountName: string, linkedAccountName: string) => void;

  /**
   * Close delete confirmation modal
   */
  closeDeleteConfirm: () => void;

  /**
   * Show error message
   */
  showError: (message: string) => void;

  /**
   * Hide error message
   */
  hideError: () => void;
}
