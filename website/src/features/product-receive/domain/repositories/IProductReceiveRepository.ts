/**
 * IProductReceiveRepository
 * Repository interface for product receive operations
 */

import type {
  SearchProductResult,
  SessionItemsResult,
  SaveItem,
  SubmitItem,
  SubmitResult,
  Currency,
  Counterparty,
  Shipment,
  ShipmentDetail,
  Session,
  CreateSessionResult,
  JoinSessionResult,
} from '../entities';

export interface IProductReceiveRepository {
  /**
   * Search products by query (SKU, barcode, or name)
   */
  searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page?: number,
    limit?: number
  ): Promise<SearchProductResult>;

  /**
   * Add items to a receiving session
   */
  addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItem[]
  ): Promise<void>;

  /**
   * Get all items in a receiving session
   */
  getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsResult>;

  /**
   * Submit a receiving session
   */
  submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItem[],
    isFinal: boolean
  ): Promise<SubmitResult>;

  /**
   * Get base currency for company
   */
  getBaseCurrency(companyId: string): Promise<Currency>;

  /**
   * Get counterparties (suppliers) for company
   */
  getCounterparties(companyId: string): Promise<Counterparty[]>;

  /**
   * Get shipment list with filters
   */
  getShipmentList(params: {
    companyId: string;
    timezone: string;
    searchQuery?: string;
    fromDate?: string;
    toDate?: string;
    statusFilter?: string;
    supplierFilter?: string;
  }): Promise<{ shipments: Shipment[]; totalCount: number }>;

  /**
   * Get shipment detail
   */
  getShipmentDetail(params: {
    shipmentId: string;
    companyId: string;
    timezone: string;
  }): Promise<ShipmentDetail>;

  /**
   * Get session list for shipment
   */
  getSessionList(params: {
    companyId: string;
    shipmentId: string;
    sessionType: string;
    isActive: boolean;
    timezone: string;
  }): Promise<Session[]>;

  /**
   * Create a new receiving session
   */
  createSession(params: {
    companyId: string;
    storeId: string;
    userId: string;
    sessionType: string;
    shipmentId: string;
    time: string;
    timezone: string;
  }): Promise<CreateSessionResult>;

  /**
   * Join an existing session
   */
  joinSession(params: {
    sessionId: string;
    userId: string;
    time: string;
    timezone: string;
  }): Promise<JoinSessionResult>;
}
