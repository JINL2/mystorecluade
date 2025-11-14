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
      const supabase = supabaseService.getClient();

      const { data, error } = await supabase.rpc('get_dashboard_page', {
        p_company_id: companyId,
        p_date: date,
      });

      if (error) {
        // Log only actual errors, not debug info
        console.error('Dashboard RPC error:', error.message);
        return {
          success: false,
          error: error.message || DashboardMessages.errors.rpcFailed,
        };
      }

      if (!data) {
        return {
          success: false,
          error: DashboardMessages.errors.noDataReturned,
        };
      }

      return {
        success: true,
        data: data as DashboardRawData,
      };
    } catch (error) {
      // Log only critical errors
      console.error('Dashboard datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : DashboardMessages.errors.unknownError,
      };
    }
  }
}
