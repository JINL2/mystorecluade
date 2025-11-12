/**
 * Dashboard Data Source
 * Data layer - Handles Supabase RPC calls for dashboard
 * Uses centralized message constants for error handling
 */

import { supabaseService } from '@/core/services/supabase_service';
import { DashboardMessages } from '../../domain/constants/DashboardMessages';

export interface DashboardRawData {
  today_revenue: number;
  today_expense: number;
  this_month_revenue: number;
  last_month_revenue: number;
  currency: {
    currency_id?: string;
    symbol: string;
    currency_code: string;
  };
  expense_breakdown: Array<{
    category: string;
    amount: number;
    percentage: number;
  }>;
  recent_transactions: Array<{
    journal_id: string;
    entry_date: string;
    created_at: string;
    description: string | null;
    total_amount: number;
    lines: Array<{
      account_name: string;
      account_type: 'asset' | 'liability' | 'equity' | 'income' | 'expense';
      debit: number;
      credit: number;
      description: string | null;
    }>;
  }>;
}

export class DashboardDataSource {
  /**
   * Fetch dashboard data from Supabase RPC
   * @param companyId - Company identifier
   * @param date - Date in ISO format
   */
  async getDashboardData(
    companyId: string,
    date: string
  ): Promise<{ success: boolean; data?: DashboardRawData; error?: string }> {
    try {
      console.log(DashboardMessages.technical.rpcDebugFetch({ companyId, date }));
      const supabase = supabaseService.getClient();

      const { data, error } = await supabase.rpc('get_dashboard_page', {
        p_company_id: companyId,
        p_date: date,
      });

      console.log(DashboardMessages.technical.rpcDebugResponse(data, error));

      if (error) {
        console.error(DashboardMessages.technical.rpcDebugError(error));
        return {
          success: false,
          error: error.message || DashboardMessages.errors.rpcFailed,
        };
      }

      if (!data) {
        console.warn(DashboardMessages.technical.rpcDebugNoData);
        return {
          success: false,
          error: DashboardMessages.errors.noDataReturned,
        };
      }

      console.log(DashboardMessages.technical.rpcDebugSuccess);
      return {
        success: true,
        data: data as DashboardRawData,
      };
    } catch (error) {
      console.error(DashboardMessages.technical.datasourceError(error));
      return {
        success: false,
        error: error instanceof Error ? error.message : DashboardMessages.errors.unknownError,
      };
    }
  }
}
