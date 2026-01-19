/**
 * Receiving Session State
 * Zustand state types for receiving session management
 */

import type {
  SessionItem,
  SessionItemsSummary,
  SearchProduct,
  Currency,
  Session,
  CompareSessionsResult,
} from '../../../domain/entities';

// Received entry for local state
export interface ReceivedEntry {
  entryId: string;
  productId: string;
  productName: string;
  sku: string;
  variantId?: string;
  quantity: number;
  createdAt: string;
}

// Editable item for review modal
export interface EditableItem {
  productId: string;
  variantId: string | null;
  productName: string;
  quantity: number;
  quantityRejected: number;
}

// Active session for combine feature
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

// Session info type
export interface SessionInfo {
  sessionId: string;
  sessionType: string;
  storeId: string;
  storeName: string;
  shipmentId: string | null;
  shipmentNumber: string | null;
  isActive: boolean;
  isFinal: boolean;
  createdBy: string;
  createdByName: string;
  createdAt: string;
  memberCount?: number;
}

// Shipment data type
export interface ShipmentData {
  shipmentId: string;
  shipmentNumber: string;
  supplierName: string;
  status: string;
  shippedDate: string;
  items: ShipmentItemData[];
  receivingSummary?: ReceivingSummaryData;
}

export interface ShipmentItemData {
  itemId: string;
  productId: string;
  variantId?: string | null;
  productName: string;
  variantName?: string | null;
  displayName?: string;
  hasVariants?: boolean;
  sku: string;
  quantityShipped: number;
  quantityReceived: number;
  quantityAccepted: number;
  quantityRejected: number;
  quantityRemaining: number;
  unitCost: number;
}

export interface ReceivingSummaryData {
  totalShipped: number;
  totalReceived: number;
  totalAccepted: number;
  totalRejected: number;
  totalRemaining: number;
  progressPercentage: number;
}

// Needs display item
export interface NeedsDisplayItem {
  productId: string;
  variantId: string | null;
  sku: string;
  productName: string;
  variantName: string | null;
  displayName: string;
  quantityReceived: number;
}

// Submit result data
export interface SubmitResultData {
  receivingNumber?: string;
  itemsCount?: number;
  totalQuantity?: number;
}

// ============ Zustand State Interface ============

export interface ReceivingSessionState {
  // Session state
  sessionInfo: SessionInfo | null;
  shipmentData: ShipmentData | null;
  loading: boolean;
  error: string | null;

  // Search state
  searchQuery: string;
  searchResults: SearchProduct[];
  isSearching: boolean;
  currency: Currency;

  // Received entries
  receivedEntries: ReceivedEntry[];

  // Save state
  isSaving: boolean;
  saveError: string | null;
  saveSuccess: boolean;

  // Submit state
  showSubmitModeModal: boolean;
  showSubmitConfirmModal: boolean;
  showSubmitReviewModal: boolean;
  showFinalChoiceModal: boolean;
  isLoadingSessionItems: boolean;
  isSubmitting: boolean;
  submitError: string | null;
  submitSuccess: boolean;

  // Session items for review
  sessionItems: SessionItem[];
  sessionItemsSummary: SessionItemsSummary | null;
  editableItems: EditableItem[];

  // Combine session state
  availableSessions: ActiveSession[];
  showSessionSelectModal: boolean;
  selectedCombineSession: ActiveSession | null;
  showComparisonModal: boolean;
  comparisonResult: CompareSessionsResult | null;
  isLoadingComparison: boolean;
  comparisonError: string | null;

  // Merge state
  isMerging: boolean;
  mergeError: string | null;
  mergeSuccess: boolean;

  // Needs display modal state
  showNeedsDisplayModal: boolean;
  needsDisplayItems: NeedsDisplayItem[];
  submitResultData: SubmitResultData | null;
}

// ============ Zustand Actions Interface ============

export interface ReceivingSessionActions {
  // Session actions
  setSessionInfo: (info: SessionInfo | null) => void;
  setShipmentData: (data: ShipmentData | null) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;

  // Search actions
  setSearchQuery: (query: string) => void;
  setSearchResults: (results: SearchProduct[]) => void;
  setIsSearching: (isSearching: boolean) => void;
  setCurrency: (currency: Currency) => void;
  clearSearch: () => void;

  // Received entries actions
  addReceivedEntry: (entry: ReceivedEntry) => void;
  updateEntryQuantity: (entryId: string, quantity: number) => void;
  removeEntry: (entryId: string) => void;
  clearReceivedEntries: () => void;

  // Save actions
  setIsSaving: (isSaving: boolean) => void;
  setSaveError: (error: string | null) => void;
  setSaveSuccess: (success: boolean) => void;

  // Submit modal actions
  setShowSubmitModeModal: (show: boolean) => void;
  setShowSubmitConfirmModal: (show: boolean) => void;
  setShowSubmitReviewModal: (show: boolean) => void;
  setShowFinalChoiceModal: (show: boolean) => void;
  setIsLoadingSessionItems: (loading: boolean) => void;
  setIsSubmitting: (submitting: boolean) => void;
  setSubmitError: (error: string | null) => void;
  setSubmitSuccess: (success: boolean) => void;

  // Session items actions
  setSessionItems: (items: SessionItem[]) => void;
  setSessionItemsSummary: (summary: SessionItemsSummary | null) => void;
  setEditableItems: (items: EditableItem[]) => void;
  updateEditableItemQuantity: (productId: string, variantId: string | null, field: 'quantity' | 'quantityRejected', value: number) => void;

  // Combine session actions
  setAvailableSessions: (sessions: ActiveSession[]) => void;
  setShowSessionSelectModal: (show: boolean) => void;
  setSelectedCombineSession: (session: ActiveSession | null) => void;
  setShowComparisonModal: (show: boolean) => void;
  setComparisonResult: (result: CompareSessionsResult | null) => void;
  setIsLoadingComparison: (loading: boolean) => void;
  setComparisonError: (error: string | null) => void;

  // Merge actions
  setIsMerging: (merging: boolean) => void;
  setMergeError: (error: string | null) => void;
  setMergeSuccess: (success: boolean) => void;

  // Needs display actions
  setShowNeedsDisplayModal: (show: boolean) => void;
  setNeedsDisplayItems: (items: NeedsDisplayItem[]) => void;
  setSubmitResultData: (data: SubmitResultData | null) => void;

  // Reset actions
  reset: () => void;
  resetSubmitState: () => void;
  resetCompareState: () => void;
}

export type ReceivingSessionStore = ReceivingSessionState & ReceivingSessionActions;
