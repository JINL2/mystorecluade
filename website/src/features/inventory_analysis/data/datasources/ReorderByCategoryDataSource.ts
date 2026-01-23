/**
 * ReorderByCategory DataSource
 * Handles Supabase RPC calls for reorder by category
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  CategoryReorderItem,
  mapReorderByCategoryFromRpc,
} from '../../domain/entities/reorderByCategory';

export interface GetReorderByCategoryParams {
  companyId: string;
}

export class ReorderByCategoryDataSource {
  async getReorderByCategory(params: GetReorderByCategoryParams): Promise<CategoryReorderItem[]> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
    };

    const data = await supabaseService.rpc<unknown[]>(
      'get_reorder_by_category',
      rpcParams
    );

    return mapReorderByCategoryFromRpc(data);
  }
}

// Singleton instance
export const reorderByCategoryDataSource = new ReorderByCategoryDataSource();
