/**
 * IncomeStatementDataSource
 * Data source for income statement operations
 */

import { supabaseService } from '@/core/services/supabase_service';

export class IncomeStatementDataSource {
  /**
   * Get monthly income statement data
   * Uses: get_income_statement_v2 RPC
   *
   * @param startDate - Date string in YYYY-MM-DD format (date-only, no timezone conversion)
   * @param endDate - Date string in YYYY-MM-DD format (date-only, no timezone conversion)
   *
   * Note: Since we're passing date-only strings (YYYY-MM-DD) for financial period queries,
   * no timezone conversion is needed. The RPC function should use these as date boundaries.
   */
  async getMonthlyIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId || null,
      p_start_date: startDate, // YYYY-MM-DD format (no time component)
      p_end_date: endDate,     // YYYY-MM-DD format (no time component)
    };

    console.log('📞 [DataSource] Calling get_income_statement_v2 RPC with params:', rpcParams);

    const { data, error } = await supabase.rpc('get_income_statement_v2', rpcParams);

    if (error) {
      console.error('❌ [DataSource] Error fetching monthly income statement:', error);
      throw new Error(error.message);
    }

    console.log('✅ [DataSource] Monthly income statement data received:', data);
    return data;
  }

  /**
   * Get 12-month income statement data
   * Uses: get_income_statement_monthly RPC
   *
   * @param startDate - Date string in YYYY-MM-DD format (date-only, no timezone conversion)
   * @param endDate - Date string in YYYY-MM-DD format (date-only, no timezone conversion)
   *
   * Note: Since we're passing date-only strings (YYYY-MM-DD) for financial period queries,
   * no timezone conversion is needed. The RPC function should use these as date boundaries.
   */
  async get12MonthIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) {
    const supabase = supabaseService.getClient();

    const rpcParams: any = {
      p_company_id: companyId,
      p_store_id: storeId || null,
      p_start_date: startDate, // YYYY-MM-DD format (no time component)
      p_end_date: endDate,     // YYYY-MM-DD format (no time component)
    };

    console.log('📞 [DataSource] Calling get_income_statement_monthly RPC with params:', rpcParams);

    const { data, error } = await supabase.rpc('get_income_statement_monthly', rpcParams);

    if (error) {
      console.error('❌ [DataSource] Error fetching 12-month income statement:', error);
      throw new Error(error.message);
    }

    console.log('✅ [DataSource] 12-month income statement data received:', data);
    return data;
  }

  /**
   * Get company currency information
   */
  async getCompanyCurrency(companyId: string): Promise<string> {
    const supabase = supabaseService.getClient();

    try {
      // Query companies table to get base_currency_id
      const { data: companyData, error: companyError } = await supabase
        .from('companies')
        .select('base_currency_id')
        .eq('company_id', companyId)
        .single();

      if (companyError || !companyData?.base_currency_id) {
        console.log('No base currency found, using default');
        return '$';
      }

      // Query currency_types table to get currency symbol
      const { data: currencyData, error: currencyError } = await supabase
        .from('currency_types')
        .select('currency_code, currency_name, symbol')
        .eq('currency_id', companyData.base_currency_id)
        .single();

      if (currencyError || !currencyData?.symbol) {
        console.log('No currency symbol found, using default');
        return '$';
      }

      console.log('Using company currency:', currencyData);
      return currencyData.symbol;
    } catch (error) {
      console.error('Error in getCompanyCurrency:', error);
      return '$';
    }
  }
}
