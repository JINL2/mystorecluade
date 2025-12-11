/**
 * ProductReceiveRepositoryImpl
 * Implementation of IProductReceiveRepository
 * Maps DataSource DTOs to Domain Entities
 */

import type { IProductReceiveRepository } from '../../domain/repositories/IProductReceiveRepository';
import type {
  SearchProductResult,
  SearchProduct,
  SessionItemsResult,
  SessionItem,
  SessionItemsSummary,
  SaveItem,
  SubmitItem,
  SubmitResult,
  Currency,
  Counterparty,
  Shipment,
  ShipmentDetail,
  ShipmentItem,
  ReceivingSummary,
  Session,
  CreateSessionResult,
  JoinSessionResult,
} from '../../domain/entities';
import {
  productReceiveDataSource,
  type IProductReceiveDataSource,
  type SearchProductDTO,
  type SessionItemDTO,
  type SessionItemsSummaryDTO,
  type CounterpartyDTO,
  type ShipmentDTO,
  type ShipmentDetailDTO,
  type ShipmentItemDTO,
  type ReceivingSummaryDTO,
  type SessionDTO,
} from '../datasources/ProductReceiveDataSource';

// Mapper functions: DTO -> Domain Entity
const mapSearchProductDTO = (dto: SearchProductDTO): SearchProduct => ({
  productId: dto.product_id,
  productName: dto.product_name,
  sku: dto.sku,
  barcode: dto.barcode,
  imageUrls: dto.image_urls,
  stock: {
    quantityOnHand: dto.stock.quantity_on_hand,
    quantityAvailable: dto.stock.quantity_available,
    quantityReserved: dto.stock.quantity_reserved,
  },
  price: {
    cost: dto.price.cost,
    selling: dto.price.selling,
    source: dto.price.source,
  },
});

const mapSessionItemDTO = (dto: SessionItemDTO): SessionItem => ({
  productId: dto.product_id,
  productName: dto.product_name,
  totalQuantity: dto.total_quantity,
  totalRejected: dto.total_rejected,
  scannedBy: dto.scanned_by.map((user) => ({
    userId: user.user_id,
    userName: user.user_name,
    quantity: user.quantity,
    quantityRejected: user.quantity_rejected,
  })),
});

const mapSessionItemsSummaryDTO = (dto: SessionItemsSummaryDTO): SessionItemsSummary => ({
  totalProducts: dto.total_products,
  totalQuantity: dto.total_quantity,
  totalRejected: dto.total_rejected,
});

