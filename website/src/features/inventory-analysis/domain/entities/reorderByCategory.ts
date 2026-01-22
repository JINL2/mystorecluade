/**
 * ReorderByCategory Entity
 * Domain entity for reorder by category RPC response
 */

// Category reorder summary item
export interface CategoryReorderItem {
  categoryId: string;
  categoryName: string;
  totalProducts: number;
  abnormalCount: number;
  stockoutCount: number;
  criticalCount: number;
  warningCount: number;
  reorderNeededCount: number;
  overstockCount: number;
  deadStockCount: number;
  reorderRate: number;
}

// RPC response type
interface CategoryReorderItemRpc {
  category_id: string;
  category_name: string;
  total_products: number;
  abnormal_count: number;
  stockout_count: number;
  critical_count: number;
  warning_count: number;
  reorder_needed_count: number;
  overstock_count: number;
  dead_stock_count: number;
  reorder_rate: number;
}

/**
 * Map RPC response to domain entity
 */
export function mapReorderByCategoryFromRpc(data: unknown): CategoryReorderItem[] {
  const response = data as CategoryReorderItemRpc[];

  if (!Array.isArray(response)) {
    return [];
  }

  return response.map((item) => ({
    categoryId: item.category_id ?? '',
    categoryName: item.category_name ?? '',
    totalProducts: item.total_products ?? 0,
    abnormalCount: item.abnormal_count ?? 0,
    stockoutCount: item.stockout_count ?? 0,
    criticalCount: item.critical_count ?? 0,
    warningCount: item.warning_count ?? 0,
    reorderNeededCount: item.reorder_needed_count ?? 0,
    overstockCount: item.overstock_count ?? 0,
    deadStockCount: item.dead_stock_count ?? 0,
    reorderRate: item.reorder_rate ?? 0,
  }));
}
