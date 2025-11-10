/**
 * BalanceSheetDataSource
 * Data source for balance sheet operations
 */

import { supabaseService } from '@/core/services/supabase_service';

export class BalanceSheetDataSource {
  /**
   * Get balance sheet data with date range filters
   */
  async getBalanceSheet(
    companyId: string,
    storeId: string | null,
    startDate: string | null,
    endDate: string | null
  ) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId,
      p_start_date: startDate,
      p_end_date: endDate,
    };

    console.log('Calling get_balance_sheet RPC with params:', rpcParams);

    const { data, error } = await supabase.rpc('get_balance_sheet', rpcParams);

    if (error) {
      console.error('Error fetching balance sheet:', error);
      throw new Error(error.message);
    }

    console.log('Balance sheet data received:', data);

    return data;
  }
}
