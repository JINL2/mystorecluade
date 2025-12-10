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
