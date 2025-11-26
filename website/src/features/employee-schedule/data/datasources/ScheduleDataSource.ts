/**
 * Schedule Data Source
 * Data layer - Handles Supabase RPC calls for schedule data
 */

import { supabaseService } from '@/core/services/supabase-service';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

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
   * @param startDate - Start date (ISO string or Date object)
   * @param endDate - End date (ISO string or Date object)
   */
  async getScheduleData(
    companyId: string,
    storeId: string,
    startDate: string | Date,
    endDate: string | Date
  ): Promise<{ success: boolean; data?: ScheduleRawData; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      // Convert to Date objects if strings
      const startDateObj = typeof startDate === 'string' ? new Date(startDate) : startDate;
      const endDateObj = typeof endDate === 'string' ? new Date(endDate) : endDate;

      // Get local timezone (e.g., "Asia/Seoul", "America/New_York")
      const timezone = DateTimeUtils.getLocalTimezone();

      // Convert to local date format (yyyy-MM-dd) without timezone conversion
      const localStartDate = DateTimeUtils.toDateOnly(startDateObj);
      const localEndDate = DateTimeUtils.toDateOnly(endDateObj);

      const { data, error } = await supabase.rpc('get_shift_schedule_info_v2', {
        p_company_id: companyId,
        p_store_id: storeId,
        p_start_date: localStartDate,
        p_end_date: localEndDate,
        p_timezone: timezone,
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
   * @param userId - Employee user identifier
   * @param shiftId - Shift identifier
   * @param storeId - Store identifier
   * @param date - Assignment date (ISO string YYYY-MM-DD or Date object)
   * @param approvedBy - User ID of the manager approving this assignment
   */
  /**
   * Translate Korean RPC error messages to English
   */
  private translateErrorMessage(message: string): string {
    const translations: Record<string, string> = {
      '이미 해당 직원에게 같은 날짜/시간에 배정된 시프트가 있습니다.':
        'This employee is already assigned to a shift at the same date and time',
      '시프트 추가 중 오류가 발생했습니다.':
        'An error occurred while adding the shift',
      '직원 정보를 찾을 수 없습니다.':
        'Employee information not found',
      '시프트 정보를 찾을 수 없습니다.':
        'Shift information not found',
      '매장 정보를 찾을 수 없습니다.':
        'Store information not found',
      '권한이 없습니다.':
        'You do not have permission',
      '필수 파라미터가 누락되었습니다.':
        'Required parameters are missing',
    };

    return translations[message] || message;
  }

  async createAssignment(
    userId: string,
    shiftId: string,
    storeId: string,
    date: string | Date,
    shiftStartTime: string,
    approvedBy: string
  ): Promise<{ success: boolean; data?: any; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      // Get local timezone (e.g., "Asia/Seoul", "America/New_York")
      const timezone = DateTimeUtils.getLocalTimezone();

      // Get timezone offset for ISO 8601 format (e.g., "+07:00", "-05:00")
      const timezoneOffset = new Date().getTimezoneOffset();
      const offsetHours = Math.floor(Math.abs(timezoneOffset) / 60);
      const offsetMinutes = Math.abs(timezoneOffset) % 60;
      const offsetSign = timezoneOffset <= 0 ? '+' : '-';
      const offsetString = `${offsetSign}${String(offsetHours).padStart(2, '0')}:${String(offsetMinutes).padStart(2, '0')}`;

      // Convert date to Date object
      let dateObj: Date;
      if (typeof date === 'string') {
        dateObj = new Date(date);
      } else {
        dateObj = date;
      }

      // Format date for p_request_time
      const year = dateObj.getFullYear();
      const month = String(dateObj.getMonth() + 1).padStart(2, '0');
      const day = String(dateObj.getDate()).padStart(2, '0');

      // Format: YYYY-MM-DDTHH:mm:ss+TZ (ISO 8601 with timezone)
      // According to RPC guide: time part is ignored, only date is used
      // The actual shift start/end times come from store_shifts table
      // Example: '2025-11-26T00:00:00+07:00'
      const timestampWithTz = `${year}-${month}-${day}T${shiftStartTime}${offsetString}`;

      // 🔍 Log RPC call parameters
      console.group('🔍 RPC Call: manager_shift_insert_schedule_v2');
      console.log('Parameters:', {
        p_user_id: userId,
        p_shift_id: shiftId,
        p_store_id: storeId,
        p_request_time: timestampWithTz,
        p_timezone: timezone,
        p_approved_by: approvedBy,
      });
      console.groupEnd();

      const { data: rpcData, error } = await supabase.rpc('manager_shift_insert_schedule_v2', {
        p_user_id: userId,
        p_shift_id: shiftId,
        p_store_id: storeId,
        p_request_time: timestampWithTz,
        p_timezone: timezone,
        p_approved_by: approvedBy,
      });

      // 🔍 Log RPC response
      console.group('📥 RPC Response');
      console.log('Error:', error);
      console.log('Data:', rpcData);
      console.groupEnd();

      if (error) {
        console.error('❌ Create assignment RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to create assignment',
        };
      }

      // Handle JSON response from RPC
      if (rpcData && typeof rpcData === 'object') {
        const result = rpcData as { success?: boolean; message?: string; [key: string]: any };
        if (result.success === false) {
          // Translate Korean error messages to English
          const translatedMessage = result.message
            ? this.translateErrorMessage(result.message)
            : 'Failed to create assignment';

          console.warn('⚠️ RPC returned failure:', {
            original: result.message,
            translated: translatedMessage,
          });

          return {
            success: false,
            error: translatedMessage,
            data: result,
          };
        }
        console.log('✅ Assignment created successfully');
        return {
          success: true,
          data: result,
        };
      }

      return {
        success: true,
        data: rpcData,
      };
    } catch (error) {
      console.error('❌ Create assignment datasource error:', error);
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
