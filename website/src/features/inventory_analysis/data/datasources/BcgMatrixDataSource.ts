/**
 * BcgMatrix DataSource
 * Handles Supabase RPC calls for BCG Matrix V2
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  BcgMatrix,
  mapBcgMatrixFromRpc,
} from '../../domain/entities/bcgMatrix';

export interface GetBcgMatrixParams {
  companyId: string;
  storeId?: string;
  startDate: string;  // YYYY-MM-DD format
  endDate: string;    // YYYY-MM-DD format
}

export class BcgMatrixDataSource {
  async getBcgMatrix(params: GetBcgMatrixParams): Promise<BcgMatrix> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_start_date: params.startDate,
      p_end_date: params.endDate,
    };

    if (params.storeId) {
      rpcParams.p_store_id = params.storeId;
    }

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_bcg_matrix_v2',
      rpcParams
    );

    return mapBcgMatrixFromRpc(data);
  }
}

// Singleton instance
export const bcgMatrixDataSource = new BcgMatrixDataSource();
