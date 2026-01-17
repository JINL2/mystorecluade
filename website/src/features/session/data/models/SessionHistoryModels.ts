/**
 * SessionHistory DTO to Entity Mappers
 * Maps inventory_get_session_history_v3 RPC response to domain entities with variant support
 */

import type {
  SessionHistoryUserDTO,
  SessionHistoryMemberDTO,
  SessionHistoryScannedByDTO,
  SessionHistoryItemDTO,
  SessionMergeInfoDTO,
  StockSnapshotDTO,
  SessionReceivingInfoDTO,
  SessionHistoryEntryDTO,
  SessionHistoryPaginationDTO,
  SessionHistoryResponseDTO,
} from '../datasources/ProductReceiveDataSource';

import type {
  SessionHistoryUser,
  SessionHistoryMember,
  SessionHistoryScannedBy,
  SessionHistoryItem,
  SessionMergeInfo,
  StockSnapshot,
  SessionReceivingInfo,
  SessionHistoryEntry,
  SessionHistoryPagination,
  SessionHistoryResponse,
} from '../../domain/entities';

/**
 * Map user DTO to entity (internal helper)
 */
const mapUserDTOToEntity = (dto: SessionHistoryUserDTO): SessionHistoryUser => ({
  userId: dto.user_id,
  firstName: dto.first_name,
  lastName: dto.last_name,
  profileImage: dto.profile_image,
});

/**
 * Map member DTO to entity (internal helper)
 */
const mapMemberDTOToEntity = (dto: SessionHistoryMemberDTO): SessionHistoryMember => ({
  userId: dto.user_id,
  firstName: dto.first_name,
  lastName: dto.last_name,
  profileImage: dto.profile_image,
  joinedAt: dto.joined_at,
  isActive: dto.is_active,
});

/**
 * Map scanned by DTO to entity (internal helper)
 */
const mapScannedByDTOToEntity = (dto: SessionHistoryScannedByDTO): SessionHistoryScannedBy => ({
  userId: dto.user_id,
  firstName: dto.first_name,
  lastName: dto.last_name,
  profileImage: dto.profile_image,
  quantity: dto.quantity,
  quantityRejected: dto.quantity_rejected,
});

/**
 * Map item DTO to entity (internal helper, with variant support)
 */
const mapItemDTOToEntity = (dto: SessionHistoryItemDTO): SessionHistoryItem => ({
  productId: dto.product_id,
  variantId: dto.variant_id,
  productName: dto.product_name,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  sku: dto.sku,
  variantSku: dto.variant_sku,
  displaySku: dto.display_sku,
  hasVariants: dto.has_variants,
  scannedQuantity: dto.scanned_quantity,
  scannedRejected: dto.scanned_rejected,
  scannedBy: dto.scanned_by?.map(mapScannedByDTOToEntity) || [],
  confirmedQuantity: dto.confirmed_quantity,
  confirmedRejected: dto.confirmed_rejected,
  quantityExpected: dto.quantity_expected,
  quantityDifference: dto.quantity_difference,
});

/**
 * Map stock snapshot DTO to entity (internal helper, with variant support)
 */
const mapStockSnapshotDTOToEntity = (dto: StockSnapshotDTO): StockSnapshot => ({
  productId: dto.product_id,
  variantId: dto.variant_id,
  sku: dto.sku,
  variantSku: dto.variant_sku,
  displaySku: dto.display_sku,
  productName: dto.product_name,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  hasVariants: dto.has_variants,
  quantityBefore: dto.quantity_before,
  quantityReceived: dto.quantity_received,
  quantityAfter: dto.quantity_after,
  needsDisplay: dto.needs_display,
});

/**
 * Map merge info DTO to entity (internal helper, with variant support)
 */
