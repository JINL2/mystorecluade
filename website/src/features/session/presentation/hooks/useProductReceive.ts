/**
 * useProductReceive Hook
 * Thin wrapper for receiving session Zustand store
 * Provides access to store state and actions with optimized selectors
 */

import { useCallback, useMemo } from 'react';
import {
  useReceivingSessionStore,
  useSessionInfo,
  useShipmentData,
  useSessionLoading,
  useSessionError,
  useSearchState,
  useReceivedEntries,
  useSaveState,
  useSubmitState,
  useSessionItems,
  useCombineState,
  useMergeState,
  useNeedsDisplayState,
} from '../providers/receiving_session_provider';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import { ReceiveValidator } from '../../domain/validators/ReceiveValidator';
import type { SaveItem, SubmitItem } from '../../domain/entities';

/**
 * Main hook for product receive feature
 * Provides all store state and actions
 */
export const useProductReceive = () => {
  const store = useReceivingSessionStore();
  const repository = useMemo(() => productReceiveRepository, []);

  // Optimized selectors
  const sessionInfo = useSessionInfo();
  const shipmentData = useShipmentData();
  const loading = useSessionLoading();
  const error = useSessionError();
  const searchState = useSearchState();
  const receivedEntries = useReceivedEntries();
  const saveState = useSaveState();
  const submitState = useSubmitState();
  const sessionItems = useSessionItems();
  const combineState = useCombineState();
  const mergeState = useMergeState();
  const needsDisplayState = useNeedsDisplayState();

  // Validate and save items
  const validateAndSave = useCallback(async (
    sessionId: string,
    userId: string,
    items: SaveItem[]
  ): Promise<{ success: boolean; error?: string }> => {
    const validation = ReceiveValidator.validateSaveItems(items);
    if (!validation.isValid) {
      return { success: false, error: validation.errors.join(', ') };
    }

    try {
      await repository.addSessionItems(sessionId, userId, items);
      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to save items',
      };
    }
  }, [repository]);

  // Validate and submit items
  const validateAndSubmit = useCallback(async (
    sessionId: string,
    userId: string,
    items: SubmitItem[],
    isFinal: boolean,
    notes?: string
  ): Promise<{ success: boolean; error?: string; result?: unknown }> => {
    const validation = ReceiveValidator.validateSubmitItems(items);
    if (!validation.isValid) {
      return { success: false, error: validation.errors.join(', ') };
    }

    try {
      const result = await repository.submitSession(sessionId, userId, items, isFinal, notes);
      return { success: true, result };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to submit session',
      };
    }
  }, [repository]);

  // Search products
  const searchProducts = useCallback(async (
    companyId: string,
    storeId: string,
    query: string,
    page?: number,
    limit?: number
  ) => {
    try {
      return await repository.searchProducts(companyId, storeId, query, page, limit);
    } catch (err) {
      console.error('Search products error:', err);
      return { products: [], currency: { symbol: '₫', code: 'VND' } };
    }
  }, [repository]);

  // Compare sessions
  const compareSessions = useCallback(async (
    sessionIdA: string,
    sessionIdB: string,
    userId: string
  ) => {
    try {
      return await repository.compareSessions({ sessionIdA, sessionIdB, userId });
    } catch (err) {
      console.error('Compare sessions error:', err);
      throw err;
    }
  }, [repository]);

  // Merge sessions
  const mergeSessions = useCallback(async (
    targetSessionId: string,
    sourceSessionId: string,
    userId: string
  ) => {
    try {
      return await repository.mergeSessions({ targetSessionId, sourceSessionId, userId });
    } catch (err) {
      console.error('Merge sessions error:', err);
      throw err;
    }
  }, [repository]);

  return {
    // Store state (optimized selectors)
    sessionInfo,
    shipmentData,
    loading,
    error,
    ...searchState,
    receivedEntries,
    ...saveState,
    ...submitState,
    ...sessionItems,
    ...combineState,
    ...mergeState,
    ...needsDisplayState,

    // Store actions
    setSessionInfo: store.setSessionInfo,
    setShipmentData: store.setShipmentData,
    setLoading: store.setLoading,
    setError: store.setError,
    setSearchQuery: store.setSearchQuery,
    setSearchResults: store.setSearchResults,
    setIsSearching: store.setIsSearching,
    setCurrency: store.setCurrency,
    clearSearch: store.clearSearch,
    addReceivedEntry: store.addReceivedEntry,
    updateEntryQuantity: store.updateEntryQuantity,
    removeEntry: store.removeEntry,
    clearReceivedEntries: store.clearReceivedEntries,
    setIsSaving: store.setIsSaving,
    setSaveError: store.setSaveError,
    setSaveSuccess: store.setSaveSuccess,
    setShowSubmitModeModal: store.setShowSubmitModeModal,
    setShowSubmitConfirmModal: store.setShowSubmitConfirmModal,
    setShowSubmitReviewModal: store.setShowSubmitReviewModal,
    setShowFinalChoiceModal: store.setShowFinalChoiceModal,
    setIsLoadingSessionItems: store.setIsLoadingSessionItems,
    setIsSubmitting: store.setIsSubmitting,
    setSubmitError: store.setSubmitError,
    setSubmitSuccess: store.setSubmitSuccess,
    setSessionItems: store.setSessionItems,
    setSessionItemsSummary: store.setSessionItemsSummary,
    setEditableItems: store.setEditableItems,
    updateEditableItemQuantity: store.updateEditableItemQuantity,
    setAvailableSessions: store.setAvailableSessions,
    setShowSessionSelectModal: store.setShowSessionSelectModal,
    setSelectedCombineSession: store.setSelectedCombineSession,
    setShowComparisonModal: store.setShowComparisonModal,
    setComparisonResult: store.setComparisonResult,
    setIsLoadingComparison: store.setIsLoadingComparison,
    setComparisonError: store.setComparisonError,
    setIsMerging: store.setIsMerging,
    setMergeError: store.setMergeError,
    setMergeSuccess: store.setMergeSuccess,
    setShowNeedsDisplayModal: store.setShowNeedsDisplayModal,
    setNeedsDisplayItems: store.setNeedsDisplayItems,
    setSubmitResultData: store.setSubmitResultData,
    reset: store.reset,
    resetSubmitState: store.resetSubmitState,
    resetCompareState: store.resetCompareState,

    // Repository operations with validation
    validateAndSave,
    validateAndSubmit,
    searchProducts,
    compareSessions,
    mergeSessions,

    // Repository reference
    repository,

    // Validator reference
    validator: ReceiveValidator,
  };
};

