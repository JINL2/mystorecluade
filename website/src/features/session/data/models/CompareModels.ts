/**
 * Compare Models
 * DTO types for session comparison and merge operations
 * Note: Mapper functions are defined in ProductReceiveRepositoryImpl.ts
 */

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
