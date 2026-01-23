/**
 * Discrepancy DataSource
 * Handles Supabase RPC calls for discrepancy overview
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  DiscrepancyOverview,
  mapDiscrepancyOverviewFromRpc,
} from '../../domain/entities/discrepancyOverview';

export interface GetDiscrepancyOverviewParams {
  companyId: string;
  period?: string;
}

export class DiscrepancyDataSource {
  async getDiscrepancyOverview(params: GetDiscrepancyOverviewParams): Promise<DiscrepancyOverview> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
    };

    if (params.period) {
      rpcParams.p_period = params.period;
    }

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_discrepancy_overview',
      rpcParams
    );

    return mapDiscrepancyOverviewFromRpc(data);
  }
}

// Singleton instance
export const discrepancyDataSource = new DiscrepancyDataSource();
