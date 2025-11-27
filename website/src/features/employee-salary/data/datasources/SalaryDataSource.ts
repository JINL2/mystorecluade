/**
 * Salary Data Source
 * Data layer - Handles Supabase RPC calls for salary data
 */

import { supabaseService } from '@/core/services/supabase_service';

export interface SalaryEmployeeRaw {
  user_id: string;
  user_name: string;
  email: string;
  role_name?: string;
  salary_type: 'monthly' | 'hourly';
  currency_info: {
    currency_symbol: string;
    currency_code: string;
  };
  salary_info: {
    total_payment: number;
    salary_type: 'monthly' | 'hourly';
    base_info: {
      monthly_salary?: number;
      base_payment?: number;
      worked_hours?: number;
      hourly_rate?: number;
    };
    deductions?: {
      late_deduction_amount?: number;
      late_count?: number;
      late_minutes?: number;
    };
    bonuses?: {
      bonus_amount?: number;
    };
    overtime?: {
      overtime_amount?: number;
      overtime_count?: number;
    };
  };
  stores?: Array<{
    store_id: string;
    store_name: string;
    store_total_payment: number;
    worked_hours?: number;
    base_payment?: number;
    late_deduction?: number;
    bonus_amount?: number;
    overtime_amount?: number;
  }>;
  problems?: {
    problem_details?: Array<{
      date: string;
      problem_type: string;
      store_id?: string;
      store_name?: string;
      is_solved: boolean;
    }>;
    late_dates?: Array<{
      date: string;
      late_minutes: number;
    }>;
  };
  payment_date?: string | null;
  status?: 'pending' | 'paid' | 'processing';
}

export interface SalaryRawData {
  period: string;
  employees: SalaryEmployeeRaw[];
  summary: {
    total_employees: number;
    total_salary?: number;
    total_payment?: number;
    total_base_payment?: number;
    average_salary: number;
    total_bonuses: number;
    total_deductions: number;
    unsolved_problems?: number;
    total_problems?: number;
    employee_breakdown?: {
      monthly: number;
      hourly: number;
    };
    base_currency: {
      currency_symbol: string;
      currency_code: string;
    };
  };
}

export class SalaryDataSource {
  /**
   * Get user's timezone
   */
  private getUserTimezone(): string {
    return Intl.DateTimeFormat().resolvedOptions().timeZone;
  }

  /**
   * Fetch salary data from Supabase RPC
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   */
  async getSalaryData(
    companyId: string,
    month: string
  ): Promise<{ success: boolean; data?: SalaryRawData; error?: string }> {
    try {
      const supabase = supabaseService.getClient();
      const timezone = this.getUserTimezone();

      const { data, error } = await supabase.rpc('get_employee_salary_v2', {
        p_company_id: companyId,
        p_month: month,
        p_timezone: timezone,
      });

      if (error) {
        console.error('Salary RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to fetch salary data',
        };
      }

      if (!data) {
        return {
          success: false,
          error: 'No data returned from salary query',
        };
      }

      return {
        success: true,
        data: data as unknown as SalaryRawData,
      };
    } catch (error) {
      console.error('Salary datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }

  /**
   * Export salary data to Excel via RPC
   * @param companyId - Company identifier
   * @param month - Month in YYYY-MM format
   */
  async exportToExcel(
    companyId: string,
    month: string
  ): Promise<{ success: boolean; data?: any; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      const { data, error } = await supabase.rpc('get_employee_salary_excel', {
        p_company_id: companyId,
        p_request_month: month,
      });

      if (error) {
        console.error('Salary Excel RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to export salary data',
        };
      }

      return {
        success: true,
        data,
      };
    } catch (error) {
      console.error('Salary Excel export error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
