/**
 * IShipmentRepository
 * Repository interface for shipment operations
 * Defines the contract between presentation and data layer
 */

import type { Shipment, ShipmentListItemEntity, NewShipmentItem } from '../entities/Shipment';
import type {
  ShipmentListItem,
  ShipmentDetail,
  Counterparty,
  OrderInfo,
  OrderItem,
  InventoryProduct,
  Currency,
  CreateShipmentParams,
  OneTimeSupplier,
  DatePreset,
} from '../types';

// ===== Result Types =====

export interface RepositoryResult<T> {
  success: boolean;
  data?: T;
  error?: string;
  message?: string;
}

export interface PaginatedResult<T> {
  success: boolean;
  data: T[];
  totalCount: number;
  page: number;
  limit: number;
  error?: string;
}

// ===== Filter Types =====

export interface ShipmentListFilters {
  companyId: string;
  searchQuery?: string;
  datePreset?: DatePreset;
  fromDate?: string;
  toDate?: string;
  statusFilter?: string;
  supplierFilter?: string;
  orderFilter?: string;
  timezone: string;
}

export interface ShipmentDetailParams {
  shipmentId: string;
  companyId: string;
  timezone: string;
}

export interface CreateShipmentRequest {
  companyId: string;
  userId: string;
  items: Array<{
    sku: string;
    quantity_shipped: number;
    unit_cost: number;
  }>;
  time: string;
  timezone: string;
  orderIds?: string[];
  counterpartyId?: string;
  supplierInfo?: Partial<OneTimeSupplier>;
  trackingNumber?: string;
  notes?: string;
}

export interface CreateShipmentResponse {
  success: boolean;
  shipment_number?: string;
  message?: string;
}

// ===== Repository Interface =====

export interface IShipmentRepository {
  // ===== Shipment CRUD Operations =====

  /**
   * Get list of shipments with filters
   */
  getShipmentList(filters: ShipmentListFilters): Promise<RepositoryResult<ShipmentListItem[]>>;

  /**
   * Get shipment detail by ID
   */
  getShipmentDetail(params: ShipmentDetailParams): Promise<RepositoryResult<ShipmentDetail>>;

  /**
   * Create a new shipment
   */
  createShipment(request: CreateShipmentRequest): Promise<CreateShipmentResponse>;

  /**
   * Cancel a shipment
   */
  cancelShipment(shipmentId: string, companyId: string): Promise<RepositoryResult<void>>;

  // ===== Supporting Data Operations =====

  /**
   * Get list of counterparties (suppliers)
   */
  getCounterparties(companyId: string): Promise<RepositoryResult<Counterparty[]>>;

  /**
   * Get list of orders available for shipment
   */
  getOrders(companyId: string, timezone: string): Promise<RepositoryResult<OrderInfo[]>>;

  /**
   * Get order items by order ID
   */
  getOrderItems(orderId: string, timezone: string): Promise<RepositoryResult<OrderItem[]>>;

  /**
   * Get base currency for company
   */
  getBaseCurrency(companyId: string): Promise<RepositoryResult<Currency>>;

  /**
   * Search products by query
   */
  searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    timezone: string
  ): Promise<RepositoryResult<{ products: InventoryProduct[]; currency?: Currency }>>;

  /**
   * Search product by exact SKU
   */
  searchProductBySku(
    companyId: string,
    storeId: string,
    sku: string,
    timezone: string
  ): Promise<RepositoryResult<InventoryProduct | null>>;
}

// ===== Default Implementation Placeholder =====

/**
 * Placeholder for repository implementation
 * Actual implementation in data layer
 */
export const createShipmentRepository = (): IShipmentRepository => {
  throw new Error('ShipmentRepository not implemented. Use ShipmentRepositoryImpl from data layer.');
};
