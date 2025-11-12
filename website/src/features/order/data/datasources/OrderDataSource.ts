/**
 * OrderDataSource
 * Data source for order operations
 */

import { supabaseService } from '@/core/services/supabase_service';
import { getCurrencySymbol } from '@/core/utils/formatters';

export interface CompanyCurrency {
  currency_id: string;
  currency_code: string;
  currency_symbol: string;
}

export class OrderDataSource {
  async getOrders(companyId: string, storeId: string | null) {
    const supabase = supabaseService.getClient();

    // RPC function only accepts p_company_id parameter
    // Store filtering is handled within the RPC function
    const { data, error } = await supabase.rpc('get_inventory_order_list', {
      p_company_id: companyId
    });

    if (error) {
      console.error('Error fetching orders:', error);
      throw new Error(error.message);
    }

    // RPC returns { orders: [...] }
    return data?.orders || [];
  }

  /**
   * Fetch company currency following backup pattern
   * Steps: companies.base_currency_id → currency_types.currency_code → symbol
   */
  async getCompanyCurrency(companyId: string): Promise<CompanyCurrency | null> {
    if (!companyId) {
      return null;
    }

    try {
      const supabase = supabaseService.getClient();

      // Step 1: Fetch company's base_currency_id
      const { data: companyData, error: companyError } = await supabase
        .from('companies')
        .select('base_currency_id')
        .eq('company_id', companyId)
        .single();

      if (companyError || !companyData || !companyData.base_currency_id) {
        return null;
      }

      // Step 2: Fetch currency details from currency_types
      const { data: currencyData, error: currencyError } = await supabase
        .from('currency_types')
        .select('currency_id, currency_code')
        .eq('currency_id', companyData.base_currency_id)
        .single();

      if (currencyError || !currencyData) {
        return null;
      }

      // Step 3: Convert currency code to symbol
      return {
        currency_id: currencyData.currency_id,
        currency_code: currencyData.currency_code,
        currency_symbol: getCurrencySymbol(currencyData.currency_code),
      };
    } catch (err) {
      console.error('Error fetching company currency:', err);
      return null;
    }
  }
}
