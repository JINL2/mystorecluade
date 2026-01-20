/**
 * useCountingSessionDetail Hook
 * Custom hook for counting session detail page
 * Uses inventory_get_session_items_v2 RPC (variant support)
 * Now includes product search and save functionality (same as receiving)
 */

import { useState, useEffect, useCallback, useRef } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { useAppState } from '@/app/providers/app_state_provider';
import { useDebounce } from '@/shared/hooks/useDebounce';
import { productReceiveRepository } from '../../data/repositories/ProductReceiveRepositoryImpl';

// Session info from session list
export interface CountingSessionInfo {
  sessionId: string;
  sessionName: string;
  storeName: string;
  storeId?: string;
  isActive: boolean;
  isFinal: boolean;
  createdBy?: string;
  createdByName: string;
  createdAt: string;
}

// Presentation format for session item
export interface CountingSessionItem {
  productId: string;
  productName: string;
  totalQuantity: number;
  totalRejected: number;
  scannedBy: {
    userId: string;
    userName: string;
    quantity: number;
    quantityRejected: number;
  }[];
}

// Summary
export interface CountingSessionSummary {
  totalProducts: number;
  totalQuantity: number;
  totalRejected: number;
}

// Product search result type (from get_inventory_page_v6 RPC)
export interface SearchProduct {
  // 제품 정보
  product_id: string;
  product_name: string;
  product_sku: string;
  product_barcode?: string;
  product_type: string;
  brand_id?: string;
  brand_name?: string;
  category_id?: string;
  category_name?: string;
  unit: string;
  image_urls?: string[];

  // 변형 정보
  variant_id?: string;
  variant_name?: string;
  variant_sku?: string;
  variant_barcode?: string;

  // 표시용
  display_name: string;
  display_sku: string;
  display_barcode?: string;

  // 재고
  stock: {
    quantity_on_hand: number;
    quantity_available: number;
    quantity_reserved: number;
  };

  // 가격
  price: {
    cost: number;
    selling: number;
    source: string;
  };

  // 상태
  status: {
    stock_level: 'normal' | 'low' | 'out_of_stock' | 'overstock';
    is_active: boolean;
  };

  // 메타
  has_variants: boolean;
  created_at: string;
}

// Received entry type
export interface ReceivedEntry {
  entry_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  variant_id?: string;
  quantity: number;
  created_at: string;
}

// Editable item for review modal
export interface EditableItem {
  product_id: string;
  variant_id: string | null;
  product_name: string;
  quantity: number;
  quantity_rejected: number;
}

// Active session for combine feature (from list page via localStorage)
export interface ActiveSession {
  sessionId: string;
  sessionName: string;
  sessionType: string;
  storeId: string;
  storeName: string;
  isActive: boolean;
  isFinal: boolean;
  memberCount: number;
  createdBy: string;
  createdByName: string;
  completedAt: string | null;
  createdAt: string;
}

// Comparison item (legacy - kept for backward compatibility)
export interface ComparisonItem {
  productId: string;
  productName: string;
  sku: string;
  currentSessionQuantity: number;
  selectedSessionQuantity: number;
  totalQuantity: number;
}

// New comparison types from inventory_compare_sessions_v2 RPC
export interface MatchedItem {
  productId: string;
  sku: string;
  productName: string;
  quantityA: number;
  quantityB: number;
  quantityDiff: number;
  isMatch: boolean;
}

export interface OnlyInSessionItem {
  productId: string;
  sku: string;
  productName: string;
  quantity: number;
}

export interface ComparisonSummary {
  totalMatched: number;
  quantitySameCount: number;
  quantityDiffCount: number;
  onlyInACount: number;
  onlyInBCount: number;
}

