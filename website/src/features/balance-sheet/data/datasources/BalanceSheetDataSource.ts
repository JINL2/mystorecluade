/**
 * BalanceSheetDataSource
 * Data source for balance sheet operations
 * Uses get_balance_sheet_v2 RPC (O(1) performance via balance_sheet_logs)
 */

import { supabaseService } from '@/core/services/supabase_service';

export class BalanceSheetDataSource {
  /**
   * Get balance sheet data filtered by store
   * Uses get_balance_sheet_v2 - faster O(1) lookup from balance_sheet_logs
   */
  async getBalanceSheet(companyId: string, storeId: string | null) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
    };

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_balance_sheet_v2', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    return data;
  }
}
