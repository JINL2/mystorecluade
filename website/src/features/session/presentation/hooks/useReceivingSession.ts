/**
 * useReceivingSession Hook
 * Custom hook for receiving session business logic
 * Handles session data loading, product search, save, and submit operations
 *
 * Architecture: Uses Repository pattern, Validator, and Zustand store
 */

import { useEffect, useCallback, useRef, useMemo, useState } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { useDebounce } from '@/shared/hooks/useDebounce';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import { useReceivingSessionStore } from '../providers/receiving_session_provider';
import type { SearchProduct } from '../../domain/entities';
import type {
  ReceivingItem,
  ReceivingSessionLocationState,
} from '../pages/ReceivingSessionPage/ReceivingSessionPage.types';
import type { ReceivedEntry, ActiveSession } from '../providers/states/receiving_session_state';

// Import presenters
import {
  toSessionInfoPresentation,
  toShipmentDataPresentation,
  toComparisonResultPresentation,
} from './useReceivingSession.presenters';

// Import converters
import {
  toPresentationSearchProduct,
  toPresentationSummary,
  toActiveSession,
  toDomainSearchProduct,
} from './useReceivingSession.converters';

// Import data loader
import { loadSessionData } from './useReceivingSession.dataLoader';

// Import handlers
import {
  createSaveHandler,
  createSubmitConfirmHandler,
  createCombineSessionSelectHandler,
  createMergeSessionsHandler,
  createSubmitSessionHandler,
  createNeedsDisplayCloseHandler,
} from './useReceivingSession.handlers';

import type { SearchProductPresentation } from './useReceivingSession.types';

// Re-export types for backward compatibility
export type {
  ReceivedEntry,
  EditableItem,
  ActiveSession,
  SearchProduct,
  SessionItem,
  SessionItemPresentation,
  SessionItemsSummaryPresentation,
  EditableItemPresentation,
  SearchProductPresentation,
} from './useReceivingSession.types';

// Re-export comparison types from presenters
export type {
  ComparisonResultPresentation,
} from './useReceivingSession.presenters';

// Re-export converters for external use
export {
  toPresentationSearchProduct,
  toPresentationSummary,
  toActiveSession,
  toDomainSearchProduct,
} from './useReceivingSession.converters';

// Alias types for backward compatibility with ReceivingSessionPage
export type MatchedItem = {
  productId: string;
  sku: string;
  productName: string;
  quantityA: number;
  quantityB: number;
  quantityDiff: number;
  isMatch: boolean;
};

export type OnlyInSessionItem = {
  productId: string;
  sku: string;
  productName: string;
  quantity: number;
};

