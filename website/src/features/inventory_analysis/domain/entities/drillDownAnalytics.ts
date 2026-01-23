/**
 * DrillDownAnalytics Entity
 * Domain entity for drill down analytics RPC response
 */

// Drill down level
export type DrillDownLevel = 'category' | 'brand' | 'product';

// Item type
export type DrillDownItemType = 'category' | 'brand' | 'product';

// Individual drill down item
export interface DrillDownItem {
  itemId: string;
  itemName: string;
  itemType: DrillDownItemType;
  totalQuantity: number;
  totalRevenue: number;
  totalMargin: number;
  marginRate: number;
  hasChildren: boolean;
}

// Success response
export interface DrillDownAnalyticsSuccess {
  success: true;
  level: DrillDownLevel;
  parentId: string | null;
  timezone: string;
  data: DrillDownItem[];
}

// Error response
export interface DrillDownAnalyticsError {
  success: false;
  error: string;
  detail: string;
}

// Union type
export type DrillDownAnalytics = DrillDownAnalyticsSuccess | DrillDownAnalyticsError;

// RPC response types
interface DrillDownItemRpc {
  item_id: string;
  item_name: string;
  item_type: string;
  total_quantity: number;
  total_revenue: number;
  total_margin: number;
  margin_rate: number;
  has_children: boolean;
}

interface DrillDownAnalyticsSuccessRpc {
  success: true;
  level: string;
  parent_id: string | null;
  timezone: string;
  data: DrillDownItemRpc[];
}

interface DrillDownAnalyticsErrorRpc {
  success: false;
  error: string;
  detail: string;
}

type DrillDownAnalyticsRpc = DrillDownAnalyticsSuccessRpc | DrillDownAnalyticsErrorRpc;

/**
 * Map RPC response to domain entity
 */
export function mapDrillDownAnalyticsFromRpc(data: unknown): DrillDownAnalytics {
  const response = data as DrillDownAnalyticsRpc;

  if (!response.success) {
    return {
      success: false,
      error: response.error ?? 'Unknown error',
      detail: response.detail ?? '',
    };
  }

  return {
    success: true,
    level: (response.level ?? 'category') as DrillDownLevel,
    parentId: response.parent_id ?? null,
    timezone: response.timezone ?? 'Asia/Ho_Chi_Minh',
    data: (response.data ?? []).map((item) => ({
      itemId: item.item_id ?? '',
      itemName: item.item_name ?? '',
      itemType: (item.item_type ?? 'category') as DrillDownItemType,
      totalQuantity: item.total_quantity ?? 0,
      totalRevenue: item.total_revenue ?? 0,
      totalMargin: item.total_margin ?? 0,
      marginRate: item.margin_rate ?? 0,
      hasChildren: item.has_children ?? false,
    })),
  };
}
