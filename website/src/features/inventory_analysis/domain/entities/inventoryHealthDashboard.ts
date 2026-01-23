/**
 * Inventory Health Dashboard Entity
 * Domain entity for RPC response mapping
 */

// Health metrics summary
export interface InventoryHealth {
  totalProducts: number;
  abnormalCount: number;
  abnormalRate: number;
  stockoutCount: number;
  stockoutRate: number;
  criticalCount: number;
  criticalRate: number;
  warningCount: number;
  warningRate: number;
  reorderNeededCount: number;
  overstockCount: number;
  overstockRate: number;
  deadStockCount: number;
  deadStockRate: number;
  normalCount: number;
}

// Threshold configuration
export interface InventoryThresholds {
  criticalDays: number;
  warningDays: number;
  thresholdSource: string;
  sampleSize: number;
}

// Top category with health metrics
export interface TopCategory {
  categoryId: string;
  categoryName: string;
  totalProducts: number;
  abnormalCount: number;
  abnormalRate: number;
  stockoutCount: number;
  criticalCount: number;
  warningCount: number;
  overstockCount: number;
  deadStockCount: number;
}

// Abnormal product item
export interface AbnormalProduct {
  productId: string;
  productName: string;
  categoryName: string;
  currentStock: number;
  reorderPoint95: number;
}

// Urgent product item
export interface UrgentProduct {
  productId: string;
  productName: string;
  categoryName: string;
  currentStock: number;
  daysOfInventory: number | null;
  reorderPoint: number;
  statusLabel: string;
}

// Main dashboard entity
export interface InventoryHealthDashboard {
  health: InventoryHealth;
  thresholds: InventoryThresholds;
  topCategories: TopCategory[];
  abnormalProducts: AbnormalProduct[];
  urgentProducts: UrgentProduct[];
}

/**
 * Maps RPC response to domain entity
 */
export function mapInventoryHealthFromRpc(data: Record<string, unknown>): InventoryHealthDashboard {
  const healthData = data.health as Record<string, unknown> | undefined;
  const thresholdsData = data.thresholds as Record<string, unknown> | undefined;
  const topCategoriesData = data.top_categories as Array<Record<string, unknown>> | undefined;
  const abnormalProductsData = data.abnormal_products as Array<Record<string, unknown>> | undefined;
  const urgentProductsData = data.urgent_products as Array<Record<string, unknown>> | undefined;

  return {
    health: {
      totalProducts: Number(healthData?.total_products ?? 0),
      abnormalCount: Number(healthData?.abnormal_count ?? 0),
      abnormalRate: Number(healthData?.abnormal_rate ?? 0),
      stockoutCount: Number(healthData?.stockout_count ?? 0),
      stockoutRate: Number(healthData?.stockout_rate ?? 0),
      criticalCount: Number(healthData?.critical_count ?? 0),
      criticalRate: Number(healthData?.critical_rate ?? 0),
      warningCount: Number(healthData?.warning_count ?? 0),
      warningRate: Number(healthData?.warning_rate ?? 0),
      reorderNeededCount: Number(healthData?.reorder_needed_count ?? 0),
      overstockCount: Number(healthData?.overstock_count ?? 0),
      overstockRate: Number(healthData?.overstock_rate ?? 0),
      deadStockCount: Number(healthData?.dead_stock_count ?? 0),
      deadStockRate: Number(healthData?.dead_stock_rate ?? 0),
      normalCount: Number(healthData?.normal_count ?? 0),
    },
    thresholds: {
      criticalDays: Number(thresholdsData?.critical_days ?? 0),
      warningDays: Number(thresholdsData?.warning_days ?? 0),
      thresholdSource: String(thresholdsData?.threshold_source ?? ''),
      sampleSize: Number(thresholdsData?.sample_size ?? 0),
    },
    topCategories: (topCategoriesData ?? []).map((cat) => ({
      categoryId: String(cat.category_id ?? ''),
      categoryName: String(cat.category_name ?? ''),
      totalProducts: Number(cat.total_products ?? 0),
      abnormalCount: Number(cat.abnormal_count ?? 0),
      abnormalRate: Number(cat.abnormal_rate ?? 0),
      stockoutCount: Number(cat.stockout_count ?? 0),
      criticalCount: Number(cat.critical_count ?? 0),
      warningCount: Number(cat.warning_count ?? 0),
      overstockCount: Number(cat.overstock_count ?? 0),
      deadStockCount: Number(cat.dead_stock_count ?? 0),
    })),
    abnormalProducts: (abnormalProductsData ?? []).map((prod) => ({
      productId: String(prod.product_id ?? ''),
      productName: String(prod.product_name ?? ''),
      categoryName: String(prod.category_name ?? ''),
      currentStock: Number(prod.current_stock ?? 0),
      reorderPoint95: Number(prod.reorder_point_95 ?? 0),
    })),
    urgentProducts: (urgentProductsData ?? []).map((prod) => ({
      productId: String(prod.product_id ?? ''),
      productName: String(prod.product_name ?? ''),
      categoryName: String(prod.category_name ?? ''),
      currentStock: Number(prod.current_stock ?? 0),
      daysOfInventory: prod.days_of_inventory != null ? Number(prod.days_of_inventory) : null,
      reorderPoint: Number(prod.reorder_point ?? 0),
      statusLabel: String(prod.status_label ?? ''),
    })),
  };
}
