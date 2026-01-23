/**
 * SupplyChain DataSource
 * Handles Supabase RPC calls for supply chain status
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  SupplyChainStatus,
  mapSupplyChainStatusFromRpc,
} from '../../domain/entities/supplyChainStatus';

export interface GetSupplyChainStatusParams {
  companyId: string;
}

export class SupplyChainDataSource {
  async getSupplyChainStatus(params: GetSupplyChainStatusParams): Promise<SupplyChainStatus> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
    };

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_supply_chain_status',
      rpcParams
    );

    return mapSupplyChainStatusFromRpc(data);
  }
}

// Singleton instance
export const supplyChainDataSource = new SupplyChainDataSource();
