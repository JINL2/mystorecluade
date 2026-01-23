/**
 * SalesAnalytics DataSource
 * Handles Supabase RPC calls for sales analytics
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  SalesAnalytics,
  SalesGroupBy,
  SalesDimension,
  SalesMetric,
  OrderDirection,
  mapSalesAnalyticsFromRpc,
} from '../../domain/entities/salesAnalytics';

export interface GetSalesAnalyticsParams {
  companyId: string;
  storeId?: string;
  startDate: string;
  endDate: string;
  groupBy: SalesGroupBy;
  dimension: SalesDimension;
  metric: SalesMetric;
  categoryId?: string;
  comparePrevious?: boolean;
  orderBy?: OrderDirection;
  topN?: number;
}

export class SalesAnalyticsDataSource {
  async getSalesAnalytics(params: GetSalesAnalyticsParams): Promise<SalesAnalytics> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_start_date: params.startDate,
      p_end_date: params.endDate,
      p_group_by: params.groupBy,
      p_dimension: params.dimension,
      p_metric: params.metric,
      p_compare_previous: params.comparePrevious ?? true,
      p_order_by: params.orderBy ?? 'DESC',
    };

    if (params.storeId) {
      rpcParams.p_store_id = params.storeId;
    }

    if (params.categoryId) {
      rpcParams.p_category_id = params.categoryId;
    }

    if (params.topN !== undefined) {
      rpcParams.p_top_n = params.topN;
    }

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_sales_analytics',
      rpcParams
    );

    return mapSalesAnalyticsFromRpc(data);
  }
}

// Singleton instance
export const salesAnalyticsDataSource = new SalesAnalyticsDataSource();
