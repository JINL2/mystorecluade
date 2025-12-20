/**
 * Receiving Session Provider
 * Zustand store for receiving session state management
 */

import { create } from 'zustand';
import { devtools } from 'zustand/middleware';
import type {
  ReceivingSessionStore,
  ReceivingSessionState,
  ReceivedEntry,
  EditableItem,
  ActiveSession,
  SessionInfo,
  ShipmentData,
  NeedsDisplayItem,
  SubmitResultData,
} from './states/receiving_session_state';
import type {
  SessionItem,
  SessionItemsSummary,
  SearchProduct,
  Currency,
  CompareSessionsResult,
} from '../../domain/entities';

// Initial state
const initialState: ReceivingSessionState = {
  // Session state
  sessionInfo: null,
  shipmentData: null,
  loading: true,
  error: null,

  // Search state
  searchQuery: '',
  searchResults: [],
  isSearching: false,
  currency: { symbol: '₫', code: 'VND' },

  // Received entries
  receivedEntries: [],

  // Save state
  isSaving: false,
  saveError: null,
  saveSuccess: false,

  // Submit state
  showSubmitModeModal: false,
  showSubmitConfirmModal: false,
  showSubmitReviewModal: false,
  showFinalChoiceModal: false,
  isLoadingSessionItems: false,
  isSubmitting: false,
  submitError: null,
  submitSuccess: false,

  // Session items for review
  sessionItems: [],
  sessionItemsSummary: null,
  editableItems: [],

  // Combine session state
  availableSessions: [],
  showSessionSelectModal: false,
  selectedCombineSession: null,
  showComparisonModal: false,
  comparisonResult: null,
  isLoadingComparison: false,
  comparisonError: null,

  // Merge state
  isMerging: false,
  mergeError: null,
  mergeSuccess: false,

  // Needs display modal state
  showNeedsDisplayModal: false,
  needsDisplayItems: [],
  submitResultData: null,
};

export const useReceivingSessionStore = create<ReceivingSessionStore>()(
  devtools(
    (set) => ({
      ...initialState,

      // Session actions
      setSessionInfo: (info: SessionInfo | null) => set({ sessionInfo: info }),
      setShipmentData: (data: ShipmentData | null) => set({ shipmentData: data }),
      setLoading: (loading: boolean) => set({ loading }),
      setError: (error: string | null) => set({ error }),

      // Search actions
      setSearchQuery: (query: string) => set({ searchQuery: query }),
      setSearchResults: (results: SearchProduct[]) => set({ searchResults: results }),
      setIsSearching: (isSearching: boolean) => set({ isSearching }),
      setCurrency: (currency: Currency) => set({ currency }),
      clearSearch: () => set({ searchQuery: '', searchResults: [] }),

      // Received entries actions
      addReceivedEntry: (entry: ReceivedEntry) =>
        set((state) => {
          const existingIndex = state.receivedEntries.findIndex(
            (e) => e.productId === entry.productId
          );
          if (existingIndex >= 0) {
            const updatedEntries = [...state.receivedEntries];
            updatedEntries[existingIndex] = {
              ...updatedEntries[existingIndex],
              quantity: updatedEntries[existingIndex].quantity + entry.quantity,
            };
            return { receivedEntries: updatedEntries };
          }
          return { receivedEntries: [entry, ...state.receivedEntries] };
        }),

      updateEntryQuantity: (entryId: string, quantity: number) =>
        set((state) => ({
          receivedEntries: state.receivedEntries.map((e) =>
            e.entryId === entryId ? { ...e, quantity: Math.max(1, quantity) } : e
          ),
        })),

      removeEntry: (entryId: string) =>
        set((state) => ({
          receivedEntries: state.receivedEntries.filter((e) => e.entryId !== entryId),
        })),

      clearReceivedEntries: () => set({ receivedEntries: [] }),

      // Save actions
      setIsSaving: (isSaving: boolean) => set({ isSaving }),
      setSaveError: (error: string | null) => set({ saveError: error }),
      setSaveSuccess: (success: boolean) => set({ saveSuccess: success }),

      // Submit modal actions
      setShowSubmitModeModal: (show: boolean) => set({ showSubmitModeModal: show }),
      setShowSubmitConfirmModal: (show: boolean) => set({ showSubmitConfirmModal: show }),
      setShowSubmitReviewModal: (show: boolean) => set({ showSubmitReviewModal: show }),
      setShowFinalChoiceModal: (show: boolean) => set({ showFinalChoiceModal: show }),
      setIsLoadingSessionItems: (loading: boolean) => set({ isLoadingSessionItems: loading }),
      setIsSubmitting: (submitting: boolean) => set({ isSubmitting: submitting }),
      setSubmitError: (error: string | null) => set({ submitError: error }),
      setSubmitSuccess: (success: boolean) => set({ submitSuccess: success }),

      // Session items actions
      setSessionItems: (items: SessionItem[]) => set({ sessionItems: items }),
      setSessionItemsSummary: (summary: SessionItemsSummary | null) =>
        set({ sessionItemsSummary: summary }),
      setEditableItems: (items: EditableItem[]) => set({ editableItems: items }),
      updateEditableItemQuantity: (
        productId: string,
        field: 'quantity' | 'quantityRejected',
        value: number
      ) =>
        set((state) => ({
          editableItems: state.editableItems.map((item) =>
            item.productId === productId
              ? { ...item, [field]: Math.max(0, value) }
              : item
          ),
        })),

      // Combine session actions
      setAvailableSessions: (sessions: ActiveSession[]) =>
        set({ availableSessions: sessions }),
      setShowSessionSelectModal: (show: boolean) => set({ showSessionSelectModal: show }),
      setSelectedCombineSession: (session: ActiveSession | null) =>
        set({ selectedCombineSession: session }),
      setShowComparisonModal: (show: boolean) => set({ showComparisonModal: show }),
      setComparisonResult: (result: CompareSessionsResult | null) =>
        set({ comparisonResult: result }),
      setIsLoadingComparison: (loading: boolean) => set({ isLoadingComparison: loading }),
      setComparisonError: (error: string | null) => set({ comparisonError: error }),

      // Merge actions
      setIsMerging: (merging: boolean) => set({ isMerging: merging }),
      setMergeError: (error: string | null) => set({ mergeError: error }),
      setMergeSuccess: (success: boolean) => set({ mergeSuccess: success }),

      // Needs display actions
      setShowNeedsDisplayModal: (show: boolean) => set({ showNeedsDisplayModal: show }),
      setNeedsDisplayItems: (items: NeedsDisplayItem[]) => set({ needsDisplayItems: items }),
      setSubmitResultData: (data: SubmitResultData | null) => set({ submitResultData: data }),

      // Reset actions
      reset: () => set(initialState),

      resetSubmitState: () =>
        set({
          showSubmitModeModal: false,
          showSubmitConfirmModal: false,
          showSubmitReviewModal: false,
          showFinalChoiceModal: false,
          isLoadingSessionItems: false,
          isSubmitting: false,
          submitError: null,
          submitSuccess: false,
          sessionItems: [],
          sessionItemsSummary: null,
          editableItems: [],
        }),

      resetCompareState: () =>
        set({
          showSessionSelectModal: false,
          selectedCombineSession: null,
          showComparisonModal: false,
          comparisonResult: null,
          isLoadingComparison: false,
          comparisonError: null,
          isMerging: false,
          mergeError: null,
        }),
    }),
    { name: 'receiving-session-store' }
  )
);