export interface SessionComparisonResult {
  sessionA: {
    sessionId: string;
    sessionName: string;
    storeName: string;
    totalProducts: number;
    totalQuantity: number;
  };
  sessionB: {
    sessionId: string;
    sessionName: string;
    storeName: string;
    totalProducts: number;
    totalQuantity: number;
  };
  matched: MatchedItem[];
  onlyInA: OnlyInSessionItem[];
  onlyInB: OnlyInSessionItem[];
  summary: ComparisonSummary;
}

export const useCountingSessionDetail = () => {
  const { sessionId } = useParams<{ sessionId: string }>();
  const navigate = useNavigate();
  const { currentCompany, currentUser } = useAppState();
  const userId = currentUser?.user_id;

  // State
  const [items, setItems] = useState<CountingSessionItem[]>([]);
  const [summary, setSummary] = useState<CountingSessionSummary>({
    totalProducts: 0,
    totalQuantity: 0,
    totalRejected: 0,
  });
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  // Session info from localStorage (passed from list page)
  const [sessionInfo, setSessionInfo] = useState<CountingSessionInfo | null>(null);

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
  const [showSubmitModeModal, setShowSubmitModeModal] = useState(false); // New: mode selection modal
  const [showSubmitConfirmModal, setShowSubmitConfirmModal] = useState(false);
  const [showSubmitReviewModal, setShowSubmitReviewModal] = useState(false);
  const [showFinalChoiceModal, setShowFinalChoiceModal] = useState(false);
  const [isLoadingSessionItems, setIsLoadingSessionItems] = useState(false);
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [submitError, setSubmitError] = useState<string | null>(null);
  const [submitSuccess, setSubmitSuccess] = useState(false);

  // Session items for review
  const [editableItems, setEditableItems] = useState<EditableItem[]>([]);

  // Combine session state
  const [showSessionSelectModal, setShowSessionSelectModal] = useState(false);
  const [availableSessions, setAvailableSessions] = useState<ActiveSession[]>([]);
  const [selectedCombineSession, setSelectedCombineSession] = useState<ActiveSession | null>(null);
  const [showComparisonModal, setShowComparisonModal] = useState(false);
  const [comparisonResult, setComparisonResult] = useState<SessionComparisonResult | null>(null);
  const [isLoadingComparison, setIsLoadingComparison] = useState(false);
  const [comparisonError, setComparisonError] = useState<string | null>(null);

  // Merge state
  const [isMerging, setIsMerging] = useState(false);
  const [mergeError, setMergeError] = useState<string | null>(null);
  const [mergeSuccess, setMergeSuccess] = useState(false);

  // Debounced search query
  const debouncedSearchQuery = useDebounce(searchQuery, 300);

  // Load session info from localStorage
  useEffect(() => {
    if (sessionId) {
      const storedInfo = localStorage.getItem(`counting_session_${sessionId}`);
      if (storedInfo) {
        try {
          setSessionInfo(JSON.parse(storedInfo));
        } catch {
          console.error('Failed to parse session info from localStorage');
        }
      }

      // Load available sessions for combine feature
      const storedSessions = localStorage.getItem('counting_active_sessions');
      if (storedSessions) {
        try {
          const sessions: ActiveSession[] = JSON.parse(storedSessions);
          // Filter out current session just in case
          setAvailableSessions(sessions.filter(s => s.sessionId !== sessionId));
        } catch {
          console.error('Failed to parse active sessions from localStorage');
        }
      }
    }
  }, [sessionId]);

  // Load session items
  const loadSessionItems = useCallback(async () => {
    if (!sessionId || !userId) return;

    setLoading(true);
    setError(null);

    try {
      // Use repository instead of direct dataSource call
      const result = await productReceiveRepository.getSessionItems(sessionId, userId);

      // Map domain entity to presentation format
      const mappedItems: CountingSessionItem[] = result.items.map((item) => ({
        productId: item.productId,
        productName: item.productName,
        totalQuantity: item.totalQuantity,
        totalRejected: item.totalRejected,
        scannedBy: item.scannedBy.map((user) => ({
          userId: user.userId,
          userName: user.userName,
          quantity: user.quantity,
          quantityRejected: user.quantityRejected,
        })),
      }));

      setItems(mappedItems);
      setSummary({
        totalProducts: result.summary.totalProducts,
        totalQuantity: result.summary.totalQuantity,
        totalRejected: result.summary.totalRejected,
      });
    } catch (err) {
      console.error('Load session items error:', err);
      setError(err instanceof Error ? err.message : 'Failed to load session items');
    } finally {
      setLoading(false);
    }
  }, [sessionId, userId]);

  // Load on mount
  useEffect(() => {
    loadSessionItems();
  }, [loadSessionItems]);

  // Navigate back to sessions page
  const handleBack = useCallback(() => {
    // Clear stored session info
    if (sessionId) {
      localStorage.removeItem(`counting_session_${sessionId}`);
    }
    navigate('/product/session');
  }, [navigate, sessionId]);

  // Refresh items
  const refreshItems = useCallback(() => {
    loadSessionItems();
  }, [loadSessionItems]);

  // ============ SEARCH FUNCTIONALITY ============

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
        p.display_sku.toLowerCase().includes(query) ||
        p.display_name.toLowerCase().includes(query) ||
        (p.display_barcode && p.display_barcode.toLowerCase().includes(query))
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
      if (!query || !currentCompany?.company_id || !sessionInfo?.storeId) {
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
          sessionInfo.storeId,
          query,
          1,
          10
        );

        // Map domain entities to presentation format (snake_case for compatibility)
        const products: SearchProduct[] = result.products.map(p => ({
          // 제품 정보
          product_id: p.productId,
          product_name: p.productName,
          product_sku: p.productSku,
          product_barcode: p.productBarcode,
          product_type: p.productType,
          brand_id: p.brandId,
          brand_name: p.brandName,
          category_id: p.categoryId,
          category_name: p.categoryName,
          unit: p.unit,
          image_urls: p.imageUrls,

          // 변형 정보
          variant_id: p.variantId,
          variant_name: p.variantName,
          variant_sku: p.variantSku,
          variant_barcode: p.variantBarcode,

          // 표시용
          display_name: p.displayName,
          display_sku: p.displaySku,
          display_barcode: p.displayBarcode,

          // 재고
          stock: {
            quantity_on_hand: p.stock.quantityOnHand,
            quantity_available: p.stock.quantityAvailable,
            quantity_reserved: p.stock.quantityReserved,
          },

          // 가격
          price: {
            cost: p.price.cost,
            selling: p.price.selling,
            source: p.price.source,
          },

          // 상태
          status: {
            stock_level: p.status.stockLevel,
            is_active: p.status.isActive,
          },

          // 메타
          has_variants: p.hasVariants,
          created_at: p.createdAt,
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
  }, [debouncedSearchQuery, currentCompany?.company_id, sessionInfo?.storeId]);

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
        product_name: product.display_name,
        sku: product.display_sku,
        variant_id: product.variant_id,
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

  // ============ SAVE FUNCTIONALITY ============

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
        variantId: entry.variant_id || null,
        quantity: entry.quantity,
        quantityRejected: 0,
      }));

      await productReceiveRepository.addSessionItems(
        sessionId,
        currentUser.user_id,
        itemsToSave
      );

      setSaveSuccess(true);
      setReceivedEntries([]);

      // Refresh items list to show updated data
      loadSessionItems();

      setTimeout(() => setSaveSuccess(false), 3000);
    } catch (err) {
      console.error('💾 Save error:', err);
      setSaveError(err instanceof Error ? err.message : 'Failed to save items');
    } finally {
      setIsSaving(false);
    }
  }, [receivedEntries, sessionId, currentUser?.user_id, loadSessionItems]);

  // ============ SUBMIT FUNCTIONALITY ============

  // Handle submit button click - show mode selection modal first
  const handleSubmitClick = useCallback(() => {
    if (!sessionId || !currentUser?.user_id) {
      setSaveError('Session or user information missing');
      return;
    }
    setShowSubmitModeModal(true);
  }, [sessionId, currentUser?.user_id]);

  // Handle submit mode selection
  const handleSubmitModeSelect = useCallback((mode: string) => {
    setShowSubmitModeModal(false);

    if (mode === 'combine_session') {
      // Show session selection modal
      if (availableSessions.length === 0) {
        setComparisonError('No other active sessions available to combine');
        return;
      }
      setShowSessionSelectModal(true);
      return;
    }

    if (mode === 'only_this_session') {
      // Proceed with current session submit flow
      setShowSubmitConfirmModal(true);
    }
  }, [availableSessions.length]);

  // Close submit mode modal
  const handleSubmitModeClose = useCallback(() => {
    setShowSubmitModeModal(false);
  }, []);

  // Handle initial confirmation - load session items
  const handleSubmitConfirm = useCallback(async () => {
    setShowSubmitConfirmModal(false);

    if (!sessionId || !currentUser?.user_id) {
      setSubmitError('Session or user information missing');
      return;
    }

    setIsLoadingSessionItems(true);
    setSubmitError(null);

    try {
      const result = await productReceiveRepository.getSessionItems(
        sessionId,
        currentUser.user_id
      );

      setEditableItems(result.items.map(item => ({
        product_id: item.productId,
        variant_id: item.variantId ?? null,
        product_name: item.productName,
        quantity: item.totalQuantity,
        quantity_rejected: item.totalRejected,
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
    setEditableItems([]);
  }, []);

  const handleFinalChoiceClose = useCallback(() => {
    setShowFinalChoiceModal(false);
  }, []);

  // ============ COMBINE SESSION FUNCTIONALITY ============

  // Close session select modal
  const handleSessionSelectClose = useCallback(() => {
    setShowSessionSelectModal(false);
    setSelectedCombineSession(null);
  }, []);

  // Handle session selection for combine
  const handleCombineSessionSelect = useCallback(async (selectedSession: ActiveSession) => {
    if (!sessionId || !currentUser?.user_id) {
      setComparisonError('Session or user information missing');
      return;
    }

    setSelectedCombineSession(selectedSession);
    setShowSessionSelectModal(false);
    setIsLoadingComparison(true);
    setComparisonError(null);

    try {
      // Use repository instead of direct dataSource call
      const result = await productReceiveRepository.compareSessions({
        sessionIdA: sessionId,
        sessionIdB: selectedSession.sessionId,
        userId: currentUser.user_id,
      });

      // Map domain entity to presentation format
      const comparisonData: SessionComparisonResult = {
        sessionA: {
          sessionId: result.sessionA.sessionId,
          sessionName: result.sessionA.sessionName,
          storeName: result.sessionA.storeName,
          totalProducts: result.sessionA.totalProducts,
          totalQuantity: result.sessionA.totalQuantity,
        },
        sessionB: {
          sessionId: result.sessionB.sessionId,
          sessionName: result.sessionB.sessionName,
          storeName: result.sessionB.storeName,
          totalProducts: result.sessionB.totalProducts,
          totalQuantity: result.sessionB.totalQuantity,
        },
        matched: result.comparison.matched.map((item) => ({
          productId: item.productId,
          sku: item.sku,
          productName: item.productName,
          quantityA: item.quantityA,
          quantityB: item.quantityB,
          quantityDiff: item.quantityDiff,
          isMatch: item.isMatch,
        })),
        onlyInA: result.comparison.onlyInA.map((item) => ({
          productId: item.productId,
          sku: item.sku,
          productName: item.productName,
          quantity: item.quantity,
        })),
        onlyInB: result.comparison.onlyInB.map((item) => ({
          productId: item.productId,
          sku: item.sku,
          productName: item.productName,
          quantity: item.quantity,
        })),
        summary: {
          totalMatched: result.summary.totalMatched,
          quantitySameCount: result.summary.quantitySameCount,
          quantityDiffCount: result.summary.quantityDiffCount,
          onlyInACount: result.summary.onlyInACount,
          onlyInBCount: result.summary.onlyInBCount,
        },
      };

      setComparisonResult(comparisonData);
      setShowComparisonModal(true);
    } catch (err) {
      console.error('Comparison error:', err);
      setComparisonError(err instanceof Error ? err.message : 'Failed to compare sessions');
    } finally {
      setIsLoadingComparison(false);
    }
  }, [sessionId, currentUser?.user_id]);

  // Close comparison modal
  const handleComparisonClose = useCallback(() => {
    setShowComparisonModal(false);
    setComparisonResult(null);
    setSelectedCombineSession(null);
    setMergeError(null);
  }, []);

  // Handle merge sessions
  const handleMergeSessions = useCallback(async () => {
    if (!sessionId || !currentUser?.user_id || !selectedCombineSession) {
      setMergeError('Session or user information missing');
      return;
    }

    setIsMerging(true);
    setMergeError(null);

    try {
      // Use repository instead of direct dataSource call
      await productReceiveRepository.mergeSessions({
        targetSessionId: sessionId,
        sourceSessionId: selectedCombineSession.sessionId,
        userId: currentUser.user_id,
      });

      // Remove merged session from localStorage
      const storedSessions = localStorage.getItem('counting_active_sessions');
      if (storedSessions) {
        try {
          const sessions: ActiveSession[] = JSON.parse(storedSessions);
          const updatedSessions = sessions.filter(s => s.sessionId !== selectedCombineSession.sessionId);
          localStorage.setItem('counting_active_sessions', JSON.stringify(updatedSessions));
          // Also update local state
          setAvailableSessions(updatedSessions.filter(s => s.sessionId !== sessionId));
        } catch {
          console.error('Failed to update active sessions in localStorage');
        }
      }

      setMergeSuccess(true);
      setShowComparisonModal(false);
      setComparisonResult(null);
      setSelectedCombineSession(null);

      // Refresh session items to show merged data
      loadSessionItems();

      // Reset success message after 3 seconds
      setTimeout(() => setMergeSuccess(false), 3000);
    } catch (err) {
      console.error('Merge error:', err);
      setMergeError(err instanceof Error ? err.message : 'Failed to merge sessions');
    } finally {
      setIsMerging(false);
    }
  }, [sessionId, currentUser?.user_id, selectedCombineSession, loadSessionItems]);

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
        variantId: item.variant_id,
        quantity: item.quantity,
        quantityRejected: item.quantity_rejected,
      }));

      const result = await productReceiveRepository.submitSession(
        sessionId,
        currentUser.user_id,
        itemsToSubmit,
        isFinal
      );

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

  // Calculate totals for review
  const editableTotalQuantity = editableItems.reduce((sum, item) => sum + item.quantity, 0);
  const editableTotalRejected = editableItems.reduce((sum, item) => sum + item.quantity_rejected, 0);

  return {
    // State
    sessionId,
    sessionInfo,
    items,
    summary,
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
    showSubmitModeModal,
    showSubmitConfirmModal,
    showSubmitReviewModal,
    showFinalChoiceModal,
    isLoadingSessionItems,
    isSubmitting,
    submitError,
    submitSuccess,

    // Session items for review
    editableItems,

    // Combine session state
    showSessionSelectModal,
    availableSessions,
    selectedCombineSession,
    showComparisonModal,
    comparisonResult,
    isLoadingComparison,
    comparisonError,

    // Merge state
    isMerging,
    mergeError,
    mergeSuccess,

    // Calculated totals
    editableTotalQuantity,
    editableTotalRejected,

    // Actions
    handleBack,
    refreshItems,
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
  };
};
