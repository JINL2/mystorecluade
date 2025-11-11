/**
 * TransactionHistoryDataSource
 * Data source for transaction history operations
 */

import { supabaseService } from '@/core/services/supabase_service';

export class TransactionHistoryDataSource {
  async getTransactions(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string,
    accountId?: string | null
  ) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = {
      p_company_id: companyId,
      p_date_from: startDate,
      p_date_to: endDate,
    };

    if (storeId) {
      rpcParams.p_store_id = storeId;
    }

    if (accountId) {
      rpcParams.p_account_id = accountId;
    }

    const { data, error } = await supabase.rpc('get_transaction_history', rpcParams);

    if (error) {
      console.error('Error fetching transaction history:', error);
      throw new Error(error.message);
    }

    return data || [];
  }
}
