/**
 * DrillDownAnalytics DataSource
 * Handles Supabase RPC calls for drill down analytics
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  DrillDownAnalytics,
  DrillDownLevel,
  mapDrillDownAnalyticsFromRpc,
} from '../../domain/entities/drillDownAnalytics';

export interface GetDrillDownAnalyticsParams {
  companyId: string;
  storeId?: string;
  startDate: string;
  endDate: string;
  level: DrillDownLevel;
  parentId?: string;
}

export class DrillDownAnalyticsDataSource {
  async getDrillDownAnalytics(params: GetDrillDownAnalyticsParams): Promise<DrillDownAnalytics> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_start_date: params.startDate,
      p_end_date: params.endDate,
      p_level: params.level,
    };

    if (params.storeId) {
      rpcParams.p_store_id = params.storeId;
    }

    if (params.parentId) {
      rpcParams.p_parent_id = params.parentId;
    }

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_drill_down_analytics',
      rpcParams
    );

    return mapDrillDownAnalyticsFromRpc(data);
  }
}

// Singleton instance
export const drillDownAnalyticsDataSource = new DrillDownAnalyticsDataSource();
