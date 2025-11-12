/**
 * CashEndingDataSource
 * Data source for cash ending operations
 */

import { supabaseService } from '@/core/services/supabase_service';

interface JournalLine {
  account_id: string;
  description: string;
  debit: number;
  credit: number;
  cash?: {
    cash_location_id: string;
  };
}

interface CreateJournalRpcParams {
  p_base_amount: number;
  p_company_id: string;
  p_created_by: string;
  p_description: string;
  p_entry_date: string;
  p_lines: JournalLine[];
  p_store_id: string;
}

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

  async createJournalEntry(params: CreateJournalRpcParams): Promise<{ success: boolean; data?: any; error?: string }> {
    try {
      const supabase = supabaseService.getClient();
      if (!supabase) {
        return {
          success: false,
          error: 'Supabase client not available'
        };
      }

      const { data, error } = await supabase
        .rpc('insert_journal_with_everything', params);

      if (error) {
        console.error('RPC Error:', error);
        return {
          success: false,
          error: error.message || 'Failed to create journal entry'
        };
      }

      return {
        success: true,
        data
      };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Unknown error occurred';
      console.error('Error in createJournalEntry:', err);
      return {
        success: false,
        error: errorMessage
      };
    }
  }
}
