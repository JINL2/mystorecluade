/**
 * Schedule Data Source
 * Data layer - Handles Supabase RPC calls for schedule data
 */

import { supabaseService } from '@/core/services/supabase-service';

export interface ScheduleShiftRaw {
  shift_id: string;
  shift_name: string;
  start_time: string;
  end_time: string;
  color?: string;
}

export interface ScheduleAssignmentRaw {
  assignment_id: string;
  user_id: string;
  full_name: string;
  date: string;
  shift_id: string;
  shift_name: string;
  start_time: string;
  end_time: string;
  color?: string;
  status?: 'scheduled' | 'confirmed' | 'absent';
}

export interface ScheduleEmployeeInShift {
  user_id: string;
  user_name: string;
  status?: 'scheduled' | 'confirmed' | 'absent';
}

export interface ScheduleShiftInDay {
  shift_id: string;
  shift_name: string;
  shift_time: string;
  employees: ScheduleEmployeeInShift[];
  approved_count: number;
  assigned_count: number;
  required_employees: number;
}

export interface ScheduleDayData {
  date: string;
  shifts: ScheduleShiftInDay[];
}

export interface ScheduleRawData {
  store_info?: {
    store_id: string;
    store_name: string;
    store_code: string;
  };
  shifts: ScheduleShiftRaw[];
  employees?: any[];
  schedule: ScheduleDayData[];
}

export interface EmployeeRawData {
  user_id: string;
  full_name: string;
  email: string;
  role_ids: string[];
  role_names: string[];
  stores: Array<{ store_id: string; store_name: string }>;
  company_id: string;
  company_name: string;
  salary_id: string | null;
  salary_amount: string | null;
  salary_type: string | null;
  bonus_amount: string | null;
  currency_id: string | null;
  currency_code: string | null;
  account_id: string | null;
}

export class ScheduleDataSource {
  /**
   * Fetch employee list from Supabase RPC
   * @param companyId - Company identifier
   * @param storeId - Store identifier (optional, null for all company employees)
   */
  async getEmployees(
    companyId: string,
    storeId: string | null
  ): Promise<{ success: boolean; data?: EmployeeRawData[]; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      const { data, error } = await supabase.rpc('get_employee_info', {
        p_company_id: companyId,
        p_store_id: storeId,
      });

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
          error: 'No data returned from employee query',
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
   * Fetch schedule data from Supabase RPC
   * @param companyId - Company identifier
   * @param storeId - Store identifier
   * @param startDate - Start date (ISO string)
   * @param endDate - End date (ISO string)
   */
  async getScheduleData(
    companyId: string,
    storeId: string,
    startDate: string,
    endDate: string
  ): Promise<{ success: boolean; data?: ScheduleRawData; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      const { data, error } = await supabase.rpc('get_shift_schedule_info', {
        p_company_id: companyId,
        p_store_id: storeId,
        p_start_date: startDate,
        p_end_date: endDate,
      });

      if (error) {
        console.error('Schedule RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to fetch schedule data',
        };
      }

      if (!data) {
        return {
          success: false,
          error: 'No data returned from schedule query',
        };
      }

      return {
        success: true,
        data: data as ScheduleRawData,
      };
    } catch (error) {
      console.error('Schedule datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }

  /**
   * Create schedule assignment
   * @param companyId - Company identifier
   * @param storeId - Store identifier
   * @param userId - Employee user identifier
   * @param shiftId - Shift identifier
   * @param date - Assignment date (ISO string)
   */
  async createAssignment(
    companyId: string,
    storeId: string,
    userId: string,
    shiftId: string,
    date: string
  ): Promise<{ success: boolean; data?: any; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      // TODO: Replace with actual RPC name when available
      // For now, we'll use a placeholder that will need to be updated
      const { data, error } = await supabase.rpc('create_shift_assignment', {
        p_company_id: companyId,
        p_store_id: storeId,
        p_user_id: userId,
        p_shift_id: shiftId,
        p_date: date,
        p_status: 'scheduled',
      });

      if (error) {
        console.error('Create assignment RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to create assignment',
        };
      }

      return {
        success: true,
        data,
      };
    } catch (error) {
      console.error('Create assignment datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }

  /**
   * Update schedule assignment (placeholder)
   */
  async updateAssignment(
    _assignmentId: string,
    _data: any
  ): Promise<{ success: boolean; error?: string }> {
    // TODO: Implement update assignment RPC
    return { success: false, error: 'Not implemented yet' };
  }

  /**
   * Delete schedule assignment (placeholder)
   */
  async deleteAssignment(_assignmentId: string): Promise<{ success: boolean; error?: string }> {
    // TODO: Implement delete assignment RPC
    return { success: false, error: 'Not implemented yet' };
  }
}