export const useReceivingSession = () => {
  const { sessionId } = useParams<{ sessionId: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const { currentCompany, currentUser } = useAppState();
  const repository = useMemo(() => productReceiveRepository, []);

  // Get state from navigation
  const locationState = location.state as ReceivingSessionLocationState | null;

  // Zustand store
  const store = useReceivingSessionStore();

  // Refs
  const searchInputRef = useRef<HTMLInputElement>(null);
  const searchCacheRef = useRef<Map<string, SearchProduct[]>>(new Map());
  const isInitializedRef = useRef(false);

  // Track if initial data load has completed to prevent multiple loads
  const [isInitialized, setIsInitialized] = useState(false);

  // Local derived state for items (from shipment data)
  const items: ReceivingItem[] = useMemo(() => {
    if (!store.shipmentData?.items) return [];
    return store.shipmentData.items.map(item => ({
      item_id: item.itemId,
      product_id: item.productId,
      variant_id: item.variantId || null,
      product_name: item.productName,
      variant_name: item.variantName || null,
      display_name: item.displayName || item.productName,
      has_variants: item.hasVariants || false,
      sku: item.sku,
      quantity_shipped: item.quantityShipped,
      quantity_received: item.quantityReceived,
      quantity_accepted: item.quantityAccepted,
      quantity_rejected: item.quantityRejected,
      quantity_remaining: item.quantityRemaining,
      unit_cost: item.unitCost,
    }));
  }, [store.shipmentData]);

  // Debounced search query
  const debouncedSearchQuery = useDebounce(store.searchQuery, 300);

  // Memoize location state to prevent unnecessary re-renders
  const memoizedLocationState = useMemo(() => locationState, [
    locationState?.sessionData?.session_id,
    locationState?.shipmentId,
    locationState?.shipmentData?.shipment_id,
  ]);

  // Load session data - only runs once on mount or when sessionId changes
  useEffect(() => {
    if (isInitializedRef.current) return;
    if (!sessionId || !currentCompany) return;

    isInitializedRef.current = true;

    loadSessionData({
      sessionId,
      currentCompany,
      currentUser,
      locationState: memoizedLocationState,
      repository,
      store,
      setIsInitialized,
    });
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [sessionId, currentCompany?.company_id]);

  // Handle back navigation
  const handleBack = useCallback(() => {
    navigate('/product/session');
  }, [navigate]);

  // Instant search from cache when typing
  useEffect(() => {
    const query = store.searchQuery.trim().toLowerCase();
    if (!query) {
      store.setSearchResults([]);
      return;
    }

    const cachedResults = searchCacheRef.current.get(query);
    if (cachedResults) {
      store.setSearchResults(cachedResults);
      return;
    }

    for (const [, cachedProducts] of searchCacheRef.current.entries()) {
      const matchingProducts = cachedProducts.filter(p =>
        p.displaySku.toLowerCase().includes(query) ||
        p.displayName.toLowerCase().includes(query) ||
        (p.displayBarcode && p.displayBarcode.toLowerCase().includes(query))
      );
      if (matchingProducts.length > 0) {
        store.setSearchResults(matchingProducts);
        return;
      }
    }
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [store.searchQuery]);

  // Search products using Repository (debounced)
  useEffect(() => {
    const searchProducts = async () => {
      const query = debouncedSearchQuery.trim();
      if (!query || !currentCompany?.company_id || !store.sessionInfo?.storeId) {
        return;
      }

      const queryLower = query.toLowerCase();
      if (searchCacheRef.current.has(queryLower)) {
        return;
      }

      store.setIsSearching(true);
      try {
        const result = await repository.searchProducts(
          currentCompany.company_id,
          store.sessionInfo.storeId,
          query,
          1,
          10
        );

        store.setSearchResults(result.products);
        searchCacheRef.current.set(queryLower, result.products);

        if (searchCacheRef.current.size > 50) {
          const firstKey = searchCacheRef.current.keys().next().value;
          if (firstKey) searchCacheRef.current.delete(firstKey);
        }

        store.setCurrency({
          symbol: result.currency.symbol || '₫',
          code: result.currency.code || 'VND',
        });
      } catch (err) {
        console.error('Search error:', err);
        store.setSearchResults([]);
      } finally {
        store.setIsSearching(false);
      }
    };

    searchProducts();
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [debouncedSearchQuery, currentCompany?.company_id, store.sessionInfo?.storeId]);

  // Add product to received entries
  const addProductToReceived = useCallback((product: SearchProduct | SearchProductPresentation) => {
    const normalizedProduct: SearchProduct = 'productId' in product
      ? product
      : toDomainSearchProduct(product);

    const newEntry: ReceivedEntry = {
      entryId: `temp-${Date.now()}`,
      productId: normalizedProduct.productId,
      productName: normalizedProduct.displayName,
      sku: normalizedProduct.displaySku,
      variantId: normalizedProduct.variantId,
      quantity: 1,
      createdAt: new Date().toISOString(),
    };

    store.addReceivedEntry(newEntry);
    store.clearSearch();
    searchInputRef.current?.focus();
  }, [store]);

  // Handle product selection
  const handleSelectProduct = useCallback((product: SearchProduct | SearchProductPresentation) => {
    addProductToReceived(product);
  }, [addProductToReceived]);

  // Handle Enter key in search
  const handleSearchKeyDown = useCallback((e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && store.searchResults.length > 0) {
      e.preventDefault();
      addProductToReceived(store.searchResults[0]);
    }
  }, [store.searchResults, addProductToReceived]);

  // Update entry quantity
  const updateEntryQuantity = useCallback((entryId: string, delta: number) => {
    const entry = store.receivedEntries.find(e => e.entryId === entryId);
    if (entry) {
      store.updateEntryQuantity(entryId, entry.quantity + delta);
    }
  }, [store]);

  // Set entry quantity directly
  const setEntryQuantity = useCallback((entryId: string, quantity: number) => {
    store.updateEntryQuantity(entryId, quantity);
  }, [store]);

  // Remove entry
  const removeEntry = useCallback((entryId: string) => {
    store.removeEntry(entryId);
  }, [store]);

  // Clear search
  const clearSearch = useCallback(() => {
    store.clearSearch();
  }, [store]);

  // Create handlers using factory functions
  const handleSave = useCallback(
    createSaveHandler({ sessionId, currentUser, repository, store }),
    [sessionId, currentUser?.user_id, repository, store]
  );

  // Handle submit button click
  const handleSubmitClick = useCallback(() => {
    if (!sessionId || !currentUser?.user_id) {
      store.setSaveError('Session or user information missing');
      return;
    }
    store.setShowSubmitModeModal(true);
  }, [sessionId, currentUser?.user_id, store]);

  // Handle submit mode selection
  const handleSubmitModeSelect = useCallback((mode: string) => {
    store.setShowSubmitModeModal(false);

    if (mode === 'combine_session') {
      if (store.availableSessions.length === 0) {
        store.setComparisonError('No other active sessions available to combine');
        return;
      }
      store.setShowSessionSelectModal(true);
      return;
    }

    if (mode === 'only_this_session') {
      store.setShowSubmitConfirmModal(true);
    }
  }, [store]);

  // Close submit mode modal
  const handleSubmitModeClose = useCallback(() => {
    store.setShowSubmitModeModal(false);
  }, [store]);

  // Handle initial confirmation
  const handleSubmitConfirm = useCallback(
    createSubmitConfirmHandler({ sessionId, currentUser, repository, store }),
    [sessionId, currentUser?.user_id, repository, store]
  );

  // Close modals
  const handleSubmitConfirmClose = useCallback(() => {
    store.setShowSubmitConfirmModal(false);
  }, [store]);

  const handleSubmitReviewClose = useCallback(() => {
    store.resetSubmitState();
  }, [store]);

  const handleFinalChoiceClose = useCallback(() => {
    store.setShowFinalChoiceModal(false);
  }, [store]);

  // Close session select modal
  const handleSessionSelectClose = useCallback(() => {
    store.setShowSessionSelectModal(false);
    store.setSelectedCombineSession(null);
  }, [store]);

  // Handle session selection for combine
  const handleCombineSessionSelect = useCallback(
    createCombineSessionSelectHandler({ sessionId, currentUser, repository, store }),
    [sessionId, currentUser?.user_id, repository, store]
  );

  // Close comparison modal
  const handleComparisonClose = useCallback(() => {
    store.resetCompareState();
  }, [store]);

  // Handle merge sessions
  const handleMergeSessions = useCallback(
    createMergeSessionsHandler({ sessionId, currentUser, repository, store, navigate }),
    [sessionId, currentUser?.user_id, store.selectedCombineSession, repository, navigate, store]
  );

  // Handle quantity change in review modal
  const handleReviewQuantityChange = useCallback((
    productId: string,
    variantId: string | null,
    field: 'quantity' | 'quantityRejected',
    value: number
  ) => {
    store.updateEditableItemQuantity(productId, variantId, field, value);
  }, [store]);

  // Handle final submit button click
  const handleFinalSubmit = useCallback(() => {
    store.setShowSubmitReviewModal(false);
    store.setShowFinalChoiceModal(true);
  }, [store]);

  // Handle final submission
  const handleSubmitSession = useCallback(
    createSubmitSessionHandler({ sessionId, currentUser, repository, store, navigate }),
    [sessionId, currentUser?.user_id, store.editableItems, repository, navigate, store]
  );

  // Close needs display modal and navigate
  const handleNeedsDisplayClose = useCallback(
    createNeedsDisplayCloseHandler({ store, navigate }),
    [navigate, store]
  );

  // Dismiss errors
  const dismissSaveError = useCallback(() => {
    store.setSaveError(null);
  }, [store]);

  // Calculate totals
  const editableTotalQuantity = store.editableItems.reduce((sum, item) => sum + item.quantity, 0);
  const editableTotalRejected = store.editableItems.reduce((sum, item) => sum + item.quantityRejected, 0);

  const receivingSummary = store.shipmentData?.receivingSummary;
  const totalShipped = receivingSummary?.totalShipped ?? items.reduce((sum, item) => sum + item.quantity_shipped, 0);
  const totalReceived = receivingSummary?.totalReceived ?? items.reduce((sum, item) => sum + item.quantity_received, 0);
  const totalAccepted = receivingSummary?.totalAccepted ?? items.reduce((sum, item) => sum + item.quantity_accepted, 0);
  const totalRejected = receivingSummary?.totalRejected ?? items.reduce((sum, item) => sum + item.quantity_rejected, 0);
  const totalRemaining = receivingSummary?.totalRemaining ?? items.reduce((sum, item) => sum + item.quantity_remaining, 0);
  const progressPercentage = receivingSummary?.progressPercentage ?? (totalShipped > 0 ? (totalReceived / totalShipped) * 100 : 0);

  // Session items summary for backward compatibility
  const sessionItemsSummaryPresentation = store.sessionItemsSummary
    ? toPresentationSummary(store.sessionItemsSummary)
    : null;

  // Convert store state to presentation formats using presenter functions
  const sessionInfoPresentation = toSessionInfoPresentation(store.sessionInfo);
  const shipmentDataPresentation = toShipmentDataPresentation(store.shipmentData);
  const comparisonResultPresentation = toComparisonResultPresentation(store.comparisonResult);

  return {
    // Session state (presentation format for backward compatibility)
    sessionId,
    sessionInfo: sessionInfoPresentation,
    shipmentData: shipmentDataPresentation,
    items,
    loading: store.loading,
    error: store.error,
    currentUser,

    // Search state (domain entity format for component compatibility)
    searchQuery: store.searchQuery,
    setSearchQuery: store.setSearchQuery,
    searchResults: store.searchResults,
    isSearching: store.isSearching,
    currency: store.currency,
    searchInputRef,
    debouncedSearchQuery,

    // Received entries (domain entity format for component compatibility)
    receivedEntries: store.receivedEntries,

    // Save state
    isSaving: store.isSaving,
    saveError: store.saveError,
    saveSuccess: store.saveSuccess,

    // Submit state
    showSubmitModeModal: store.showSubmitModeModal,
    showSubmitConfirmModal: store.showSubmitConfirmModal,
    showSubmitReviewModal: store.showSubmitReviewModal,
    showFinalChoiceModal: store.showFinalChoiceModal,
    isLoadingSessionItems: store.isLoadingSessionItems,
    isSubmitting: store.isSubmitting,
    submitError: store.submitError,
    submitSuccess: store.submitSuccess,

    // Session items for review (domain entity format for component compatibility)
    sessionItems: store.sessionItems,
    sessionItemsSummary: sessionItemsSummaryPresentation,
    editableItems: store.editableItems,

    // Combine session state
    showSessionSelectModal: store.showSessionSelectModal,
    availableSessions: store.availableSessions,
    selectedCombineSession: store.selectedCombineSession,
    showComparisonModal: store.showComparisonModal,
    comparisonResult: comparisonResultPresentation,
    isLoadingComparison: store.isLoadingComparison,
    comparisonError: store.comparisonError,

    // Merge state
    isMerging: store.isMerging,
    mergeError: store.mergeError,
    mergeSuccess: store.mergeSuccess,

    // Needs display modal state
    showNeedsDisplayModal: store.showNeedsDisplayModal,
    needsDisplayItems: store.needsDisplayItems,
    submitResultData: store.submitResultData,

    // Calculated totals
    editableTotalQuantity,
    editableTotalRejected,
    totalShipped,
    totalReceived,
    totalAccepted,
    totalRejected,
    totalRemaining,
    progressPercentage,

    // Session active status for UI controls
    isSessionActive: store.sessionInfo?.isActive ?? true,

    // Actions
    handleBack,
    handleSelectProduct,
    handleSearchKeyDown,
    updateEntryQuantity,
    setEntryQuantity,
    removeEntry,
    clearSearch,
    handleSave,
    handleSubmitClick,
    handleSubmitModeSelect,
    handleSubmitModeClose,
    handleSubmitConfirm,
    handleSubmitConfirmClose,
    handleSubmitReviewClose,
    handleFinalChoiceClose,
    handleReviewQuantityChange,
    handleFinalSubmit,
    handleSubmitSession,
    dismissSaveError,

    // Combine session actions
    handleSessionSelectClose,
    handleCombineSessionSelect,
    handleComparisonClose,

    // Merge action
    handleMergeSessions,

    // Needs display action
    handleNeedsDisplayClose,
  };
};
