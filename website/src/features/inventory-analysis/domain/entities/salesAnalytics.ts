/**
 * SalesAnalytics Entity
 * Domain entity for sales analytics RPC response
 */

// Group by options
export type SalesGroupBy = 'daily' | 'weekly' | 'monthly' | 'total';

// Dimension options
export type SalesDimension = 'total' | 'category' | 'brand' | 'product';

// Metric options for sorting
export type SalesMetric = 'revenue' | 'quantity' | 'margin';

// Order direction
export type OrderDirection = 'ASC' | 'DESC';

// Analytics params
export interface SalesAnalyticsParams {
  startDate: string;
  endDate: string;
  groupBy: SalesGroupBy;
  dimension: SalesDimension;
  metric: SalesMetric;
  categoryId: string | null;
  timezone: string;
}

// Summary data
export interface SalesAnalyticsSummary {
  totalRevenue: number;
  totalQuantity: number;
  totalMargin: number;
  avgMarginRate: number;
  recordCount: number;
}

// Individual data item
export interface SalesAnalyticsItem {
  period: string;
  dimensionId: string;
  dimensionName: string;
  totalQuantity: number;
  totalRevenue: number;
  totalMargin: number;
  marginRate: number;
  invoiceCount: number;
  revenueGrowth: number | null;
  quantityGrowth: number | null;
  marginGrowth: number | null;
}

// Success response
export interface SalesAnalyticsSuccess {
  success: true;
  params: SalesAnalyticsParams;
  summary: SalesAnalyticsSummary;
  data: SalesAnalyticsItem[];
}

// Error response
export interface SalesAnalyticsError {
  success: false;
  error: string;
  detail: string;
}

// Union type
export type SalesAnalytics = SalesAnalyticsSuccess | SalesAnalyticsError;

// RPC response types
interface SalesAnalyticsParamsRpc {
  start_date: string;
  end_date: string;
  group_by: string;
  dimension: string;
  metric: string;
  category_id: string | null;
  timezone: string;
}

interface SalesAnalyticsSummaryRpc {
  total_revenue: number;
  total_quantity: number;
  total_margin: number;
  avg_margin_rate: number;
  record_count: number;
}

interface SalesAnalyticsItemRpc {
  period: string;
  dimension_id: string;
  dimension_name: string;
  total_quantity: number;
  total_revenue: number;
  total_margin: number;
  margin_rate: number;
  invoice_count: number;
  revenue_growth: number | null;
  quantity_growth: number | null;
  margin_growth: number | null;
}

interface SalesAnalyticsSuccessRpc {
  success: true;
  params: SalesAnalyticsParamsRpc;
  summary: SalesAnalyticsSummaryRpc;
  data: SalesAnalyticsItemRpc[];
}

interface SalesAnalyticsErrorRpc {
  success: false;
  error: string;
  detail: string;
}

type SalesAnalyticsRpc = SalesAnalyticsSuccessRpc | SalesAnalyticsErrorRpc;

/**
 * Map RPC response to domain entity
 */
export function mapSalesAnalyticsFromRpc(data: unknown): SalesAnalytics {
  const response = data as SalesAnalyticsRpc;

  if (!response.success) {
    return {
      success: false,
      error: response.error ?? 'Unknown error',
      detail: response.detail ?? '',
    };
  }

  return {
    success: true,
    params: {
      startDate: response.params?.start_date ?? '',
      endDate: response.params?.end_date ?? '',
      groupBy: (response.params?.group_by ?? 'monthly') as SalesGroupBy,
      dimension: (response.params?.dimension ?? 'total') as SalesDimension,
      metric: (response.params?.metric ?? 'revenue') as SalesMetric,
      categoryId: response.params?.category_id ?? null,
      timezone: response.params?.timezone ?? 'Asia/Ho_Chi_Minh',
    },
    summary: {
      totalRevenue: response.summary?.total_revenue ?? 0,
      totalQuantity: response.summary?.total_quantity ?? 0,
      totalMargin: response.summary?.total_margin ?? 0,
      avgMarginRate: response.summary?.avg_margin_rate ?? 0,
      recordCount: response.summary?.record_count ?? 0,
    },
    data: (response.data ?? []).map((item) => ({
      period: item.period ?? '',
      dimensionId: item.dimension_id ?? '',
      dimensionName: item.dimension_name ?? '',
      totalQuantity: item.total_quantity ?? 0,
      totalRevenue: item.total_revenue ?? 0,
      totalMargin: item.total_margin ?? 0,
      marginRate: item.margin_rate ?? 0,
      invoiceCount: item.invoice_count ?? 0,
      revenueGrowth: item.revenue_growth,
      quantityGrowth: item.quantity_growth,
      marginGrowth: item.margin_growth,
    })),
  };
}
