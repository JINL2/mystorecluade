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

export interface SubmitResult {
  receivingNumber?: string;
  itemsCount?: number;
  totalQuantity?: number;
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
