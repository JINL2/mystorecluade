/**
 * useReceivingSession Hook
 * Custom hook for receiving session business logic
 * Handles session data loading, product search, save, and submit operations
 */

import { useState, useEffect, useCallback, useRef } from 'react';
import { useParams, useNavigate, useLocation } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { useDebounce } from '@/shared/hooks/useDebounce';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';
import type {
  SessionInfo,
  ReceivingItem,
  ReceivingSessionLocationState,
  ShipmentData,
} from '../pages/ReceivingSessionPage/ReceivingSessionPage.types';

// Product search result type (from get_inventory_page_v3 RPC)
export interface SearchProduct {
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

// Received entry type
export interface ReceivedEntry {
  entry_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  quantity: number;
  created_at: string;
}

// Session item types from RPC
export interface SessionItemUser {
  user_id: string;
  user_name: string;
  quantity: number;
  quantity_rejected: number;
}

export interface SessionItem {
  product_id: string;
  product_name: string;
  total_quantity: number;
  total_rejected: number;
  scanned_by: SessionItemUser[];
}

export interface SessionItemsSummary {
  total_products: number;
  total_quantity: number;
  total_rejected: number;
}

// Editable item for review modal
export interface EditableItem {
  product_id: string;
  product_name: string;
  quantity: number;
  quantity_rejected: number;
}

export const useReceivingSession = () => {
  const { sessionId } = useParams<{ sessionId: string }>();
  const navigate = useNavigate();
  const location = useLocation();
  const { currentCompany, currentUser } = useAppState();

  // Get state from navigation
  const locationState = location.state as ReceivingSessionLocationState | null;

  // Session state
  const [sessionInfo, setSessionInfo] = useState<SessionInfo | null>(null);
  const [shipmentData, setShipmentData] = useState<ShipmentData | null>(null);
  const [items, setItems] = useState<ReceivingItem[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Search state
  const [searchQuery, setSearchQuery] = useState('');
  const [searchResults, setSearchResults] = useState<SearchProduct[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [currency, setCurrency] = useState<{ symbol: string; code: string }>({ symbol: '₫', code: 'VND' });
  const searchInputRef = useRef<HTMLInputElement>(null);
  const searchCacheRef = useRef<Map<string, SearchProduct[]>>(new Map());

  // Received entries state
  const [receivedEntries, setReceivedEntries] = useState<ReceivedEntry[]>([]);

  // Save state
  const [isSaving, setIsSaving] = useState(false);
  const [saveError, setSaveError] = useState<string | null>(null);
  const [saveSuccess, setSaveSuccess] = useState(false);

  // Submit state
  const [showSubmitConfirmModal, setShowSubmitConfirmModal] = useState(false);
  const [showSubmitReviewModal, setShowSubmitReviewModal] = useState(false);
  const [showFinalChoiceModal, setShowFinalChoiceModal] = useState(false);
  const [isLoadingSessionItems, setIsLoadingSessionItems] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [submitSuccess, setSubmitSuccess] = useState(false);

  // Session items for review
  const [sessionItems, setSessionItems] = useState<SessionItem[]>([]);
  const [sessionItemsSummary, setSessionItemsSummary] = useState<SessionItemsSummary | null>(null);
  const [editableItems, setEditableItems] = useState<EditableItem[]>([]);

  // Debounced search query
  const debouncedSearchQuery = useDebounce(searchQuery, 300);

  // Load session data
  useEffect(() => {
    const loadSessionData = async () => {
      if (!sessionId || !currentCompany) return;

      setLoading(true);
      setError(null);

      try {
        console.log('📦 Loading session:', sessionId);
        console.log('📦 Location state:', locationState);

        // If we have data from navigation state, use it
        if (locationState?.sessionData) {
          const sessionData = locationState.sessionData;
          setSessionInfo({
            session_id: sessionData.session_id || sessionId,
            session_type: sessionData.session_type || 'receiving',
            store_id: sessionData.store_id || '',
            store_name: sessionData.store_name || '',
            shipment_id: locationState.shipmentId || sessionData.shipment_id || null,
            shipment_number: locationState.shipmentData?.shipment_number || sessionData.shipment_number || null,
            is_active: sessionData.is_active ?? true,
            is_final: sessionData.is_final ?? false,
            created_by: sessionData.created_by || '',
            created_by_name: sessionData.created_by_name || '',
            created_at: sessionData.created_at || new Date().toISOString(),
            member_count: sessionData.member_count,
          });
        }

        // If we have shipment data from navigation state, use it
        if (locationState?.shipmentData) {
          setShipmentData(locationState.shipmentData);

          // Convert shipment items to receiving items
          if (locationState.shipmentData.items) {
            const receivingItems: ReceivingItem[] = locationState.shipmentData.items.map(item => ({
              item_id: item.item_id,
              product_id: item.product_id,
              product_name: item.product_name,
              sku: item.sku,
              quantity_shipped: item.quantity_shipped,
              quantity_received: item.quantity_received,
              quantity_accepted: item.quantity_accepted,
              quantity_rejected: item.quantity_rejected,
              quantity_remaining: item.quantity_remaining,
              unit_cost: item.unit_cost,
            }));
            setItems(receivingItems);
          }
        }

        // If no navigation state, we need to fetch from API
        if (!locationState?.sessionData || !locationState?.shipmentData) {
          if (!locationState?.sessionData) {
            setSessionInfo({
              session_id: sessionId,
              session_type: 'receiving',
              store_id: '',
              store_name: 'Loading...',
              shipment_id: null,
              shipment_number: null,
              is_active: true,
              is_final: false,
              created_by: '',
              created_by_name: '',
              created_at: new Date().toISOString(),
            });
          }
        }

      } catch (err) {
        console.error('📦 Load session error:', err);
        setError(err instanceof Error ? err.message : 'Failed to load session');
      } finally {
        setLoading(false);
      }
    };

    loadSessionData();
  }, [sessionId, currentCompany, locationState]);

  // Handle back navigation
  const handleBack = useCallback(() => {
    navigate('/product/session');
  }, [navigate]);

  // Instant search from cache when typing
  useEffect(() => {
    const query = searchQuery.trim().toLowerCase();
    if (!query) {
      setSearchResults([]);
      return;
    }

    // Check cache for matching results
    const cachedResults = searchCacheRef.current.get(query);
    if (cachedResults) {
      setSearchResults(cachedResults);
      return;
    }

    // Check if any cached query starts with or is contained in current query
    for (const [, cachedProducts] of searchCacheRef.current.entries()) {
      const matchingProducts = cachedProducts.filter(p =>
        p.sku.toLowerCase().includes(query) ||
        p.product_name.toLowerCase().includes(query) ||
        (p.barcode && p.barcode.toLowerCase().includes(query))
      );
      if (matchingProducts.length > 0) {
        setSearchResults(matchingProducts);
        return;
      }
    }
  }, [searchQuery]);

  // Search products using Repository (debounced)
  useEffect(() => {
    const searchProducts = async () => {
      const query = debouncedSearchQuery.trim();
      if (!query || !currentCompany?.company_id || !sessionInfo?.store_id) {
        return;
      }

      // Skip if we have exact cache hit
      const queryLower = query.toLowerCase();
      if (searchCacheRef.current.has(queryLower)) {
        return;
      }

      setIsSearching(true);
      try {
        const result = await productReceiveRepository.searchProducts(
          currentCompany.company_id,
          sessionInfo.store_id,
          query,
          1,
          10
        );

        console.log('🔍 Search result:', result);

        // Map domain entities to presentation format (snake_case for compatibility)
        const products: SearchProduct[] = result.products.map(p => ({
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
        }));

        setSearchResults(products);

        // Cache the results
        searchCacheRef.current.set(queryLower, products);

        // Keep cache size manageable (max 50 queries)
        if (searchCacheRef.current.size > 50) {
          const firstKey = searchCacheRef.current.keys().next().value;
          if (firstKey) searchCacheRef.current.delete(firstKey);
        }

        setCurrency({
          symbol: result.currency.symbol || '₫',
          code: result.currency.code || 'VND',
        });
      } catch (err) {
        console.error('Search error:', err);
        setSearchResults([]);
      } finally {
        setIsSearching(false);
      }
    };

    searchProducts();
  }, [debouncedSearchQuery, currentCompany?.company_id, sessionInfo?.store_id]);

  // Add product to received entries
  const addProductToReceived = useCallback((product: SearchProduct) => {
    const existingIndex = receivedEntries.findIndex(entry => entry.product_id === product.product_id);

    if (existingIndex >= 0) {
      setReceivedEntries(prev => prev.map((entry, index) =>
        index === existingIndex
          ? { ...entry, quantity: entry.quantity + 1 }
          : entry
      ));
    } else {
      const newEntry: ReceivedEntry = {
        entry_id: `temp-${Date.now()}`,
        product_id: product.product_id,
        product_name: product.product_name,
        sku: product.sku,
        quantity: 1,
        created_at: new Date().toISOString(),
      };
      setReceivedEntries(prev => [newEntry, ...prev]);
    }

    setSearchResults([]);
    setSearchQuery('');
    searchInputRef.current?.focus();
  }, [receivedEntries]);

  // Handle product selection
  const handleSelectProduct = useCallback((product: SearchProduct) => {
    addProductToReceived(product);
  }, [addProductToReceived]);

  // Handle Enter key in search
  const handleSearchKeyDown = useCallback((e: React.KeyboardEvent<HTMLInputElement>) => {
    if (e.key === 'Enter' && searchResults.length > 0) {
      e.preventDefault();
      addProductToReceived(searchResults[0]);
    }
  }, [searchResults, addProductToReceived]);

  // Update entry quantity
  const updateEntryQuantity = useCallback((entryId: string, delta: number) => {
    setReceivedEntries(prev => prev.map(e =>
      e.entry_id === entryId
        ? { ...e, quantity: Math.max(1, e.quantity + delta) }
        : e
    ));
  }, []);

  // Set entry quantity directly
  const setEntryQuantity = useCallback((entryId: string, quantity: number) => {
    setReceivedEntries(prev => prev.map(e =>
      e.entry_id === entryId
        ? { ...e, quantity: Math.max(1, quantity) }
        : e
    ));
  }, []);

  // Remove entry
  const removeEntry = useCallback((entryId: string) => {
    setReceivedEntries(prev => prev.filter(e => e.entry_id !== entryId));
  }, []);

  // Clear search
  const clearSearch = useCallback(() => {
    setSearchQuery('');
    setSearchResults([]);
  }, []);

  // Handle save - using Repository
  const handleSave = useCallback(async () => {
    if (receivedEntries.length === 0) {
      setSaveError('No items to save');
      return;
    }

    if (!sessionId || !currentUser?.user_id) {
      setSaveError('Session or user information missing');
      return;
    }

    setIsSaving(true);
    setSaveError(null);
    setSaveSuccess(false);

    try {
      const itemsToSave = receivedEntries.map(entry => ({
        productId: entry.product_id,
        quantity: entry.quantity,
        quantityRejected: 0,
      }));

      console.log('💾 Saving items:', { sessionId, userId: currentUser.user_id, items: itemsToSave });

      await productReceiveRepository.addSessionItems(
        sessionId,
        currentUser.user_id,
        itemsToSave
      );

      console.log('💾 Save successful');

      setSaveSuccess(true);
      setReceivedEntries([]);
      setTimeout(() => setSaveSuccess(false), 3000);
    } catch (err) {
      console.error('💾 Save error:', err);
      setSaveError(err instanceof Error ? err.message : 'Failed to save items');
    } finally {
      setIsSaving(false);
    }
  }, [receivedEntries, sessionId, currentUser?.user_id]);

  // Handle submit button click
  const handleSubmitClick = useCallback(() => {
    if (!sessionId || !currentUser?.user_id) {
      setSaveError('Session or user information missing');
      return;
    }
    setShowSubmitConfirmModal(true);
  }, [sessionId, currentUser?.user_id]);

  // Handle initial confirmation - load session items using Repository
  const handleSubmitConfirm = useCallback(async () => {
    setShowSubmitConfirmModal(false);

    if (!sessionId || !currentUser?.user_id) {
      setSubmitError('Session or user information missing');
      return;
    }

    setIsLoadingSessionItems(true);
    setSubmitError(null);

    try {
      console.log('📤 Loading session items:', { sessionId, userId: currentUser.user_id });

      const result = await productReceiveRepository.getSessionItems(
        sessionId,
        currentUser.user_id
      );

      console.log('📤 Session items result:', result);

      // Map domain entities to presentation format (snake_case for compatibility)
      const itemsData: SessionItem[] = result.items.map(item => ({
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
      }));

      const summaryData: SessionItemsSummary = {
        total_products: result.summary.totalProducts,
        total_quantity: result.summary.totalQuantity,
        total_rejected: result.summary.totalRejected,
      };

      setSessionItems(itemsData);
      setSessionItemsSummary(summaryData);

      setEditableItems(itemsData.map((item: SessionItem) => ({
        product_id: item.product_id,
        product_name: item.product_name,
        quantity: item.total_quantity,
        quantity_rejected: item.total_rejected,
      })));

      setShowSubmitReviewModal(true);
    } catch (err) {
      console.error('📤 Load session items error:', err);
      setSubmitError(err instanceof Error ? err.message : 'Failed to load session items');
    } finally {
      setIsLoadingSessionItems(false);
    }
  }, [sessionId, currentUser?.user_id]);

  // Close modals
  const handleSubmitConfirmClose = useCallback(() => {
    setShowSubmitConfirmModal(false);
  }, []);

  const handleSubmitReviewClose = useCallback(() => {
    setShowSubmitReviewModal(false);
    setSessionItems([]);
    setSessionItemsSummary(null);
    setEditableItems([]);
  }, []);

  const handleFinalChoiceClose = useCallback(() => {
    setShowFinalChoiceModal(false);
  }, []);

  // Handle quantity change in review modal
  const handleReviewQuantityChange = useCallback((productId: string, field: 'quantity' | 'quantity_rejected', value: number) => {
    setEditableItems(prev => prev.map(item =>
      item.product_id === productId
        ? { ...item, [field]: Math.max(0, value) }
        : item
    ));
  }, []);

  // Handle final submit button click
  const handleFinalSubmit = useCallback(() => {
    setShowSubmitReviewModal(false);
    setShowFinalChoiceModal(true);
  }, []);

  // Handle final submission using Repository
  const handleSubmitSession = useCallback(async (isFinal: boolean) => {
    if (!sessionId || !currentUser?.user_id) {
      setSubmitError('Session or user information missing');
      return;
    }

    if (editableItems.length === 0) {
      setSubmitError('No items to submit');
      return;
    }

    // Close modal first and show fullscreen loading
    setShowFinalChoiceModal(false);
    setIsSubmitting(true);
    setSubmitError(null);

    try {
      const itemsToSubmit = editableItems.map(item => ({
        productId: item.product_id,
        quantity: item.quantity,
        quantityRejected: item.quantity_rejected,
      }));

      console.log('📤 Submitting session:', {
        sessionId,
        userId: currentUser.user_id,
        isFinal,
        items: itemsToSubmit,
      });

      const result = await productReceiveRepository.submitSession(
        sessionId,
        currentUser.user_id,
        itemsToSubmit,
        isFinal
      );

      console.log('📤 Submit session result:', result);

      setSubmitSuccess(true);

      // Navigate immediately to session page with refresh state
      navigate('/product/session', {
        state: {
          submitSuccess: true,
          receivingNumber: result.receivingNumber,
          itemsCount: result.itemsCount,
          totalQuantity: result.totalQuantity,
          refreshData: true,
        }
      });
    } catch (err) {
      console.error('📤 Submit session error:', err);
      setSubmitError(err instanceof Error ? err.message : 'Failed to submit session');
      // Reopen modal to show error
      setShowFinalChoiceModal(true);
    } finally {
      setIsSubmitting(false);
    }
  }, [sessionId, currentUser?.user_id, editableItems, navigate]);

  // Dismiss errors
  const dismissSaveError = useCallback(() => {
    setSaveError(null);
  }, []);

  // Calculate totals
  const editableTotalQuantity = editableItems.reduce((sum, item) => sum + item.quantity, 0);
  const editableTotalRejected = editableItems.reduce((sum, item) => sum + item.quantity_rejected, 0);

  const receivingSummary = shipmentData?.receiving_summary;
  const totalShipped = receivingSummary?.total_shipped ?? items.reduce((sum, item) => sum + item.quantity_shipped, 0);
  const totalReceived = receivingSummary?.total_received ?? items.reduce((sum, item) => sum + item.quantity_received, 0);
  const totalAccepted = receivingSummary?.total_accepted ?? items.reduce((sum, item) => sum + item.quantity_accepted, 0);
  const totalRejected = receivingSummary?.total_rejected ?? items.reduce((sum, item) => sum + item.quantity_rejected, 0);
  const totalRemaining = receivingSummary?.total_remaining ?? items.reduce((sum, item) => sum + item.quantity_remaining, 0);
  const progressPercentage = receivingSummary?.progress_percentage ?? (totalShipped > 0 ? (totalReceived / totalShipped) * 100 : 0);

  return {
    // Session state
    sessionId,
    sessionInfo,
    shipmentData,
    items,
    loading,
    error,
    currentUser,

    // Search state
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    currency,
    searchInputRef,
    debouncedSearchQuery,

    // Received entries
    receivedEntries,

    // Save state
    isSaving,
    saveError,
    saveSuccess,

    // Submit state
    showSubmitConfirmModal,
    showSubmitReviewModal,
    showFinalChoiceModal,
    isLoadingSessionItems,
    isSubmitting,
    submitError,
    submitSuccess,

    // Session items for review
    sessionItems,
    sessionItemsSummary,
    editableItems,

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
    handleSubmitConfirm,
    handleSubmitConfirmClose,
    handleSubmitReviewClose,
    handleFinalChoiceClose,
    handleReviewQuantityChange,
    handleFinalSubmit,
    handleSubmitSession,
    dismissSaveError,
  };
};
