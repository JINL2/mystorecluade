/**
 * useReceivingSession Hook
 * Custom hook for receiving session business logic
 * Handles session data loading, product search, save, and submit operations
 *
 * Architecture: Uses Repository pattern, Validator, and Zustand store
 */

import { useEffect, useCallback, useRef, useMemo } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { useDebounce } from '@/shared/hooks/useDebounce';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import { ReceiveValidator } from '../../domain/validators/ReceiveValidator';
import { useReceivingSessionStore } from '../providers/receiving_session_provider';
import type {
  SearchProduct,
  SessionItem,
  SessionItemsSummary,
  CompareSessionsResult,
  Session,
} from '../../domain/entities';
import type {
  SessionInfo,
  ReceivingItem,
  ReceivingSessionLocationState,
  ShipmentData,
} from '../pages/ReceivingSessionPage/ReceivingSessionPage.types';
import type {
  ReceivedEntry,
  EditableItem,
  ActiveSession,
} from '../providers/states/receiving_session_state';

// Re-export types for backward compatibility
export type {
  ReceivedEntry,
  EditableItem,
  ActiveSession,
} from '../providers/states/receiving_session_state';

// Presentation layer types for backward compatibility
export interface SessionItemPresentation {
  product_id: string;
  product_name: string;
  total_quantity: number;
  total_rejected: number;
  scanned_by: {
    user_id: string;
    user_name: string;
    quantity: number;
    quantity_rejected: number;
  }[];
}

export interface SessionItemsSummaryPresentation {
  total_products: number;
  total_quantity: number;
  total_rejected: number;
}

