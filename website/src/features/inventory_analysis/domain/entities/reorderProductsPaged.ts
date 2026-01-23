/**
 * ReorderProductsPaged Entity
 * Domain entity for reorder products paged RPC response
 */

// Status filter options
export type ReorderStatusFilter =
  | 'abnormal'
  | 'critical'
  | 'warning'
  | 'stockout'
  | 'overstock'
  | 'dead_stock'
  | 'reorder_needed';

// Reorder product item
export interface ReorderProductItem {
  productId: string;
  productName: string;
  categoryId: string;
  categoryName: string;
  currentStock: number;
  daysOfInventory: number;
  avgDailyDemand: number;
  reorderPoint: number;
  statusLabel: string;
  isAbnormalStock: boolean;
  isStockout: boolean;
  isCritical: boolean;
  isWarning: boolean;
  isOverstock: boolean;
  isDeadStock: boolean;
  priorityRank: number;
}

// Paged response
export interface ReorderProductsPaged {
  items: ReorderProductItem[];
  totalCount: number;
  page: number;
  pageSize: number;
  hasMore: boolean;
}

// RPC response types
interface ReorderProductItemRpc {
  product_id: string;
  product_name: string;
  category_id: string;
  category_name: string;
  current_stock: number;
  days_of_inventory: number;
  avg_daily_demand: number;
  reorder_point: number;
  status_label: string;
  is_abnormal_stock: boolean;
  is_stockout: boolean;
  is_critical: boolean;
  is_warning: boolean;
  is_overstock: boolean;
  is_dead_stock: boolean;
  priority_rank: number;
}

interface ReorderProductsPagedRpc {
  items: ReorderProductItemRpc[];
  total_count: number;
  page: number;
  page_size: number;
  has_more: boolean;
}

/**
 * Map RPC response to domain entity
 */
export function mapReorderProductsPagedFromRpc(data: unknown): ReorderProductsPaged {
  const response = data as ReorderProductsPagedRpc;

  return {
    items: (response.items ?? []).map((item) => ({
      productId: item.product_id ?? '',
      productName: item.product_name ?? '',
      categoryId: item.category_id ?? '',
      categoryName: item.category_name ?? '',
      currentStock: item.current_stock ?? 0,
      daysOfInventory: item.days_of_inventory ?? 0,
      avgDailyDemand: item.avg_daily_demand ?? 0,
      reorderPoint: item.reorder_point ?? 0,
      statusLabel: item.status_label ?? '',
      isAbnormalStock: item.is_abnormal_stock ?? false,
      isStockout: item.is_stockout ?? false,
      isCritical: item.is_critical ?? false,
      isWarning: item.is_warning ?? false,
      isOverstock: item.is_overstock ?? false,
      isDeadStock: item.is_dead_stock ?? false,
      priorityRank: item.priority_rank ?? 0,
    })),
    totalCount: response.total_count ?? 0,
    page: response.page ?? 0,
    pageSize: response.page_size ?? 20,
    hasMore: response.has_more ?? false,
  };
}
