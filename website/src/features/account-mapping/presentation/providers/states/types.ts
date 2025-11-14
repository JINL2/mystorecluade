/**
 * Shared state types for account-mapping feature
 * Following 2025 Best Practice - Zustand State Management
 */

import type { AccountMapping } from '../../../domain/entities/AccountMapping';
import type { AccountOption, CompanyOption } from '../../../domain/repositories/IAccountMappingRepository';

/**
 * Result type for async operations
 */
export interface AsyncOperationResult {
  success: boolean;
  error?: string;
}

/**
 * Modal state
 */
export interface ModalState {
  showAddModal: boolean;
  showDeleteConfirm: boolean;
  deletingMappingId: string | null;
  deletingMappingInfo: {
    myAccount: string;
    linkedAccount: string;
  } | null;
}

/**
 * Loading states
 */
export interface LoadingState {
  isLoading: boolean;
  isDeleting: boolean;
  isCreating: boolean;
}

/**
 * Error state
 */
export interface ErrorState {
  error: string | null;
  showErrorMessage: boolean;
  errorMessageText: string;
}

/**
 * Data state
 */
export interface DataState {
  mappings: AccountMapping[];
  availableAccounts: AccountOption[];
  availableCompanies: CompanyOption[];
  companyId: string;
}

/**
 * Computed values
 */
export interface ComputedValues {
  outgoingMappings: AccountMapping[];
  incomingMappings: AccountMapping[];
}
