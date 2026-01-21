/**
 * SessionItem Entity
 * Represents an item in a receiving session
 */

export interface SessionItemUser {
  userId: string;
  userName: string;
  quantity: number;
  quantityRejected: number;
  startedAt?: string;
}

export interface SessionItem {
  productId: string;
  variantId?: string | null;
  productName: string;
  variantName?: string | null;
  displayName: string;
  sku: string;
  variantSku?: string | null;
  displaySku: string;
  hasVariants: boolean;
  imageUrls?: string[] | null;
  totalQuantity: number;
  totalRejected: number;
  scannedBy: SessionItemUser[];
}

export interface SessionItemsSummary {
  totalProducts: number;
  totalQuantity: number;
  totalRejected: number;
}

export interface SessionItemsResult {
  items: SessionItem[];
  summary: SessionItemsSummary;
}

export interface SaveItem {
  productId: string;
  variantId: string | null;
  quantity: number;
  quantityRejected: number;
}

export interface SubmitItem {
  productId: string;
  variantId: string | null;
  quantity: number;
  quantityRejected: number;
}

// Stock change item for v3 submit result
export interface StockChange {
  productId: string;
  variantId?: string | null;
  variantName?: string | null;
  displayName: string;
  sku: string;
  productName: string;
  quantityBefore: number;
  quantityReceived: number;
  quantityAfter: number;
  needsDisplay: boolean;
}

export interface SubmitResult {
  receivingNumber?: string;
  itemsCount?: number;
  totalQuantity?: number;
  // v3 fields
  stockChanges?: StockChange[];
  newDisplayCount?: number;
  totalCost?: number;
}

// Currency re-exported from SearchProduct
// (Currency interface is defined in SearchProduct.ts to avoid duplication)

// Counterparty (supplier) entity
export interface Counterparty {
  counterpartyId: string;
  name: string;
  isInternal?: boolean;
}

// Shipment entity for list
export interface Shipment {
  shipmentId: string;
  shipmentNumber: string;
  supplierName: string;
  status: string;
  shippedDate: string;
  totalItems: number;
  totalQuantity: number;
  totalCost: number;
}

// Shipment item entity (v2: variant support)
export interface ShipmentItem {
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

// Receiving summary entity
export interface ReceivingSummary {
  totalShipped: number;
  totalReceived: number;
  totalAccepted: number;
  totalRejected: number;
  totalRemaining: number;
  progressPercentage: number;
}

// Shipment detail entity
export interface ShipmentDetail {
  shipmentId: string;
  shipmentNumber: string;
  supplierId?: string;
  supplierName: string;
  status: string;
  shippedDate: string;
  trackingNumber?: string;
  notes?: string;
  items: ShipmentItem[];
  receivingSummary?: ReceivingSummary;
}

// Session status type (v2.1: in_progress, complete, cancelled)
export type SessionStatus = 'in_progress' | 'complete' | 'cancelled';

// Session entity
export interface Session {
  sessionId: string;
  sessionName?: string;
  sessionType: string;
  storeId: string;
  storeName: string;
  shipmentId?: string;
  shipmentNumber?: string;
  isActive: boolean;
  isFinal: boolean;
  createdBy: string;
  createdByName: string;
  createdAt: string;
  completedAt?: string;
  memberCount?: number;
  // v2 fields
  status?: SessionStatus;
  supplierId?: string;
  supplierName?: string;
}

// Create session result
export interface CreateSessionResult {
  sessionId: string;
  [key: string]: unknown;
}

// Join session result
export interface JoinSessionResult {
  memberId?: string;
  createdBy?: string;
  createdByName?: string;
}

// Merged item for v2 merge result
export interface MergedItem {
  itemId: string;
  productId: string;
  variantId: string | null;
  sku: string;
  productName: string;
  variantName: string | null;
  displayName: string;
  hasVariants: boolean;
  quantity: number;
  quantityRejected: number;
  scannedBy: string;
  scannedByName: string;
}

// Merge sessions result (v2)
export interface MergeSessionsResult {
  targetSession: {
    sessionId: string;
    sessionName: string;
    sessionType: string;
    storeId: string;
    storeName: string;
    itemsBefore: number;
    itemsAfter: number;
    quantityBefore: number;
    quantityAfter: number;
    membersBefore: number;
    membersAfter: number;
  };
  sourceSession: {
    sessionId: string;
    sessionName: string;
    itemsCopied: number;
    quantityCopied: number;
    membersAdded: number;
    deactivated: boolean;
  };
  mergedItems: MergedItem[];
  summary: {
    totalItemsCopied: number;
    totalQuantityCopied: number;
    totalMembersAdded: number;
    uniqueProductsCopied: number;
  };
}

// Compare sessions entities
export interface CompareSessionInfo {
  sessionId: string;
  sessionName: string;
  sessionType: string;
  storeId: string;
  storeName: string;
  createdBy: string;
  createdByName: string;
  totalProducts: number;
  totalQuantity: number;
}

// Compare matched item (v2 with variant support)
export interface CompareMatchedItem {
  productId: string;
  variantId: string | null;
  sku: string;
  productName: string;
  variantName: string | null;
  displayName: string;
  hasVariants: boolean;
  quantityA: number;
  quantityB: number;
  quantityDiff: number;
  isMatch: boolean;
}

// Compare only item (v2 with variant support)
export interface CompareOnlyItem {
  productId: string;
  variantId: string | null;
  sku: string;
  productName: string;
  variantName: string | null;
  displayName: string;
  hasVariants: boolean;
  quantity: number;
}

export interface CompareSessionsSummary {
  totalMatched: number;
  quantitySameCount: number;
  quantityDiffCount: number;
  onlyInACount: number;
  onlyInBCount: number;
}

export interface CompareSessionsResult {
  sessionA: CompareSessionInfo;
  sessionB: CompareSessionInfo;
  comparison: {
    matched: CompareMatchedItem[];
    onlyInA: CompareOnlyItem[];
    onlyInB: CompareOnlyItem[];
  };
  summary: CompareSessionsSummary;
}
