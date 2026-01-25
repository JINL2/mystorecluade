/**
 * BaseCurrency DataSource
 * Handles Supabase RPC calls for base currency info
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  BaseCurrencyResponse,
  mapBaseCurrencyFromRpc,
} from '../../domain/entities/baseCurrency';

export interface GetBaseCurrencyParams {
  companyId: string;
}

export class BaseCurrencyDataSource {
  async getBaseCurrency(params: GetBaseCurrencyParams): Promise<BaseCurrencyResponse> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
    };

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_base_currency',
      rpcParams
    );

    return mapBaseCurrencyFromRpc(data);
  }
}

// Singleton instance
export const baseCurrencyDataSource = new BaseCurrencyDataSource();
