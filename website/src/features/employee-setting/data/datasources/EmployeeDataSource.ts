/**
 * Employee Data Source
 * Data layer - Handles Supabase RPC calls for employees
 */

import { supabaseService } from '@/core/services/supabase-service';

export interface StoreInfo {
  store_id: string;
  store_name: string;
}

export interface EmployeeRawData {
  user_id: string;
  full_name: string;
  email: string;
  role_ids: string[];
  role_names: string[];
  stores: StoreInfo[]; // Changed from separate arrays to JSONB array
  company_id: string;
  company_name: string;
  salary_id: string | null;
  salary_amount: number;
  salary_type: string | null;
  bonus_amount: number | null;
  currency_id: string;
  currency_code: string;
  account_id: string | null;
}

export class EmployeeDataSource {
  /**
   * Fetch employees from Supabase RPC
   * @param companyId - Company identifier
   * @param storeId - Optional store filter
   */
  async getEmployees(
    companyId: string,
    storeId?: string | null
  ): Promise<{ success: boolean; data?: EmployeeRawData[]; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      const rpcParams: any = {
        p_company_id: companyId,
      };

      if (storeId) {
        rpcParams.p_store_id = storeId;
      }

      const { data, error } = await supabase.rpc('get_employee_info', rpcParams);

      if (error) {
        console.error('Employee RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to fetch employees',
        };
      }

      if (!data) {
        return {
          success: false,
          error: 'No data returned from employees',
        };
      }

      return {
        success: true,
        data: data as EmployeeRawData[],
      };
    } catch (error) {
      console.error('Employee datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }

  /**
   * Create new employee (placeholder for future implementation)
   */
  async createEmployee(_data: any): Promise<{ success: boolean; error?: string }> {
    // TODO: Implement create employee RPC/API call
    return { success: false, error: 'Not implemented yet' };
  }

  /**
   * Update employee (placeholder for future implementation)
   */
  async updateEmployee(_userId: string, _data: any): Promise<{ success: boolean; error?: string }> {
    // TODO: Implement update employee RPC/API call
    return { success: false, error: 'Not implemented yet' };
  }

  /**
   * Delete employee (placeholder for future implementation)
   */
  async deleteEmployee(_userId: string): Promise<{ success: boolean; error?: string }> {
    // TODO: Implement delete employee RPC/API call
    return { success: false, error: 'Not implemented yet' };
  }

  /**
   * Update employee salary via RPC
   */
  async updateEmployeeSalary(
    salaryId: string,
    salaryAmount: number,
    salaryType: 'monthly' | 'hourly',
    currencyId: string
  ): Promise<{ success: boolean; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      const { error } = await (supabase as any).rpc('update_user_salary', {
        p_salary_id: salaryId,
        p_salary_amount: salaryAmount,
        p_salary_type: salaryType,
        p_currency_id: currencyId,
      });

      if (error) {
        console.error('Update salary RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to update salary',
        };
      }

      return { success: true };
    } catch (error) {
      console.error('Update salary datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
