/**
 * SaleProductDataSource
 * Handles RPC calls for sale product feature
 */

import { supabaseService } from '@/core/services/supabase_service';

export class SaleProductDataSource {
  /**
   * Get inventory products for sale
   * Calls get_inventory_page RPC function
   */
  async getProducts(
    companyId: string,
    storeId: string,
    page: number = 1,
    limit: number = 100,
    search?: string
  ) {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_inventory_page', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_page: page,
      p_limit: limit,
      p_search: search || null,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data;
  }

  /**
   * Get base currency for a company
   * Calls get_base_currency RPC function
   */
  async getBaseCurrency(companyId: string): Promise<{
    symbol: string;
    code: string;
  }> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    // Extract base_currency from response
    if (data && data.base_currency) {
      return {
        symbol: data.base_currency.symbol || '₫',
        code: data.base_currency.currency_code || 'VND',
      };
    }

    // Fallback to VND if no base currency found
    return {
      symbol: '₫',
      code: 'VND',
    };
  }

  /**
   * Get exchange rates for a company
   * Calls get_exchange_rate_v2 RPC function
   */
  async getExchangeRates(companyId: string): Promise<{
    base_currency: {
      currency_id: string;
      currency_code: string;
      currency_name: string;
      symbol: string;
    };
    exchange_rates: Array<{
      currency_id: string;
      currency_code: string;
      currency_name: string;
      symbol: string;
      rate: number;
    }>;
  }> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_exchange_rate_v2', {
      p_company_id: companyId,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data;
  }

  /**
   * Get cash locations for a company and store
   * Calls get_cash_locations RPC function
   */
  async getCashLocations(companyId: string, storeId: string | null): Promise<Array<{
    id: string;
    name: string;
    type: 'cash' | 'bank' | 'vault';
    storeId: string | null;
    isCompanyWide: boolean;
    isDeleted: boolean;
    currencyCode: string | null;
    bankAccount: string | null;
    bankName: string | null;
    locationInfo: string;
    transactionCount: number;
    additionalData: {
      cash_location_id: string;
      company_id: string;
      store_id: string | null;
      location_name: string;
      location_type: string;
      location_info: string;
      currency_code: string | null;
      bank_account: string | null;
      bank_name: string | null;
      is_deleted: boolean;
      deleted_at: string | null;
      created_at: string;
    };
  }>> {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_cash_locations', {
      p_company_id: companyId,
      p_store_id: storeId,
      p_location_type: null,
    });

    if (error) {
      throw new Error(error.message);
    }

    return data || [];
  }
}
