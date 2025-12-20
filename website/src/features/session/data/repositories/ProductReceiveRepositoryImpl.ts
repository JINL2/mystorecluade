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
  SessionItemsFullResult,
  SessionItem,
  SessionItemsSummary,
  SessionParticipant,
  SaveItem,
  SubmitItem,
  SubmitResult,
  StockChange,
  Currency,
  Counterparty,
  Shipment,
  ShipmentDetail,
  ShipmentItem,
  ReceivingSummary,
  Session,
  CreateSessionResult,
  JoinSessionResult,
  MergeSessionsResult,
  CompareSessionsResult,
  CompareSessionInfo,
  CompareMatchedItem,
  CompareOnlyItem,
  CompareSessionsSummary,
  SessionHistoryResponse,
  SessionHistoryParams,
} from '../../domain/entities';
import { mapSessionHistoryResponseDTOToEntity } from '../models/SessionHistoryModels';
import {
  productReceiveDataSource,
  type IProductReceiveDataSource,
  type SearchProductDTO,
  type SessionItemDTO,
  type SessionItemsSummaryDTO,
  type SessionParticipantDTO,
  type CounterpartyDTO,
  type ShipmentDTO,
  type ShipmentDetailDTO,
  type ShipmentItemDTO,
  type ReceivingSummaryDTO,
  type SessionDTO,
  type StockChangeDTO,
  type MergeSessionsResultDTO,
  type CompareSessionsResultDTO,
  type CompareSessionInfoDTO,
  type CompareMatchedItemDTO,
  type CompareOnlyItemDTO,
  type CompareSessionsSummaryDTO,
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

// Map StockChangeDTO to StockChange domain entity
const mapStockChangeDTO = (dto: StockChangeDTO): StockChange => ({
  productId: dto.product_id,
  sku: dto.sku,
  productName: dto.product_name,
  quantityBefore: dto.quantity_before,
  quantityReceived: dto.quantity_received,
  quantityAfter: dto.quantity_after,
  needsDisplay: dto.needs_display,
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

const mapSessionParticipantDTO = (dto: SessionParticipantDTO): SessionParticipant => ({
  userId: dto.user_id,
  userName: dto.user_name,
  userProfileImage: dto.user_profile_image,
  productCount: dto.product_count,
  totalScanned: dto.total_scanned,
});

const mapCompareSessionInfoDTO = (dto: CompareSessionInfoDTO): CompareSessionInfo => ({
  sessionId: dto.session_id,
  sessionName: dto.session_name,
  sessionType: dto.session_type,
  storeId: dto.store_id,
  storeName: dto.store_name,
  createdBy: dto.created_by,
  createdByName: dto.created_by_name,
  totalProducts: dto.total_products,
  totalQuantity: dto.total_quantity,
});

const mapCompareMatchedItemDTO = (dto: CompareMatchedItemDTO): CompareMatchedItem => ({
  productId: dto.product_id,
  sku: dto.sku,
  productName: dto.product_name,
  quantityA: dto.quantity_a,
  quantityB: dto.quantity_b,
  quantityDiff: dto.quantity_diff,
  isMatch: dto.is_match,
});

const mapCompareOnlyItemDTO = (dto: CompareOnlyItemDTO): CompareOnlyItem => ({
  productId: dto.product_id,
  sku: dto.sku,
  productName: dto.product_name,
  quantity: dto.quantity,
});

const mapCompareSessionsSummaryDTO = (dto: CompareSessionsSummaryDTO): CompareSessionsSummary => ({
  totalMatched: dto.total_matched,
  quantitySameCount: dto.quantity_same_count,
  quantityDiffCount: dto.quantity_diff_count,
  onlyInACount: dto.only_in_a_count,
  onlyInBCount: dto.only_in_b_count,
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
    isFinal: boolean,
    notes?: string
  ): Promise<SubmitResult> {
    const result = await this.dataSource.submitSession(
      sessionId,
      userId,
      items.map(mapSubmitItemToDTO),
      isFinal,
      notes
    );

    return {
      receivingNumber: result.receiving_number,
      itemsCount: result.items_count,
      totalQuantity: result.total_quantity,
      // v2 fields
      stockChanges: result.stock_changes?.map(mapStockChangeDTO) || [],
      newDisplayCount: result.new_display_count || 0,
      totalCost: result.total_cost || 0,
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
    shipmentId?: string;
    sessionType?: string;
    isActive?: boolean;
    timezone: string;
  }): Promise<Session[]> {
    const result = await this.dataSource.getSessionList(params);
    return result.sessions.map(mapSessionDTO);
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

  async getSessionItemsFull(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsFullResult> {
    const result = await this.dataSource.getSessionItemsFull(sessionId, userId);
    return {
      sessionId: result.session_id,
      items: result.items.map(mapSessionItemDTO),
      participants: result.participants.map(mapSessionParticipantDTO),
      summary: {
        totalProducts: result.summary.total_products,
        totalQuantity: result.summary.total_quantity,
        totalRejected: result.summary.total_rejected,
        totalParticipants: result.summary.total_participants,
      },
    };
  }

  async mergeSessions(params: {
    targetSessionId: string;
    sourceSessionId: string;
    userId: string;
  }): Promise<MergeSessionsResult> {
    const result = await this.dataSource.mergeSessions(params);
    return {
      targetSession: {
        sessionId: result.target_session.session_id,
        sessionName: result.target_session.session_name,
        itemsBefore: result.target_session.items_before,
        itemsAfter: result.target_session.items_after,
        quantityBefore: result.target_session.quantity_before,
        quantityAfter: result.target_session.quantity_after,
      },
      sourceSession: {
        sessionId: result.source_session.session_id,
        sessionName: result.source_session.session_name,
        itemsCopied: result.source_session.items_copied,
        quantityCopied: result.source_session.quantity_copied,
        deactivated: result.source_session.deactivated,
      },
      summary: {
        totalItemsCopied: result.summary.total_items_copied,
        totalQuantityCopied: result.summary.total_quantity_copied,
        uniqueProductsCopied: result.summary.unique_products_copied,
      },
    };
  }

  async compareSessions(params: {
    sessionIdA: string;
    sessionIdB: string;
    userId: string;
  }): Promise<CompareSessionsResult> {
    const result = await this.dataSource.compareSessions(params);
    return {
      sessionA: mapCompareSessionInfoDTO(result.session_a),
      sessionB: mapCompareSessionInfoDTO(result.session_b),
      comparison: {
        matched: result.comparison.matched.map(mapCompareMatchedItemDTO),
        onlyInA: result.comparison.only_in_a.map(mapCompareOnlyItemDTO),
        onlyInB: result.comparison.only_in_b.map(mapCompareOnlyItemDTO),
      },
      summary: mapCompareSessionsSummaryDTO(result.summary),
    };
  }

  async getSessionHistory(params: SessionHistoryParams): Promise<SessionHistoryResponse> {
    const result = await this.dataSource.getSessionHistory({
      companyId: params.companyId,
      storeId: params.storeId,
      sessionType: params.sessionType,
      isActive: params.isActive,
      startDate: params.startDate,
      endDate: params.endDate,
      timezone: params.timezone,
      limit: params.limit,
      offset: params.offset,
    });
    return mapSessionHistoryResponseDTOToEntity(result);
  }
}

// Singleton instance
export const productReceiveRepository = new ProductReceiveRepositoryImpl();
