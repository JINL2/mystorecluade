/**
 * SalesDashboardDataSource
 * Handles Supabase RPC calls for sales dashboard
 */

import { supabaseService } from '@/core/services/supabase.service';
import { mapSalesDashboardFromRpc, type SalesDashboard } from '../../domain/entities/salesDashboard';

export interface GetSalesDashboardParams {
  companyId: string;
  storeId?: string;
}

export class SalesDashboardDataSource {
  /**
   * Get sales dashboard data
   * RPC: get_sales_dashboard
   */
  async getSalesDashboard(params: GetSalesDashboardParams): Promise<SalesDashboard> {
    const rpcParams: Record<string, string> = {
      p_company_id: params.companyId,
    };

    if (params.storeId) {
      rpcParams.p_store_id = params.storeId;
    }

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_sales_dashboard',
      rpcParams
    );

    if (!data) {
      throw new Error('No data returned from get_sales_dashboard');
    }

    return mapSalesDashboardFromRpc(data);
  }
}

export const salesDashboardDataSource = new SalesDashboardDataSource();
