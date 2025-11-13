/**
 * useAccountMapping Hook
 * Custom hook wrapper for account mapping Zustand store
 *
 * Following Clean Architecture and 2025 Best Practice:
 * - Thin wrapper around Zustand store
 * - Selector optimization for performance
 * - Clear API for components
 */

import { useEffect } from 'react';
import { useAccountMappingStore } from '../providers/account_mapping_provider';

/**
 * Custom hook for account mapping management
 * Provides clean API to components with optimized selectors
 */
export const useAccountMapping = (companyId: string) => {
  // ============================================
  // STATE SELECTORS (Optimized)
  // ============================================

  // Data state
  const mappings = useAccountMappingStore((state) => state.mappings);
  const availableAccounts = useAccountMappingStore((state) => state.availableAccounts);
  const availableCompanies = useAccountMappingStore((state) => state.availableCompanies);

  // Loading state
  const loading = useAccountMappingStore((state) => state.loading);
  const isCreating = useAccountMappingStore((state) => state.isCreating);
  const isDeleting = useAccountMappingStore((state) => state.isDeleting);

  // Error state
  const error = useAccountMappingStore((state) => state.error);
  const showErrorMessage = useAccountMappingStore((state) => state.showErrorMessage);
  const errorMessageText = useAccountMappingStore((state) => state.errorMessageText);

  // Modal state
  const showAddModal = useAccountMappingStore((state) => state.showAddModal);
  const showDeleteConfirm = useAccountMappingStore((state) => state.showDeleteConfirm);
  const deletingMappingId = useAccountMappingStore((state) => state.deletingMappingId);
  const deletingMappingInfo = useAccountMappingStore((state) => state.deletingMappingInfo);

  // ============================================
  // ACTIONS
  // ============================================

  // State setters
  const setCompanyId = useAccountMappingStore((state) => state.setCompanyId);

  // Async actions
  const loadMappings = useAccountMappingStore((state) => state.loadMappings);
  const createMapping = useAccountMappingStore((state) => state.createMapping);
  const deleteMapping = useAccountMappingStore((state) => state.deleteMapping);
  const getCompanyAccounts = useAccountMappingStore((state) => state.getCompanyAccounts);
  const loadModalData = useAccountMappingStore((state) => state.loadModalData);
  const refresh = useAccountMappingStore((state) => state.refresh);

  // UI actions
  const openAddModal = useAccountMappingStore((state) => state.openAddModal);
  const closeAddModal = useAccountMappingStore((state) => state.closeAddModal);
  const openDeleteConfirm = useAccountMappingStore((state) => state.openDeleteConfirm);
  const closeDeleteConfirm = useAccountMappingStore((state) => state.closeDeleteConfirm);
  const showError = useAccountMappingStore((state) => state.showError);
  const hideError = useAccountMappingStore((state) => state.hideError);

  // ============================================
  // COMPUTED VALUES (Optimized with Zustand selectors)
  // ============================================

  /**
   * Outgoing mappings (created by current company)
   * Using selector for automatic re-render optimization
   */
  const outgoingMappings = useAccountMappingStore((state) =>
    state.mappings.filter((m) => !m.isReadOnly)
  );

  /**
   * Incoming mappings (created by other companies, read-only)
   * Using selector for automatic re-render optimization
   */
  const incomingMappings = useAccountMappingStore((state) =>
    state.mappings.filter((m) => m.isReadOnly)
  );

  // ============================================
  // EFFECTS
  // ============================================

  /**
   * Update company ID and load mappings when companyId changes
   *
   * Following ARCHITECTURE.md Best Practice:
   * - Only include primitive dependencies (companyId)
   * - Zustand actions are stable, no need in dependency array
   * - Prevents infinite loop from function reference changes
   */
  useEffect(() => {
    setCompanyId(companyId);
    loadMappings();
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [companyId]);

  // ============================================
  // RETURN API
  // ============================================

  return {
    // State
    mappings,
    availableAccounts,
    availableCompanies,
    loading,
    isCreating,
    isDeleting,
    error,
    showErrorMessage,
    errorMessageText,
    showAddModal,
    showDeleteConfirm,
    deletingMappingId,
    deletingMappingInfo,

    // Computed values (optimized with selectors)
    outgoingMappings,
    incomingMappings,

    // Actions
    createMapping,
    deleteMapping,
    getCompanyAccounts,
    loadModalData,
    refresh,
    setCompanyId,

    // UI actions
    openAddModal,
    closeAddModal,
    openDeleteConfirm,
    closeDeleteConfirm,
    showError,
    hideError,
  };
};

/**
 * Alternative hook for direct store access without companyId dependency
 * Use this when you need more control over when to load data
 */
export const useAccountMappingStore_Direct = () => {
  return useAccountMappingStore();
};
