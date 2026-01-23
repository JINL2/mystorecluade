/**
 * ReorderProductsPaged DataSource
 * Handles Supabase RPC calls for reorder products with pagination
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  ReorderProductsPaged,
  ReorderStatusFilter,
  mapReorderProductsPagedFromRpc,
} from '../../domain/entities/reorderProductsPaged';

export interface GetReorderProductsPagedParams {
  companyId: string;
  categoryId?: string;
  statusFilter?: ReorderStatusFilter;
  page?: number;
  pageSize?: number;
}

export class ReorderProductsPagedDataSource {
  async getReorderProductsPaged(params: GetReorderProductsPagedParams): Promise<ReorderProductsPaged> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_page: params.page ?? 0,
      p_page_size: params.pageSize ?? 20,
    };

    if (params.categoryId) {
      rpcParams.p_category_id = params.categoryId;
    }

    if (params.statusFilter) {
      rpcParams.p_status_filter = params.statusFilter;
    }

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_reorder_products_paged',
      rpcParams
    );

    return mapReorderProductsPagedFromRpc(data);
  }
}

// Singleton instance
export const reorderProductsPagedDataSource = new ReorderProductsPagedDataSource();