/**
 * Hook for accessing only search-related state and actions
 */
export const useProductSearch = () => {
  const searchState = useSearchState();
  const store = useReceivingSessionStore();

  return {
    ...searchState,
    setSearchQuery: store.setSearchQuery,
    setSearchResults: store.setSearchResults,
    setIsSearching: store.setIsSearching,
    setCurrency: store.setCurrency,
    clearSearch: store.clearSearch,
  };
};

/**
 * Hook for accessing only received entries state and actions
 */
export const useReceivedItems = () => {
  const receivedEntries = useReceivedEntries();
  const store = useReceivingSessionStore();

  return {
    receivedEntries,
    addReceivedEntry: store.addReceivedEntry,
    updateEntryQuantity: store.updateEntryQuantity,
    removeEntry: store.removeEntry,
    clearReceivedEntries: store.clearReceivedEntries,
  };
};

/**
 * Hook for accessing only submit-related state and actions
 */
export const useSubmitSession = () => {
  const submitState = useSubmitState();
  const sessionItems = useSessionItems();
  const store = useReceivingSessionStore();

  return {
    ...submitState,
    ...sessionItems,
    setShowSubmitModeModal: store.setShowSubmitModeModal,
    setShowSubmitConfirmModal: store.setShowSubmitConfirmModal,
    setShowSubmitReviewModal: store.setShowSubmitReviewModal,
    setShowFinalChoiceModal: store.setShowFinalChoiceModal,
    setIsLoadingSessionItems: store.setIsLoadingSessionItems,
    setIsSubmitting: store.setIsSubmitting,
    setSubmitError: store.setSubmitError,
    setSubmitSuccess: store.setSubmitSuccess,
    setSessionItems: store.setSessionItems,
    setSessionItemsSummary: store.setSessionItemsSummary,
    setEditableItems: store.setEditableItems,
    updateEditableItemQuantity: store.updateEditableItemQuantity,
    resetSubmitState: store.resetSubmitState,
  };
};

/**
 * Hook for accessing only combine/merge-related state and actions
 */
export const useCombineSession = () => {
  const combineState = useCombineState();
  const mergeState = useMergeState();
  const store = useReceivingSessionStore();

  return {
    ...combineState,
    ...mergeState,
    setAvailableSessions: store.setAvailableSessions,
    setShowSessionSelectModal: store.setShowSessionSelectModal,
    setSelectedCombineSession: store.setSelectedCombineSession,
    setShowComparisonModal: store.setShowComparisonModal,
    setComparisonResult: store.setComparisonResult,
    setIsLoadingComparison: store.setIsLoadingComparison,
    setComparisonError: store.setComparisonError,
    setIsMerging: store.setIsMerging,
    setMergeError: store.setMergeError,
    setMergeSuccess: store.setMergeSuccess,
    resetCompareState: store.resetCompareState,
  };
};
