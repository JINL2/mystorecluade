/**
 * CashEndingDataSource
 * Data source for cash ending operations
 */

import { supabaseService } from '@/core/services/supabase_service';

export class CashEndingDataSource {
  async getCashLocations(companyId: string) {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase
      .from('cash_locations')
      .select('cash_location_id, store_id, location_name, location_type')
      .eq('company_id', companyId)
      .eq('is_deleted', false);

    if (error) {
      console.error('Error fetching cash locations:', error);
      throw new Error(error.message);
    }

    return data || [];
  }

  async getBalanceAndActualAmounts(companyId: string, storeId: string | null) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = {
      p_company_id: companyId,
    };

    if (storeId) {
      rpcParams.p_store_id = storeId;
    }

    const { data, error } = await supabase.rpc('get_cash_balance_amounts', rpcParams);

    if (error) {
      console.error('Error fetching balance amounts:', error);
      throw new Error(error.message);
    }

    return data;
  }
}