// Mapper functions: Domain Entity -> DTO
const mapSaveItemToDTO = (item: SaveItem) => ({
  product_id: item.productId,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

const mapSubmitItemToDTO = (item: SubmitItem) => ({
  product_id: item.productId,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

// New mapper functions for additional entities
const mapCounterpartyDTO = (dto: CounterpartyDTO): Counterparty => ({
  counterpartyId: dto.counterparty_id,
  name: dto.name,
  isInternal: dto.is_internal,
});

const mapShipmentDTO = (dto: ShipmentDTO): Shipment => ({
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  supplierName: dto.supplier_name,
  status: dto.status,
  shippedDate: dto.shipped_date,
  totalItems: dto.total_items,
  totalQuantity: dto.total_quantity,
  totalCost: dto.total_cost,
});

const mapShipmentItemDTO = (dto: ShipmentItemDTO): ShipmentItem => ({
  itemId: dto.item_id,
  productId: dto.product_id,
  productName: dto.product_name,
  sku: dto.sku,
  quantityShipped: dto.quantity_shipped,
  quantityReceived: dto.quantity_received,
  quantityAccepted: dto.quantity_accepted,
  quantityRejected: dto.quantity_rejected,
  quantityRemaining: dto.quantity_remaining,
  unitCost: dto.unit_cost,
});

const mapReceivingSummaryDTO = (dto: ReceivingSummaryDTO): ReceivingSummary => ({
  totalShipped: dto.total_shipped,
  totalReceived: dto.total_received,
  totalAccepted: dto.total_accepted,
  totalRejected: dto.total_rejected,
  totalRemaining: dto.total_remaining,
  progressPercentage: dto.progress_percentage,
});

const mapShipmentDetailDTO = (dto: ShipmentDetailDTO): ShipmentDetail => ({
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  supplierId: dto.supplier_id,
  supplierName: dto.supplier_name,
  status: dto.status,
  shippedDate: dto.shipped_date,
  trackingNumber: dto.tracking_number,
  notes: dto.notes,
  items: dto.items.map(mapShipmentItemDTO),
  receivingSummary: dto.receiving_summary ? mapReceivingSummaryDTO(dto.receiving_summary) : undefined,
});

const mapSessionDTO = (dto: SessionDTO): Session => ({
  sessionId: dto.session_id,
  sessionName: dto.session_name,
  sessionType: dto.session_type,
  storeId: dto.store_id,
  storeName: dto.store_name,
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  isActive: dto.is_active,
  isFinal: dto.is_final,
  createdBy: dto.created_by,
  createdByName: dto.created_by_name,
  createdAt: dto.created_at,
  memberCount: dto.member_count,
});

export class ProductReceiveRepositoryImpl implements IProductReceiveRepository {
  constructor(private dataSource: IProductReceiveDataSource = productReceiveDataSource) {}

  async searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page: number = 1,
    limit: number = 10
  ): Promise<SearchProductResult> {
    const result = await this.dataSource.searchProducts(
      companyId,
      storeId,
      query,
      page,
      limit
    );

    return {
      products: result.products.map(mapSearchProductDTO),
      currency: {
        symbol: result.currency.symbol,
        code: result.currency.code,
      },
    };
  }

  async addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItem[]
  ): Promise<void> {
    await this.dataSource.addSessionItems(
      sessionId,
      userId,
      items.map(mapSaveItemToDTO)
    );
  }

  async getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsResult> {
    const result = await this.dataSource.getSessionItems(sessionId, userId);

    return {
      items: result.items.map(mapSessionItemDTO),
      summary: mapSessionItemsSummaryDTO(result.summary),
    };
  }

  async submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItem[],
    isFinal: boolean
  ): Promise<SubmitResult> {
    const result = await this.dataSource.submitSession(
      sessionId,
      userId,
      items.map(mapSubmitItemToDTO),
      isFinal
    );

    return {
      receivingNumber: result.receiving_number,
      itemsCount: result.items_count,
      totalQuantity: result.total_quantity,
    };
  }

  async getBaseCurrency(companyId: string): Promise<Currency> {
    const result = await this.dataSource.getBaseCurrency(companyId);
    return {
      symbol: result.symbol,
      code: result.code,
    };
  }

  async getCounterparties(companyId: string): Promise<Counterparty[]> {
    const result = await this.dataSource.getCounterparties(companyId);
    return result.map(mapCounterpartyDTO);
  }

  async getShipmentList(params: {
    companyId: string;
    timezone: string;
    searchQuery?: string;
    fromDate?: string;
    toDate?: string;
    statusFilter?: string;
    supplierFilter?: string;
  }): Promise<{ shipments: Shipment[]; totalCount: number }> {
    const result = await this.dataSource.getShipmentList(params);
    return {
      shipments: result.shipments.map(mapShipmentDTO),
      totalCount: result.totalCount,
    };
  }

  async getShipmentDetail(params: {
    shipmentId: string;
    companyId: string;
    timezone: string;
  }): Promise<ShipmentDetail> {
    const result = await this.dataSource.getShipmentDetail(params);
    return mapShipmentDetailDTO(result);
  }

  async getSessionList(params: {
    companyId: string;
    shipmentId: string;
    sessionType: string;
    isActive: boolean;
    timezone: string;
  }): Promise<Session[]> {
    const result = await this.dataSource.getSessionList(params);
    return result.map(mapSessionDTO);
  }

  async createSession(params: {
    companyId: string;
    storeId: string;
    userId: string;
    sessionType: string;
    shipmentId: string;
    sessionName?: string;
    time: string;
    timezone: string;
  }): Promise<CreateSessionResult> {
    const result = await this.dataSource.createSession(params);
    return {
      sessionId: result.session_id,
      ...result,
    };
  }

  async joinSession(params: {
    sessionId: string;
    userId: string;
    time: string;
    timezone: string;
  }): Promise<JoinSessionResult> {
    const result = await this.dataSource.joinSession(params);
    return {
      memberId: result.member_id,
      createdBy: result.created_by,
      createdByName: result.created_by_name,
    };
  }
}

// Singleton instance
export const productReceiveRepository = new ProductReceiveRepositoryImpl();