const mapMergeInfoDTOToEntity = (dto: SessionMergeInfoDTO | null): SessionMergeInfo | null => {
  if (!dto) return null;
  return {
    originalSession: {
      items: dto.original_session?.items?.map((item) => ({
        productId: item.product_id,
        variantId: item.variant_id,
        sku: item.sku,
        variantSku: item.variant_sku,
        displaySku: item.display_sku,
        productName: item.product_name,
        variantName: item.variant_name,
        displayName: item.display_name,
        hasVariants: item.has_variants,
        quantity: item.quantity,
        quantityRejected: item.quantity_rejected,
        scannedBy: mapUserDTOToEntity(item.scanned_by),
      })) || [],
      itemsCount: dto.original_session?.items_count || 0,
      totalQuantity: dto.original_session?.total_quantity || 0,
      totalRejected: dto.original_session?.total_rejected || 0,
    },
    mergedSessions: dto.merged_sessions?.map((session) => ({
      sourceSessionId: session.source_session_id,
      sourceSessionName: session.source_session_name,
      sourceCreatedAt: session.source_created_at,
      sourceCreatedBy: mapUserDTOToEntity(session.source_created_by),
      items: session.items?.map((item) => ({
        productId: item.product_id,
        variantId: item.variant_id,
        sku: item.sku,
        variantSku: item.variant_sku,
        displaySku: item.display_sku,
        productName: item.product_name,
        variantName: item.variant_name,
        displayName: item.display_name,
        hasVariants: item.has_variants,
        quantity: item.quantity,
        quantityRejected: item.quantity_rejected,
        scannedBy: mapUserDTOToEntity(item.scanned_by),
      })) || [],
      itemsCount: session.items_count,
      totalQuantity: session.total_quantity,
      totalRejected: session.total_rejected,
    })) || [],
    totalMergedSessionsCount: dto.total_merged_sessions_count || 0,
  };
};

/**
 * Map receiving info DTO to entity (internal helper)
 */
const mapReceivingInfoDTOToEntity = (dto: SessionReceivingInfoDTO | null): SessionReceivingInfo | null => {
  if (!dto) return null;
  return {
    receivingId: dto.receiving_id,
    receivingNumber: dto.receiving_number,
    receivedAt: dto.received_at,
    stockSnapshot: dto.stock_snapshot?.map(mapStockSnapshotDTOToEntity) || [],
    newProductsCount: dto.new_products_count || 0,
    restockProductsCount: dto.restock_products_count || 0,
  };
};

/**
 * Map session history entry DTO to entity (internal helper)
 */
const mapSessionHistoryEntryDTOToEntity = (dto: SessionHistoryEntryDTO): SessionHistoryEntry => ({
  sessionId: dto.session_id,
  sessionName: dto.session_name,
  sessionType: dto.session_type,
  isActive: dto.is_active,
  isFinal: dto.is_final,
  storeId: dto.store_id,
  storeName: dto.store_name,
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  createdAt: dto.created_at,
  completedAt: dto.completed_at,
  durationMinutes: dto.duration_minutes,
  createdBy: mapUserDTOToEntity(dto.created_by),
  members: dto.members?.map(mapMemberDTOToEntity) || [],
  memberCount: dto.member_count || 0,
  items: dto.items?.map(mapItemDTOToEntity) || [],
  totalScannedQuantity: dto.total_scanned_quantity || 0,
  totalScannedRejected: dto.total_scanned_rejected || 0,
  totalConfirmedQuantity: dto.total_confirmed_quantity,
  totalConfirmedRejected: dto.total_confirmed_rejected,
  totalDifference: dto.total_difference,
  isMergedSession: dto.is_merged_session || false,
  mergeInfo: mapMergeInfoDTOToEntity(dto.merge_info),
  receivingInfo: mapReceivingInfoDTOToEntity(dto.receiving_info),
});

/**
 * Map pagination DTO to entity (internal helper)
 */
const mapPaginationDTOToEntity = (dto: SessionHistoryPaginationDTO): SessionHistoryPagination => ({
  total: dto.total,
  limit: dto.limit,
  offset: dto.offset,
  hasMore: dto.has_more,
});

/**
 * Map full response DTO to entity
 * This is the only exported function - used by ProductReceiveRepositoryImpl
 */
export const mapSessionHistoryResponseDTOToEntity = (dto: SessionHistoryResponseDTO): SessionHistoryResponse => ({
  sessions: dto.sessions?.map(mapSessionHistoryEntryDTOToEntity) || [],
  pagination: mapPaginationDTOToEntity(dto.pagination),
});
