/**
 * AccountMappingProvider
 * Zustand store for account-mapping feature state management
 *
 * Following 2025 Best Practice:
 * - Zustand for state management (no Provider hell)
 * - Async operations in store
 * - Repository pattern integration
 * - Clean separation of concerns
 */

import { create } from 'zustand';
import { AccountMappingState } from './states/account_mapping_state';
import { AccountMappingRepositoryImpl } from '../../data/repositories/AccountMappingRepositoryImpl';
import { AccountMappingValidator } from '../../domain/validators/AccountMappingValidator';
import type { CompanyOption } from '../../domain/repositories/IAccountMappingRepository';

/**
 * Create repository instance (singleton pattern)
 */
const repository = new AccountMappingRepositoryImpl();

/**
 * Account Mapping Store
 * Zustand store with immer middleware for immutable state updates
 */
export const useAccountMappingStore = create<AccountMappingState>((set, get) => ({
  // ============================================
  // INITIAL STATE
  // ============================================
  companyId: '',
  mappings: [],
  availableAccounts: [],
  availableCompanies: [],
  loading: false,
  isCreating: false,
  isDeleting: false,
  error: null,
  showAddModal: false,
  showDeleteConfirm: false,
  deletingMappingId: null,
  deletingMappingInfo: null,
  showErrorMessage: false,
  errorMessageText: '',

  // ============================================
  // COMPUTED VALUES (GETTERS)
  // ============================================

  /**
   * Get outgoing mappings (created by current company)
   */
  getOutgoingMappings: () => {
    const { mappings } = get();
    return mappings.filter((m) => !m.isReadOnly);
  },

  /**
   * Get incoming mappings (created by other companies, read-only)
   */
  getIncomingMappings: () => {
    const { mappings } = get();
    return mappings.filter((m) => m.isReadOnly);
  },

  // ============================================
  // STATE ACTIONS (SETTERS)
  // ============================================

  setCompanyId: (companyId) => set({ companyId }),

  setMappings: (mappings) => set({ mappings }),

  setLoading: (loading) => set({ loading }),

  setError: (error) => set({ error }),

  setShowAddModal: (show) => set({ showAddModal: show }),

  setShowDeleteConfirm: (show) => set({ showDeleteConfirm: show }),

  setDeletingMappingId: (id) => set({ deletingMappingId: id }),

  setDeletingMappingInfo: (info) => set({ deletingMappingInfo: info }),

  setAvailableAccounts: (accounts) => set({ availableAccounts: accounts }),

  setAvailableCompanies: (companies) => set({ availableCompanies: companies }),

  setShowErrorMessage: (show) => set({ showErrorMessage: show }),

  setErrorMessageText: (text) => set({ errorMessageText: text }),

  // ============================================
  // ASYNC ACTIONS (BUSINESS LOGIC)
  // ============================================

  /**
   * Load account mappings for company
   */
  loadMappings: async () => {
    const { companyId } = get();

    if (!companyId) {
      set({ mappings: [], loading: false });
      return;
    }

    set({ loading: true, error: null });

    try {
      const result = await repository.getAccountMappings(companyId);

      if (!result.success) {
        set({
          error: result.error || 'Failed to load account mappings',
          mappings: [],
          loading: false,
        });
        return;
      }

      set({
        mappings: result.data || [],
        loading: false,
        error: null,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        mappings: [],
        loading: false,
      });
    }
  },

  /**
   * Create new account mapping
   */
  createMapping: async (
    counterpartyCompanyId,
    myAccountId,
    linkedAccountId,
    direction,
    createdBy
  ) => {
    const { companyId, loadMappings } = get();

    // Step 1: Execute validation using domain validator
    const validationErrors = AccountMappingValidator.validateCreateMapping({
      myCompanyId: companyId,
      counterpartyCompanyId,
      myAccountId,
      linkedAccountId,
      direction,
      createdBy,
    });

    if (validationErrors.length > 0) {
      const errorMessage = validationErrors.map((e) => e.message).join(', ');
      return { success: false, error: errorMessage };
    }

    // Step 2: Call repository for data operation
    set({ isCreating: true });

    try {
      const result = await repository.createAccountMapping(
        companyId,
        counterpartyCompanyId,
        myAccountId,
        linkedAccountId,
        direction,
        createdBy
      );

      if (result.success) {
        // Reload mappings after successful creation
        await loadMappings();
      }

      return result;
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to create mapping',
      };
    } finally {
      set({ isCreating: false });
    }
  },

  /**
   * Delete account mapping
   */
  deleteMapping: async (mappingId) => {
    const { loadMappings } = get();

    // Step 1: Execute validation using domain validator
    const validationError = AccountMappingValidator.validateDeleteMapping(mappingId);

    if (validationError) {
      return { success: false, error: validationError.message };
    }

    // Step 2: Call repository for data operation
    set({ isDeleting: true });

    try {
      const result = await repository.deleteAccountMapping(mappingId);

      if (result.success) {
        // Reload mappings after successful deletion
        await loadMappings();
      }

      return result;
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to delete mapping',
      };
    } finally {
      set({ isDeleting: false });
    }
  },

  /**
   * Get company accounts (for modal)
   */
  getCompanyAccounts: async (targetCompanyId) => {
    try {
      return await repository.getCompanyAccounts(targetCompanyId);
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch company accounts',
      };
    }
  },

  /**
   * Load modal data (accounts and companies)
   */
  loadModalData: async (companies: CompanyOption[]) => {
    const { companyId, getCompanyAccounts } = get();

    if (!companyId) return;

    try {
      // Load current company's accounts
      const accountsResult = await getCompanyAccounts(companyId);
      if (accountsResult.success && accountsResult.data) {
        set({ availableAccounts: accountsResult.data });
      }

      // Filter available companies (exclude current company)
      const filteredCompanies = companies
        .filter((c) => c.company_id !== companyId)
        .map((c) => ({
          company_id: c.company_id,
          company_name: c.company_name,
        }));

      set({ availableCompanies: filteredCompanies });
    } catch (error) {
      console.error('Error loading modal data:', error);
    }
  },

  /**
   * Refresh mappings
   */
  refresh: async () => {
    const { loadMappings } = get();
    await loadMappings();
  },

  /**
   * Reset store to initial state
   */
  reset: () =>
    set({
      companyId: '',
      mappings: [],
      availableAccounts: [],
      availableCompanies: [],
      loading: false,
      isCreating: false,
      isDeleting: false,
      error: null,
      showAddModal: false,
      showDeleteConfirm: false,
      deletingMappingId: null,
      deletingMappingInfo: null,
      showErrorMessage: false,
      errorMessageText: '',
    }),

  // ============================================
  // UI ACTIONS
  // ============================================

  /**
   * Open add modal
   */
  openAddModal: () => set({ showAddModal: true }),

  /**
   * Close add modal
   */
  closeAddModal: () => set({ showAddModal: false }),

  /**
   * Open delete confirmation modal
   */
  openDeleteConfirm: (mappingId, myAccountName, linkedAccountName) =>
    set({
      showDeleteConfirm: true,
      deletingMappingId: mappingId,
      deletingMappingInfo: {
        myAccount: myAccountName,
        linkedAccount: linkedAccountName,
      },
    }),

  /**
   * Close delete confirmation modal
   */
  closeDeleteConfirm: () =>
    set({
      showDeleteConfirm: false,
      deletingMappingId: null,
      deletingMappingInfo: null,
    }),

  /**
   * Show error message
   */
  showError: (message) =>
    set({
      showErrorMessage: true,
      errorMessageText: message,
    }),

  /**
   * Hide error message
   */
  hideError: () =>
    set({
      showErrorMessage: false,
      errorMessageText: '',
    }),
}));
