/**
 * Compare Models
 * DTO types and mappers for session comparison and merge operations
 */

import type {
  MergeSessionsResult,
  MergedItem,
  CompareSessionsResult,
  CompareSessionInfo,
  CompareMatchedItem,
  CompareOnlyItem,
  CompareSessionsSummary,
} from '../../domain/entities';

// ============ DTO Types ============

// Merged item DTO for v2 merge result
export interface MergedItemDTO {
  item_id: string;
  product_id: string;
  variant_id: string | null;
  sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
  quantity: number;
  quantity_rejected: number;
  scanned_by: string;
  scanned_by_name: string;
}

// Merge Sessions Result DTO (v2)
export interface MergeSessionsResultDTO {
  target_session: {
    session_id: string;
    session_name: string;
    session_type: string;
    store_id: string;
    store_name: string;
    items_before: number;
    items_after: number;
    quantity_before: number;
    quantity_after: number;
    members_before: number;
    members_after: number;
  };
  source_session: {
    session_id: string;
    session_name: string;
    items_copied: number;
    quantity_copied: number;
    members_added: number;
    deactivated: boolean;
  };
  merged_items: MergedItemDTO[];
  summary: {
    total_items_copied: number;
    total_quantity_copied: number;
    total_members_added: number;
    unique_products_copied: number;
  };
}

export interface CompareSessionInfoDTO {
  session_id: string;
  session_name: string;
  session_type: string;
  store_id: string;
  store_name: string;
  created_by: string;
  created_by_name: string;
  total_products: number;
  total_quantity: number;
}

// Compare matched item DTO (v2 with variant support)
export interface CompareMatchedItemDTO {
  product_id: string;
  variant_id: string | null;
  sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
  quantity_a: number;
  quantity_b: number;
  quantity_diff: number;
  is_match: boolean;
}

// Compare only item DTO (v2 with variant support)
export interface CompareOnlyItemDTO {
  product_id: string;
  variant_id: string | null;
  sku: string;
  product_name: string;
  variant_name: string | null;
  display_name: string;
  has_variants: boolean;
  quantity: number;
}

export interface CompareSessionsSummaryDTO {
  total_matched: number;
  quantity_same_count: number;
  quantity_diff_count: number;
  only_in_a_count: number;
  only_in_b_count: number;
}

export interface CompareSessionsResultDTO {
  session_a: CompareSessionInfoDTO;
  session_b: CompareSessionInfoDTO;
  comparison: {
    matched: CompareMatchedItemDTO[];
    only_in_a: CompareOnlyItemDTO[];
    only_in_b: CompareOnlyItemDTO[];
  };
  summary: CompareSessionsSummaryDTO;
}

// ============ Mapper Functions: DTO -> Domain Entity ============

export const mapCompareSessionInfoDTO = (dto: CompareSessionInfoDTO): CompareSessionInfo => ({
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

export const mapCompareMatchedItemDTO = (dto: CompareMatchedItemDTO): CompareMatchedItem => ({
  productId: dto.product_id,
  variantId: dto.variant_id,
  sku: dto.sku,
  productName: dto.product_name,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  hasVariants: dto.has_variants,
  quantityA: dto.quantity_a,
  quantityB: dto.quantity_b,
  quantityDiff: dto.quantity_diff,
  isMatch: dto.is_match,
});

export const mapCompareOnlyItemDTO = (dto: CompareOnlyItemDTO): CompareOnlyItem => ({
  productId: dto.product_id,
  variantId: dto.variant_id,
  sku: dto.sku,
  productName: dto.product_name,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  hasVariants: dto.has_variants,
  quantity: dto.quantity,
});

export const mapCompareSessionsSummaryDTO = (dto: CompareSessionsSummaryDTO): CompareSessionsSummary => ({
  totalMatched: dto.total_matched,
  quantitySameCount: dto.quantity_same_count,
  quantityDiffCount: dto.quantity_diff_count,
  onlyInACount: dto.only_in_a_count,
  onlyInBCount: dto.only_in_b_count,
});

export const mapMergedItemDTO = (dto: MergedItemDTO): MergedItem => ({
  itemId: dto.item_id,
  productId: dto.product_id,
  variantId: dto.variant_id,
  sku: dto.sku,
  productName: dto.product_name,
  variantName: dto.variant_name,
  displayName: dto.display_name,
  hasVariants: dto.has_variants,
  quantity: dto.quantity,
  quantityRejected: dto.quantity_rejected,
  scannedBy: dto.scanned_by,
  scannedByName: dto.scanned_by_name,
});

export const mapMergeSessionsResultDTO = (dto: MergeSessionsResultDTO): MergeSessionsResult => ({
  targetSession: {
    sessionId: dto.target_session.session_id,
    sessionName: dto.target_session.session_name,
    sessionType: dto.target_session.session_type,
    storeId: dto.target_session.store_id,
    storeName: dto.target_session.store_name,
    itemsBefore: dto.target_session.items_before,
    itemsAfter: dto.target_session.items_after,
    quantityBefore: dto.target_session.quantity_before,
    quantityAfter: dto.target_session.quantity_after,
    membersBefore: dto.target_session.members_before,
    membersAfter: dto.target_session.members_after,
  },
  sourceSession: {
    sessionId: dto.source_session.session_id,
    sessionName: dto.source_session.session_name,
    itemsCopied: dto.source_session.items_copied,
    quantityCopied: dto.source_session.quantity_copied,
    membersAdded: dto.source_session.members_added,
    deactivated: dto.source_session.deactivated,
  },
  mergedItems: dto.merged_items.map(mapMergedItemDTO),
  summary: {
    totalItemsCopied: dto.summary.total_items_copied,
    totalQuantityCopied: dto.summary.total_quantity_copied,
    totalMembersAdded: dto.summary.total_members_added,
    uniqueProductsCopied: dto.summary.unique_products_copied,
  },
});

export const mapCompareSessionsResultDTO = (dto: CompareSessionsResultDTO): CompareSessionsResult => ({
  sessionA: mapCompareSessionInfoDTO(dto.session_a),
  sessionB: mapCompareSessionInfoDTO(dto.session_b),
  comparison: {
    matched: dto.comparison.matched.map(mapCompareMatchedItemDTO),
    onlyInA: dto.comparison.only_in_a.map(mapCompareOnlyItemDTO),
    onlyInB: dto.comparison.only_in_b.map(mapCompareOnlyItemDTO),
  },
  summary: mapCompareSessionsSummaryDTO(dto.summary),
});
