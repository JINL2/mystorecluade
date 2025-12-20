/**
 * SessionItem Entity
 * Represents an item in a receiving session
 */

export interface SessionItemUser {
  userId: string;
  userName: string;
  quantity: number;
  quantityRejected: number;
}

export interface SessionItem {
  productId: string;
  productName: string;
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
  quantity: number;
  quantityRejected: number;
}

export interface SubmitItem {
  productId: string;
  quantity: number;
  quantityRejected: number;
}

// Stock change item for v2 submit result
export interface StockChange {
  productId: string;
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
  // v2 fields
  stockChanges?: StockChange[];
  newDisplayCount?: number;
  totalCost?: number;
}

// Currency entity
export interface Currency {
  symbol: string;
  code: string;
  name?: string;
}

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

// Shipment item entity
export interface ShipmentItem {
  itemId: string;
  productId: string;
  productName: string;
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
  memberCount?: number;
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

// Session participant entity
export interface SessionParticipant {
  userId: string;
  userName: string;
  userProfileImage: string | null;
  productCount: number;
  totalScanned: number;
}

// Extended session items result with participants
export interface SessionItemsFullResult {
  sessionId: string;
  items: SessionItem[];
  participants: SessionParticipant[];
  summary: SessionItemsSummary & { totalParticipants?: number };
}

// Merge sessions result
export interface MergeSessionsResult {
  targetSession: {
    sessionId: string;
    sessionName: string;
    itemsBefore: number;
    itemsAfter: number;
    quantityBefore: number;
    quantityAfter: number;
  };
  sourceSession: {
    sessionId: string;
    sessionName: string;
    itemsCopied: number;
    quantityCopied: number;
    deactivated: boolean;
  };
  summary: {
    totalItemsCopied: number;
    totalQuantityCopied: number;
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

export interface CompareMatchedItem {
  productId: string;
  sku: string;
  productName: string;
  quantityA: number;
  quantityB: number;
  quantityDiff: number;
  isMatch: boolean;
}

export interface CompareOnlyItem {
  productId: string;
  sku: string;
  productName: string;
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
