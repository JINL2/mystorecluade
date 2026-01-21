/**
 * SessionHistory Domain Entities
 * Based on inventory_get_session_history_v4 RPC response with variant support and server-side search
 */

/**
 * User info in session history
 */
export interface SessionHistoryUser {
  userId: string;
  firstName: string;
  lastName: string;
  profileImage: string | null;
}

/**
 * Member who participated in a session
 */
export interface SessionHistoryMember {
  userId: string;
  firstName: string;
  lastName: string;
  profileImage: string | null;
  joinedAt: string;
  isActive: boolean;
}

/**
 * Scanned by info for an item
 */
export interface SessionHistoryScannedBy {
  userId: string;
  firstName: string;
  lastName: string;
  profileImage: string | null;
  quantity: number;
  quantityRejected: number;
}

/**
 * Item in a session (scanned product with variant support)
 */
export interface SessionHistoryItem {
  productId: string;
  variantId: string | null;
  productName: string;
  variantName: string | null;
  displayName: string;
  sku: string | null;
  variantSku: string | null;
  displaySku: string;
  hasVariants: boolean;
  scannedQuantity: number;
  scannedRejected: number;
  scannedBy: SessionHistoryScannedBy[];
  confirmedQuantity: number | null;
  confirmedRejected: number | null;
  quantityExpected: number | null;
  quantityDifference: number | null;
}

/**
 * Merge information for sessions that resulted from merging (with variant support)
 */
export interface SessionMergeInfo {
  originalSession: {
    items: Array<{
      productId: string;
      variantId: string | null;
      sku: string;
      variantSku: string | null;
      displaySku: string;
      productName: string;
      variantName: string | null;
      displayName: string;
      hasVariants: boolean;
      quantity: number;
      quantityRejected: number;
      scannedBy: SessionHistoryUser;
    }>;
    itemsCount: number;
    totalQuantity: number;
    totalRejected: number;
  };
  mergedSessions: Array<{
    sourceSessionId: string;
    sourceSessionName: string;
    sourceCreatedAt: string;
    sourceCreatedBy: SessionHistoryUser;
    items: Array<{
      productId: string;
      variantId: string | null;
      sku: string;
      variantSku: string | null;
      displaySku: string;
      productName: string;
      variantName: string | null;
      displayName: string;
      hasVariants: boolean;
      quantity: number;
      quantityRejected: number;
      scannedBy: SessionHistoryUser;
    }>;
    itemsCount: number;
    totalQuantity: number;
    totalRejected: number;
  }>;
  totalMergedSessionsCount: number;
}

/**
 * Stock snapshot for receiving sessions (with variant support)
 */
export interface StockSnapshot {
  productId: string;
  variantId: string | null;
  sku: string;
  variantSku: string | null;
  displaySku: string;
  productName: string;
  variantName: string | null;
  displayName: string;
  hasVariants: boolean;
  quantityBefore: number;
  quantityReceived: number;
  quantityAfter: number;
  needsDisplay: boolean;
}

/**
 * Receiving-specific information
 */
export interface SessionReceivingInfo {
  receivingId: string;
  receivingNumber: string;
  receivedAt: string;
  stockSnapshot: StockSnapshot[];
  newProductsCount: number;
  restockProductsCount: number;
}

/**
 * Session history entry from RPC response
 */
export interface SessionHistoryEntry {
  sessionId: string;
  sessionName: string;
  sessionType: 'counting' | 'receiving';
  isActive: boolean;
  isFinal: boolean;
  storeId: string;
  storeName: string;
  shipmentId: string | null;
  shipmentNumber: string | null;
  createdAt: string;
  completedAt: string | null;
  durationMinutes: number | null;
  createdBy: SessionHistoryUser;
  members: SessionHistoryMember[];
  memberCount: number;
  items: SessionHistoryItem[];
  totalScannedQuantity: number;
  totalScannedRejected: number;
  totalConfirmedQuantity: number | null;
  totalConfirmedRejected: number | null;
  totalDifference: number | null;
  isMergedSession: boolean;
  mergeInfo: SessionMergeInfo | null;
  receivingInfo: SessionReceivingInfo | null;
}

/**
 * Pagination info for session history
 */
export interface SessionHistoryPagination {
  total: number;
  limit: number;
  offset: number;
  hasMore: boolean;
}

/**
 * Complete session history response
 */
export interface SessionHistoryResponse {
  sessions: SessionHistoryEntry[];
  pagination: SessionHistoryPagination;
}

/**
 * Parameters for fetching session history
 */
export interface SessionHistoryParams {
  companyId: string;
  storeId?: string; // Optional - if not provided, get sessions for all stores
  sessionType?: 'counting' | 'receiving' | null;
  isActive?: boolean;
  startDate?: string | null;
  endDate?: string | null;
  timezone?: string;
  limit?: number;
  offset?: number;
  search?: string | null; // Server-side search (session_name, product_name, SKU, product_id)
}