// Selector hooks for optimized re-renders
export const useSessionInfo = () => useReceivingSessionStore((state) => state.sessionInfo);
export const useShipmentData = () => useReceivingSessionStore((state) => state.shipmentData);
export const useSessionLoading = () => useReceivingSessionStore((state) => state.loading);
export const useSessionError = () => useReceivingSessionStore((state) => state.error);

export const useSearchState = () =>
  useReceivingSessionStore((state) => ({
    searchQuery: state.searchQuery,
    searchResults: state.searchResults,
    isSearching: state.isSearching,
    currency: state.currency,
  }));

export const useReceivedEntries = () =>
  useReceivingSessionStore((state) => state.receivedEntries);

export const useSaveState = () =>
  useReceivingSessionStore((state) => ({
    isSaving: state.isSaving,
    saveError: state.saveError,
    saveSuccess: state.saveSuccess,
  }));

export const useSubmitState = () =>
  useReceivingSessionStore((state) => ({
    showSubmitModeModal: state.showSubmitModeModal,
    showSubmitConfirmModal: state.showSubmitConfirmModal,
    showSubmitReviewModal: state.showSubmitReviewModal,
    showFinalChoiceModal: state.showFinalChoiceModal,
    isLoadingSessionItems: state.isLoadingSessionItems,
    isSubmitting: state.isSubmitting,
    submitError: state.submitError,
    submitSuccess: state.submitSuccess,
  }));

export const useSessionItems = () =>
  useReceivingSessionStore((state) => ({
    sessionItems: state.sessionItems,
    sessionItemsSummary: state.sessionItemsSummary,
    editableItems: state.editableItems,
  }));

export const useCombineState = () =>
  useReceivingSessionStore((state) => ({
    availableSessions: state.availableSessions,
    showSessionSelectModal: state.showSessionSelectModal,
    selectedCombineSession: state.selectedCombineSession,
    showComparisonModal: state.showComparisonModal,
    comparisonResult: state.comparisonResult,
    isLoadingComparison: state.isLoadingComparison,
    comparisonError: state.comparisonError,
  }));

export const useMergeState = () =>
  useReceivingSessionStore((state) => ({
    isMerging: state.isMerging,
    mergeError: state.mergeError,
    mergeSuccess: state.mergeSuccess,
  }));

export const useNeedsDisplayState = () =>
  useReceivingSessionStore((state) => ({
    showNeedsDisplayModal: state.showNeedsDisplayModal,
    needsDisplayItems: state.needsDisplayItems,
    submitResultData: state.submitResultData,
  }));
