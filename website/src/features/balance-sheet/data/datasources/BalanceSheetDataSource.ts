/**
 * BalanceSheetDataSource
 * Data source for balance sheet operations
 * Uses get_balance_sheet_v3 RPC (account_code based section classification)
 */

import { supabaseService } from '@/core/services/supabase_service';

/**
 * Raw row returned from get_balance_sheet_v3 RPC
 */
export interface BalanceSheetV3Row {
  section: string;
  section_order: number;
  account_code: string;
  account_name: string;
  balance: string; // numeric comes as string from Supabase
}

/**
 * Currency info from get_base_currency RPC
 */
export interface BaseCurrencyResponse {
  base_currency: {
    currency_id: string;
    currency_code: string;
    currency_name: string;
    symbol: string;
    flag_emoji: string;
  };
  company_currencies: Array<{
    currency_id: string;
    currency_code: string;
    symbol: string;
  }>;
}

export class BalanceSheetDataSource {
  /**
   * Get balance sheet data filtered by store
   * Uses get_balance_sheet_v3 - account_code based classification
   */
  async getBalanceSheet(
    companyId: string,
    storeId: string | null,
    asOfDate?: string
  ): Promise<BalanceSheetV3Row[]> {
    const supabase = supabaseService.getClient();

    const rpcParams: Record<string, unknown> = {
      p_company_id: companyId,
      p_as_of_date: asOfDate || new Date().toISOString().split('T')[0],
      p_store_id: storeId,
    };

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_balance_sheet_v3', rpcParams);

    if (error) {
      throw new Error(error.message);
    }

    return (data || []) as BalanceSheetV3Row[];
  }

  /**
   * Get company's base currency symbol
   * Uses get_base_currency RPC
   */
  async getBaseCurrencySymbol(companyId: string): Promise<string> {
    const supabase = supabaseService.getClient();

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Failed to get base currency:', error.message);
      return '₫'; // fallback
    }

    const response = data as BaseCurrencyResponse;
    return response?.base_currency?.symbol || '₫';
  }
}