export interface EditableItemPresentation {
  product_id: string;
  product_name: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SearchProductPresentation {
  product_id: string;
  product_name: string;
  sku: string;
  barcode?: string;
  image_urls?: string[];
  stock: {
    quantity_on_hand: number;
    quantity_available: number;
    quantity_reserved: number;
  };
  price: {
    cost: number;
    selling: number;
    source: string;
  };
}

// Helper to convert domain entity to presentation format
const toPresentationSearchProduct = (p: SearchProduct): SearchProductPresentation => ({
  product_id: p.productId,
  product_name: p.productName,
  sku: p.sku,
  barcode: p.barcode,
  image_urls: p.imageUrls,
  stock: {
    quantity_on_hand: p.stock.quantityOnHand,
    quantity_available: p.stock.quantityAvailable,
    quantity_reserved: p.stock.quantityReserved,
  },
  price: {
    cost: p.price.cost,
    selling: p.price.selling,
    source: p.price.source,
  },
});

const toPresentationSessionItem = (item: SessionItem): SessionItemPresentation => ({
  product_id: item.productId,
  product_name: item.productName,
  total_quantity: item.totalQuantity,
  total_rejected: item.totalRejected,
  scanned_by: item.scannedBy.map(user => ({
    user_id: user.userId,
    user_name: user.userName,
    quantity: user.quantity,
    quantity_rejected: user.quantityRejected,
  })),
});

const toPresentationSummary = (summary: SessionItemsSummary): SessionItemsSummaryPresentation => ({
  total_products: summary.totalProducts,
  total_quantity: summary.totalQuantity,
  total_rejected: summary.totalRejected,
});

const toPresentationEditableItem = (item: EditableItem): EditableItemPresentation => ({
  product_id: item.productId,
  product_name: item.productName,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

// Helper to convert Session to ActiveSession
const toActiveSession = (s: Session): ActiveSession => ({
  sessionId: s.sessionId,
  sessionName: s.sessionName || '',
  sessionType: s.sessionType,
  storeId: s.storeId,
  storeName: s.storeName,
  isActive: s.isActive,
  isFinal: s.isFinal,
  memberCount: s.memberCount || 0,
  createdBy: s.createdBy,
  createdByName: s.createdByName,
  completedAt: null,
  createdAt: s.createdAt,
});

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

  // Local derived state for items (from shipment data)
  const items: ReceivingItem[] = useMemo(() => {
    if (!store.shipmentData?.items) return [];
    return store.shipmentData.items.map(item => ({
      item_id: item.itemId,
      product_id: item.productId,
      product_name: item.productName,
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

  // Load session data
  useEffect(() => {
    const loadSessionData = async () => {
      if (!sessionId || !currentCompany) return;

      store.setLoading(true);
      store.setError(null);

      try {
        // If we have data from navigation state, use it
        if (locationState?.sessionData) {
          const sessionData = locationState.sessionData;
          store.setSessionInfo({
            sessionId: sessionData.session_id || sessionId,
            sessionType: sessionData.session_type || 'receiving',
            storeId: sessionData.store_id || '',
            storeName: sessionData.store_name || '',
            shipmentId: locationState.shipmentId || sessionData.shipment_id || null,
            shipmentNumber: locationState.shipmentData?.shipment_number || sessionData.shipment_number || null,
            isActive: sessionData.is_active ?? true,
            isFinal: sessionData.is_final ?? false,
            createdBy: sessionData.created_by || '',
            createdByName: sessionData.created_by_name || '',
            createdAt: sessionData.created_at || new Date().toISOString(),
            memberCount: sessionData.member_count,
          });
        }

        // If we have shipment data from navigation state, use it
        if (locationState?.shipmentData) {
          const shipment = locationState.shipmentData;
          store.setShipmentData({
            shipmentId: shipment.shipment_id,
            shipmentNumber: shipment.shipment_number,
            supplierName: shipment.supplier_name,
            status: shipment.status,
            shippedDate: shipment.shipped_date,
            items: shipment.items?.map(item => ({
              itemId: item.item_id,
              productId: item.product_id,
              productName: item.product_name,
              sku: item.sku,
              quantityShipped: item.quantity_shipped,
              quantityReceived: item.quantity_received,
              quantityAccepted: item.quantity_accepted,
              quantityRejected: item.quantity_rejected,
              quantityRemaining: item.quantity_remaining,
              unitCost: item.unit_cost,
            })) || [],
            receivingSummary: shipment.receiving_summary ? {
              totalShipped: shipment.receiving_summary.total_shipped,
              totalReceived: shipment.receiving_summary.total_received,
              totalAccepted: shipment.receiving_summary.total_accepted,
              totalRejected: shipment.receiving_summary.total_rejected,
              totalRemaining: shipment.receiving_summary.total_remaining,
              progressPercentage: shipment.receiving_summary.progress_percentage,
            } : undefined,
          });
        }

        // If no navigation state, set default session info
        if (!locationState?.sessionData) {
          store.setSessionInfo({
            sessionId: sessionId,
            sessionType: 'receiving',
            storeId: '',
            storeName: 'Loading...',
            shipmentId: null,
            shipmentNumber: null,
            isActive: true,
            isFinal: false,
            createdBy: '',
            createdByName: '',
            createdAt: new Date().toISOString(),
          });
        }

        // Load available sessions for combine feature
        const storedSessions = localStorage.getItem('receiving_active_sessions');
        if (storedSessions) {
          try {
            const sessions: ActiveSession[] = JSON.parse(storedSessions);
            store.setAvailableSessions(sessions.filter(s => s.sessionId !== sessionId));
          } catch {
            console.error('Failed to parse active sessions from localStorage');
          }
        }

        // If no localStorage data and we have shipment_id, fetch from API
        const shipmentId = locationState?.shipmentId || locationState?.sessionData?.shipment_id;
        if ((!storedSessions || storedSessions === '[]') && shipmentId && currentCompany) {
          try {
            const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
            const sessionsResult = await repository.getSessionList({
              companyId: currentCompany.company_id,
              shipmentId: shipmentId,
              sessionType: 'receiving',
              isActive: true,
              timezone: userTimezone,
            });

            const otherSessions = sessionsResult
              .filter(s => s.sessionId !== sessionId && s.isActive)
              .map(toActiveSession);

            store.setAvailableSessions(otherSessions);
            localStorage.setItem('receiving_active_sessions', JSON.stringify(otherSessions));
          } catch (err) {
            console.error('Failed to load active sessions from API:', err);
          }
        }
      } catch (err) {
        console.error('Load session error:', err);
        store.setError(err instanceof Error ? err.message : 'Failed to load session');
      } finally {
        store.setLoading(false);
      }
    };

    loadSessionData();
  }, [sessionId, currentCompany, locationState, repository, store]);

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
        p.sku.toLowerCase().includes(query) ||
        p.productName.toLowerCase().includes(query) ||
        (p.barcode && p.barcode.toLowerCase().includes(query))
      );
      if (matchingProducts.length > 0) {
        store.setSearchResults(matchingProducts);
        return;
      }
    }
  }, [store.searchQuery, store]);

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
  }, [debouncedSearchQuery, currentCompany?.company_id, store.sessionInfo?.storeId, repository, store]);

  // Add product to received entries
  const addProductToReceived = useCallback((product: SearchProduct | SearchProductPresentation) => {
    // Normalize to domain entity if presentation format
    const normalizedProduct: SearchProduct = 'productId' in product ? product : {
      productId: product.product_id,
      productName: product.product_name,
      sku: product.sku,
      barcode: product.barcode,
      imageUrls: product.image_urls,
      stock: {
        quantityOnHand: product.stock.quantity_on_hand,
        quantityAvailable: product.stock.quantity_available,
        quantityReserved: product.stock.quantity_reserved,
      },
      price: {
        cost: product.price.cost,
        selling: product.price.selling,
        source: product.price.source,
      },
    };

    const newEntry: ReceivedEntry = {
      entryId: `temp-${Date.now()}`,
      productId: normalizedProduct.productId,
      productName: normalizedProduct.productName,
      sku: normalizedProduct.sku,
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

  // Handle save - using Repository and Validator
  const handleSave = useCallback(async () => {
    if (!sessionId || !currentUser?.user_id) {
      store.setSaveError('Session or user information missing');
      return;
    }

    // Convert received entries to SaveItem format for validation
    const itemsToSave = store.receivedEntries.map(entry => ({
      productId: entry.productId,
      quantity: entry.quantity,
      quantityRejected: 0,
    }));

    // Use Validator for validation
    const validationResult = ReceiveValidator.validateSaveItems(itemsToSave);
    if (!validationResult.isValid) {
      store.setSaveError(validationResult.errors.join(', '));
      return;
    }

    store.setIsSaving(true);
    store.setSaveError(null);
    store.setSaveSuccess(false);

    try {
      await repository.addSessionItems(sessionId, currentUser.user_id, itemsToSave);
      store.setSaveSuccess(true);
      store.clearReceivedEntries();
      setTimeout(() => store.setSaveSuccess(false), 3000);
    } catch (err) {
      console.error('Save error:', err);
      store.setSaveError(err instanceof Error ? err.message : 'Failed to save items');
    } finally {
      store.setIsSaving(false);
    }
  }, [store.receivedEntries, sessionId, currentUser?.user_id, repository, store]);

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

  // Handle initial confirmation - load session items using Repository
  const handleSubmitConfirm = useCallback(async () => {
    store.setShowSubmitConfirmModal(false);

    if (!sessionId || !currentUser?.user_id) {
      store.setSubmitError('Session or user information missing');
      return;
    }

    store.setIsLoadingSessionItems(true);
    store.setSubmitError(null);

    try {
      const result = await repository.getSessionItems(sessionId, currentUser.user_id);

      store.setSessionItems(result.items);
      store.setSessionItemsSummary(result.summary);
      store.setEditableItems(result.items.map(item => ({
        productId: item.productId,
        productName: item.productName,
        quantity: item.totalQuantity,
        quantityRejected: item.totalRejected,
      })));
      store.setShowSubmitReviewModal(true);
    } catch (err) {
      console.error('Load session items error:', err);
      store.setSubmitError(err instanceof Error ? err.message : 'Failed to load session items');
    } finally {
      store.setIsLoadingSessionItems(false);
    }
  }, [sessionId, currentUser?.user_id, repository, store]);

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

  // Handle session selection for combine - using Repository
  const handleCombineSessionSelect = useCallback(async (selectedSession: ActiveSession) => {
    if (!sessionId || !currentUser?.user_id) {
      store.setComparisonError('Session or user information missing');
      return;
    }

    store.setSelectedCombineSession(selectedSession);
    store.setShowSessionSelectModal(false);
    store.setIsLoadingComparison(true);
    store.setComparisonError(null);

    try {
      const result = await repository.compareSessions({
        sessionIdA: sessionId,
        sessionIdB: selectedSession.sessionId,
        userId: currentUser.user_id,
      });

      store.setComparisonResult(result);
      store.setShowComparisonModal(true);
    } catch (err) {
      console.error('Comparison error:', err);
      store.setComparisonError(err instanceof Error ? err.message : 'Failed to compare sessions');
    } finally {
      store.setIsLoadingComparison(false);
    }
  }, [sessionId, currentUser?.user_id, repository, store]);

  // Close comparison modal
  const handleComparisonClose = useCallback(() => {
    store.resetCompareState();
  }, [store]);

  // Handle merge sessions - using Repository
  const handleMergeSessions = useCallback(async () => {
    if (!sessionId || !currentUser?.user_id || !store.selectedCombineSession) {
      store.setMergeError('Session or user information missing');
      return;
    }

    store.setIsMerging(true);
    store.setMergeError(null);

    try {
      await repository.mergeSessions({
        targetSessionId: sessionId,
        sourceSessionId: store.selectedCombineSession.sessionId,
        userId: currentUser.user_id,
      });

      // Remove merged session from localStorage
      const storedSessions = localStorage.getItem('receiving_active_sessions');
      if (storedSessions) {
        try {
          const sessions: ActiveSession[] = JSON.parse(storedSessions);
          const updatedSessions = sessions.filter(
            s => s.sessionId !== store.selectedCombineSession?.sessionId
          );
          localStorage.setItem('receiving_active_sessions', JSON.stringify(updatedSessions));
          store.setAvailableSessions(updatedSessions.filter(s => s.sessionId !== sessionId));
        } catch {
          console.error('Failed to update active sessions in localStorage');
        }
      }

      store.setMergeSuccess(true);
      store.resetCompareState();
      navigate(0); // Page refresh

      setTimeout(() => store.setMergeSuccess(false), 3000);
    } catch (err) {
      console.error('Merge error:', err);
      store.setMergeError(err instanceof Error ? err.message : 'Failed to merge sessions');
    } finally {
      store.setIsMerging(false);
    }
  }, [sessionId, currentUser?.user_id, store.selectedCombineSession, repository, navigate, store]);

  // Handle quantity change in review modal
  const handleReviewQuantityChange = useCallback((
    productId: string,
    field: 'quantity' | 'quantity_rejected',
    value: number
  ) => {
    const mappedField = field === 'quantity_rejected' ? 'quantityRejected' : 'quantity';
    store.updateEditableItemQuantity(productId, mappedField, value);
  }, [store]);

  // Handle final submit button click
  const handleFinalSubmit = useCallback(() => {
    store.setShowSubmitReviewModal(false);
    store.setShowFinalChoiceModal(true);
  }, [store]);

  // Handle final submission using Repository and Validator
  const handleSubmitSession = useCallback(async (isFinal: boolean) => {
    if (!sessionId || !currentUser?.user_id) {
      store.setSubmitError('Session or user information missing');
      return;
    }

    // Convert editable items to SubmitItem format
    const itemsToSubmit = store.editableItems.map(item => ({
      productId: item.productId,
      quantity: item.quantity,
      quantityRejected: item.quantityRejected,
    }));

    // Use Validator for validation
    const validationResult = ReceiveValidator.validateSubmitItems(itemsToSubmit);
    if (!validationResult.isValid) {
      store.setSubmitError(validationResult.errors.join(', '));
      return;
    }

    store.setShowFinalChoiceModal(false);
    store.setIsSubmitting(true);
    store.setSubmitError(null);

    try {
      const result = await repository.submitSession(
        sessionId,
        currentUser.user_id,
        itemsToSubmit,
        isFinal
      );

      store.setSubmitSuccess(true);

      // Check for products that need display
      const displayItems = (result.stockChanges || [])
        .filter(item => item.needsDisplay)
        .map(item => ({
          productId: item.productId,
          sku: item.sku,
          productName: item.productName,
          quantityReceived: item.quantityReceived,
        }));

      if (displayItems.length > 0) {
        store.setNeedsDisplayItems(displayItems);
        store.setSubmitResultData({
          receivingNumber: result.receivingNumber,
          itemsCount: result.itemsCount,
          totalQuantity: result.totalQuantity,
        });
        store.setShowNeedsDisplayModal(true);
        store.setIsSubmitting(false);
      } else {
        navigate('/product/session', {
          state: {
            submitSuccess: true,
            receivingNumber: result.receivingNumber,
            itemsCount: result.itemsCount,
            totalQuantity: result.totalQuantity,
            refreshData: true,
          }
        });
      }
    } catch (err) {
      console.error('Submit session error:', err);
      store.setSubmitError(err instanceof Error ? err.message : 'Failed to submit session');
      store.setShowFinalChoiceModal(true);
      store.setIsSubmitting(false);
    }
  }, [sessionId, currentUser?.user_id, store.editableItems, repository, navigate, store]);

  // Close needs display modal and navigate
  const handleNeedsDisplayClose = useCallback(() => {
    store.setShowNeedsDisplayModal(false);
    store.setNeedsDisplayItems([]);

    navigate('/product/session', {
      state: {
        submitSuccess: true,
        receivingNumber: store.submitResultData?.receivingNumber,
        itemsCount: store.submitResultData?.itemsCount,
        totalQuantity: store.submitResultData?.totalQuantity,
        refreshData: true,
      }
    });
    store.setSubmitResultData(null);
  }, [navigate, store]);

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

  // Convert domain entities to presentation format for backward compatibility
  const searchResultsPresentation = store.searchResults.map(toPresentationSearchProduct);
  const sessionItemsPresentation = store.sessionItems.map(toPresentationSessionItem);
  const sessionItemsSummaryPresentation = store.sessionItemsSummary
    ? toPresentationSummary(store.sessionItemsSummary)
    : null;
  const editableItemsPresentation = store.editableItems.map(toPresentationEditableItem);

  // Convert receivedEntries to presentation format
  const receivedEntriesPresentation = store.receivedEntries.map(e => ({
    entry_id: e.entryId,
    product_id: e.productId,
    product_name: e.productName,
    sku: e.sku,
    quantity: e.quantity,
    created_at: e.createdAt,
  }));

  // Convert sessionInfo to presentation format
  const sessionInfoPresentation: SessionInfo | null = store.sessionInfo ? {
    session_id: store.sessionInfo.sessionId,
    session_type: store.sessionInfo.sessionType,
    store_id: store.sessionInfo.storeId,
    store_name: store.sessionInfo.storeName,
    shipment_id: store.sessionInfo.shipmentId,
    shipment_number: store.sessionInfo.shipmentNumber,
    is_active: store.sessionInfo.isActive,
    is_final: store.sessionInfo.isFinal,
    created_by: store.sessionInfo.createdBy,
    created_by_name: store.sessionInfo.createdByName,
    created_at: store.sessionInfo.createdAt,
    member_count: store.sessionInfo.memberCount,
  } : null;

  // Convert shipmentData to presentation format
  const shipmentDataPresentation: ShipmentData | null = store.shipmentData ? {
    shipment_id: store.shipmentData.shipmentId,
    shipment_number: store.shipmentData.shipmentNumber,
    supplier_name: store.shipmentData.supplierName,
    status: store.shipmentData.status,
    shipped_date: store.shipmentData.shippedDate,
    items: store.shipmentData.items.map(item => ({
      item_id: item.itemId,
      product_id: item.productId,
      product_name: item.productName,
      sku: item.sku,
      quantity_shipped: item.quantityShipped,
      quantity_received: item.quantityReceived,
      quantity_accepted: item.quantityAccepted,
      quantity_rejected: item.quantityRejected,
      quantity_remaining: item.quantityRemaining,
      unit_cost: item.unitCost,
    })),
    receiving_summary: store.shipmentData.receivingSummary ? {
      total_shipped: store.shipmentData.receivingSummary.totalShipped,
      total_received: store.shipmentData.receivingSummary.totalReceived,
      total_accepted: store.shipmentData.receivingSummary.totalAccepted,
      total_rejected: store.shipmentData.receivingSummary.totalRejected,
      total_remaining: store.shipmentData.receivingSummary.totalRemaining,
      progress_percentage: store.shipmentData.receivingSummary.progressPercentage,
    } : undefined,
  } : null;

  // Convert comparison result for presentation
  const comparisonResultPresentation = store.comparisonResult ? {
    sessionA: {
      sessionId: store.comparisonResult.sessionA.sessionId,
      sessionName: store.comparisonResult.sessionA.sessionName,
      storeName: store.comparisonResult.sessionA.storeName,
      totalProducts: store.comparisonResult.sessionA.totalProducts,
      totalQuantity: store.comparisonResult.sessionA.totalQuantity,
    },
    sessionB: {
      sessionId: store.comparisonResult.sessionB.sessionId,
      sessionName: store.comparisonResult.sessionB.sessionName,
      storeName: store.comparisonResult.sessionB.storeName,
      totalProducts: store.comparisonResult.sessionB.totalProducts,
      totalQuantity: store.comparisonResult.sessionB.totalQuantity,
    },
    matched: store.comparisonResult.comparison.matched.map(item => ({
      productId: item.productId,
      sku: item.sku,
      productName: item.productName,
      quantityA: item.quantityA,
      quantityB: item.quantityB,
      quantityDiff: item.quantityDiff,
      isMatch: item.isMatch,
    })),
    onlyInA: store.comparisonResult.comparison.onlyInA.map(item => ({
      productId: item.productId,
      sku: item.sku,
      productName: item.productName,
      quantity: item.quantity,
    })),
    onlyInB: store.comparisonResult.comparison.onlyInB.map(item => ({
      productId: item.productId,
      sku: item.sku,
      productName: item.productName,
      quantity: item.quantity,
    })),
    summary: {
      totalMatched: store.comparisonResult.summary.totalMatched,
      quantitySameCount: store.comparisonResult.summary.quantitySameCount,
      quantityDiffCount: store.comparisonResult.summary.quantityDiffCount,
      onlyInACount: store.comparisonResult.summary.onlyInACount,
      onlyInBCount: store.comparisonResult.summary.onlyInBCount,
    },
  } : null;

  return {
    // Session state (presentation format for backward compatibility)
    sessionId,
    sessionInfo: sessionInfoPresentation,
    shipmentData: shipmentDataPresentation,
    items,
    loading: store.loading,
    error: store.error,
    currentUser,

    // Search state (presentation format)
    searchQuery: store.searchQuery,
    setSearchQuery: store.setSearchQuery,
    searchResults: searchResultsPresentation,
    isSearching: store.isSearching,
    currency: store.currency,
    searchInputRef,
    debouncedSearchQuery,

    // Received entries (presentation format)
    receivedEntries: receivedEntriesPresentation,

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

    // Session items for review (presentation format)
    sessionItems: sessionItemsPresentation,
    sessionItemsSummary: sessionItemsSummaryPresentation,
    editableItems: editableItemsPresentation,

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
