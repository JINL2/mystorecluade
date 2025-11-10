/**
 * Dashboard Data Source
 * Data layer - Handles Supabase RPC calls for dashboard
 */

import { supabaseService } from '@/core/services/supabase_service';

export interface DashboardRawData {
  today_revenue: number;
  today_expense: number;
  this_month_revenue: number;
  last_month_revenue: number;
  currency: {
    symbol: string;
    currency_code: string;
  };
  expense_breakdown: Array<{
    category: string;
    amount: number;
    percentage: number;
  }>;
  recent_transactions: Array<{
    id: string;
    date: string;
    description: string;
    amount: number;
    type: 'income' | 'expense';
    category?: string;
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
      console.log('📊 Fetching dashboard data for:', { companyId, date });
      const supabase = supabaseService.getClient();

      const { data, error } = await supabase.rpc('get_dashboard_page', {
        p_company_id: companyId,
        p_date: date,
      });

      console.log('📦 Dashboard RPC Response:', { data, error });

      if (error) {
        console.error('❌ Dashboard RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to fetch dashboard data',
        };
      }

      if (!data) {
        console.warn('⚠️ No data returned from dashboard RPC');
        return {
          success: false,
          error: 'No data returned from dashboard',
        };
      }

      console.log('✅ Dashboard data fetched successfully');
      return {
        success: true,
        data: data as DashboardRawData,
      };
    } catch (error) {
      console.error('💥 Dashboard datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
