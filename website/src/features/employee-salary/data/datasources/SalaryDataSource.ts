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

export interface SalaryExcelRow {
  shift_request_id: string | null;
  user_id: string;
  first_name: string | null;
  last_name: string | null;
  user_name: string;
  user_email: string;
  user_bank_name: string | null;
  user_account_number: string | null;
  store_name: string | null;
  store_code: string | null;
  request_date: string | null;
  shift_name: string | null;
  start_time: string | null;
  end_time: string | null;
  actual_start_time: string | null;
  actual_end_time: string | null;
  confirm_start_time: string | null;
  confirm_end_time: string | null;
  scheduled_hours: number | null;
  actual_worked_hours: number | null;
  paid_hours: number | null;
  is_late: boolean | null;
  late_minutes: number | null;
  late_deduction_krw: number | null;
  is_extratime: boolean | null;
  overtime_minutes: number | null;
  overtime_amount: number | null;
  salary_type: string | null;
  salary_amount: number | null;
  bonus_amount: number | null;
  total_salary_pay: number | null;
  total_pay_with_bonus: number | null;
  is_approved: boolean | null;
  is_problem: boolean | null;
  problem_type: string | null;
  report_reason: string | null;
  is_summary: boolean;
  total_shift_count: number | null;
  late_count: number | null;
  extratime_count: number | null;
  problem_count: number | null;
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
   * @param storeId - Optional store ID filter
   */
  async getSalaryData(
    companyId: string,
    month: string,
    storeId?: string | null
  ): Promise<{ success: boolean; data?: SalaryRawData; error?: string }> {
    try {
      const supabase = supabaseService.getClient();
      const timezone = this.getUserTimezone();

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { data, error } = await (supabase.rpc as any)('get_employee_salary_v2', {
        p_company_id: companyId,
        p_month: month,
        p_timezone: timezone,
        p_store_id: storeId ?? null,
      });

      if (error) {
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
   * @param storeId - Optional store ID filter
   */
  async exportToExcel(
    companyId: string,
    month: string,
    storeId?: string | null
  ): Promise<{ success: boolean; data?: SalaryExcelRow[]; error?: string }> {
    try {
      const supabase = supabaseService.getClient();
      const timezone = this.getUserTimezone();

      // eslint-disable-next-line @typescript-eslint/no-explicit-any
      const { data, error } = await (supabase.rpc as any)('get_employee_salary_excel_v2', {
        p_company_id: companyId,
        p_month: month,
        p_timezone: timezone,
        p_store_id: storeId ?? null,
      });

      if (error) {
        return {
          success: false,
          error: error.message || 'Failed to export salary data',
        };
      }

      return {
        success: true,
        data: data as SalaryExcelRow[],
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
