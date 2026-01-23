/**
 * CategoryDetail DataSource
 * Handles Supabase RPC calls for category detail
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  CategoryDetail,
  mapCategoryDetailFromRpc,
} from '../../domain/entities/categoryDetail';

export interface GetCategoryDetailParams {
  companyId: string;
  categoryId: string;
  month: string; // YYYY-MM format
}

export class CategoryDetailDataSource {
  async getCategoryDetail(params: GetCategoryDetailParams): Promise<CategoryDetail> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
      p_category_id: params.categoryId,
      p_month: params.month,
    };

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_category_detail',
      rpcParams
    );

    return mapCategoryDetailFromRpc(data);
  }
}

// Singleton instance
export const categoryDetailDataSource = new CategoryDetailDataSource();
