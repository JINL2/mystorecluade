/**
 * IncomeStatementDataSource
 * Data source for income statement operations
 * Uses get_income_statement_v3 RPC (O(1) performance via balance_sheet_logs)
 */

import { supabaseService } from '@/core/services/supabase_service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

export class IncomeStatementDataSource {
  /**
   * Get user's local timezone
   */
  private getTimezone(): string {
    return DateTimeUtils.getLocalTimezone();
  }

  /**
   * Convert YYYY-MM-DD to local timestamp string (YYYY-MM-DD HH:mm:ss)
   * For start date: use 00:00:00
   * For end date: use 23:59:59
   */
  private toLocalTimestamp(dateStr: string, isEndOfDay: boolean): string {
    // Parse the date string as local date
    const [year, month, day] = dateStr.split('-').map(Number);
    const date = new Date(year, month - 1, day);

    if (isEndOfDay) {
      date.setHours(23, 59, 59, 0);
    } else {
      date.setHours(0, 0, 0, 0);
    }

    // Format as YYYY-MM-DD HH:mm:ss (local time, no timezone suffix)
    const y = date.getFullYear();
    const m = String(date.getMonth() + 1).padStart(2, '0');
    const d = String(date.getDate()).padStart(2, '0');
    const hh = String(date.getHours()).padStart(2, '0');
    const mm = String(date.getMinutes()).padStart(2, '0');
    const ss = String(date.getSeconds()).padStart(2, '0');

    return `${y}-${m}-${d} ${hh}:${mm}:${ss}`;
  }

  /**
   * Get monthly income statement data
   * Uses: get_income_statement_v3 RPC
   *
   * @param companyId - Company UUID
   * @param storeId - Store UUID (null for all stores)
   * @param startDate - Date string in YYYY-MM-DD format (user's local date)
   * @param endDate - Date string in YYYY-MM-DD format (user's local date)
   *
   * Note: Dates are converted to local timestamps with timezone info.
   * The RPC function handles UTC conversion internally.
   */
  async getMonthlyIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) {
    const supabase = supabaseService.getClient();
    const timezone = this.getTimezone();

    const rpcParams: Record<string, unknown> = {
      p_company_id: companyId,
      p_start_time: this.toLocalTimestamp(startDate, false), // YYYY-MM-DD 00:00:00 (local)
      p_end_time: this.toLocalTimestamp(endDate, true),      // YYYY-MM-DD 23:59:59 (local)
      p_timezone: timezone,
    };

    // Only add p_store_id if it's not null
    if (storeId) {
      rpcParams.p_store_id = storeId;
    }

    console.log('📞 [DataSource] Calling get_income_statement_v3 RPC with params:', rpcParams);

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_income_statement_v3', rpcParams);

    if (error) {
      console.error('❌ [DataSource] Error fetching monthly income statement:', error);
      throw new Error(error.message);
    }

    console.log('✅ [DataSource] Monthly income statement data received:', data);
    return data;
  }

  /**
   * Get 12-month income statement data
   * Uses: get_income_statement_monthly_v2 RPC
   *
   * @param companyId - Company UUID
   * @param storeId - Store UUID (null for all stores)
   * @param startDate - Date string in YYYY-MM-DD format (user's local date)
   * @param endDate - Date string in YYYY-MM-DD format (user's local date)
   *
   * Note: Dates are converted to local timestamps with timezone info.
   * The RPC function handles UTC conversion internally.
   */
  async get12MonthIncomeStatement(
    companyId: string,
    storeId: string | null,
    startDate: string,
    endDate: string
  ) {
    const supabase = supabaseService.getClient();
    const timezone = this.getTimezone();

    const rpcParams: Record<string, unknown> = {
      p_company_id: companyId,
      p_start_time: this.toLocalTimestamp(startDate, false), // YYYY-MM-DD 00:00:00 (local)
      p_end_time: this.toLocalTimestamp(endDate, true),      // YYYY-MM-DD 23:59:59 (local)
      p_timezone: timezone,
    };

    // Only add p_store_id if it's not null
    if (storeId) {
      rpcParams.p_store_id = storeId;
    }

    console.log('📞 [DataSource] Calling get_income_statement_monthly_v2 RPC with params:', rpcParams);

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_income_statement_monthly_v2', rpcParams);

    if (error) {
      console.error('❌ [DataSource] Error fetching 12-month income statement:', error);
      throw new Error(error.message);
    }

    console.log('✅ [DataSource] 12-month income statement data received:', data);
    return data;
  }

  /**
   * Get company's base currency symbol
   * Uses get_base_currency RPC for consistency with other features
   */
  async getBaseCurrencySymbol(companyId: string): Promise<string> {
    const supabase = supabaseService.getClient();

    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    const { data, error } = await (supabase.rpc as any)('get_base_currency', {
      p_company_id: companyId,
    });

    if (error) {
      console.error('Failed to get base currency:', error.message);
      return '$'; // fallback
    }

    const response = data as {
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
    };

    return response?.base_currency?.symbol || '$';
  }
}
