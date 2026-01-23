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
  is_approved?: boolean;
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

// manager_shift_get_cards_v4 response types
export interface ShiftCardRaw {
  shift_date: string;
  shift_request_id: string;
  user_id: string;
  user_name: string;
  profile_image: string | null;
  shift_name: string;
  shift_time: string;
  shift_start_time: string;
  shift_end_time: string;
  is_approved: boolean;
  is_problem: boolean;
  is_problem_solved: boolean;
  is_late: boolean;
  late_minute: number;
  is_over_time: boolean;
  over_time_minute: number;
  paid_hour: number;
  salary_type: string;
  salary_amount: string;
  base_pay: string;
  bonus_amount: number;
  total_pay_with_bonus: string;
  actual_start: string | null;
  actual_end: string | null;
  confirm_start_time: string | null;
  confirm_end_time: string | null;
  notice_tag: any[];
  problem_type: string | null;
  is_valid_checkin_location: boolean | null;
  is_valid_checkout_location: boolean | null;
  checkin_distance_from_store: number;
  checkout_distance_from_store: number;
  store_name: string;
  is_reported: boolean;
  is_reported_solved: boolean | null;
  report_reason: string | null;
  manager_memo: any[];
}

export interface ShiftCardsStoreRaw {
  store_id: string;
  store_name: string;
  request_count: number;
  approved_count: number;
  problem_count: number;
  cards: ShiftCardRaw[];
}

export interface ShiftCardsRawData {
  available_contents: any[];
  stores: ShiftCardsStoreRaw[];
  timezone: string;
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

      console.group('🔍 RPC Call: get_shift_schedule_info_v2');
      console.log('Parameters:', {
        p_company_id: companyId,
        p_store_id: storeId,
        p_start_date: localStartDate,
        p_end_date: localEndDate,
        p_timezone: timezone,
      });
      console.groupEnd();

      const { data, error } = await supabase.rpc('get_shift_schedule_info_v2', {
        p_company_id: companyId,
        p_store_id: storeId,
        p_start_date: localStartDate,
        p_end_date: localEndDate,
        p_timezone: timezone,
      });

      console.group('📥 RPC Response: get_shift_schedule_info_v2');
      console.log('Error:', error);
      console.log('Data:', data);
      console.log('Schedule array:', (data as any)?.schedule);
      console.log('Shifts array:', (data as any)?.shifts);
      console.groupEnd();

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
   * Updated for v4 error codes
   */
  private translateErrorMessage(message: string, errorCode?: string): string {
    // Error code based translations (v4)
    const errorCodeTranslations: Record<string, string> = {
      MISSING_PARAMETERS: 'Required parameters are missing',
      INVALID_SHIFT_ID: 'Invalid shift information',
      DUPLICATE_SHIFT: 'This employee is already assigned to a shift at the same date and time',
      INTERNAL_ERROR: 'An error occurred while adding the shift',
    };

    if (errorCode && errorCodeTranslations[errorCode]) {
      return errorCodeTranslations[errorCode];
    }

    // Legacy message based translations
    const messageTranslations: Record<string, string> = {
      '이미 해당 직원에게 같은 날짜/시간에 배정된 시프트가 있습니다.':
        'This employee is already assigned to a shift at the same date and time',
      '시프트 추가 중 오류가 발생했습니다.':
        'An error occurred while adding the shift',
      '직원 정보를 찾을 수 없습니다.':
        'Employee information not found',
      '시프트 정보를 찾을 수 없습니다.':
        'Shift information not found',
      '유효하지 않은 시프트 정보입니다.':
        'Invalid shift information',
      '매장 정보를 찾을 수 없습니다.':
        'Store information not found',
      '권한이 없습니다.':
        'You do not have permission',
      '필수 파라미터가 누락되었습니다.':
        'Required parameters are missing',
      '시프트가 성공적으로 추가되었습니다.':
        'Shift has been successfully added',
    };

    return messageTranslations[message] || message;
  }

  /**
   * Create schedule assignment using v4 RPC
   * @param userId - Employee user identifier
   * @param shiftId - Shift identifier
   * @param storeId - Store identifier
   * @param date - Assignment date (ISO string YYYY-MM-DD or Date object)
   * @param shiftStartTime - Shift start time (HH:mm:ss format)
   * @param shiftEndTime - Shift end time (HH:mm:ss format)
   * @param approvedBy - User ID of the manager approving this assignment
   */
  async createAssignment(
    userId: string,
    shiftId: string,
    storeId: string,
    date: string | Date,
    shiftStartTime: string,
    shiftEndTime: string,
    approvedBy: string
  ): Promise<{ success: boolean; data?: any; error?: string; errorCode?: string }> {
    try {
      const supabase = supabaseService.getClient();

      // Get local timezone (e.g., "Asia/Seoul", "Asia/Ho_Chi_Minh")
      const timezone = DateTimeUtils.getLocalTimezone();

      // Convert date to Date object
      let dateObj: Date;
      if (typeof date === 'string') {
        dateObj = new Date(date);
      } else {
        dateObj = date;
      }

      // Format date parts
      const year = dateObj.getFullYear();
      const month = String(dateObj.getMonth() + 1).padStart(2, '0');
      const day = String(dateObj.getDate()).padStart(2, '0');

      // v4 requires p_start_time and p_end_time as local timestamps (without timezone)
      // Format: 'YYYY-MM-DD HH:mm:ss' (local time)
      const startTimeLocal = `${year}-${month}-${day} ${shiftStartTime}`;
      const endTimeLocal = `${year}-${month}-${day} ${shiftEndTime}`;

      // 🔍 Log RPC call parameters
      console.group('🔍 RPC Call: manager_shift_insert_schedule_v4');
      console.log('Parameters:', {
        p_user_id: userId,
        p_shift_id: shiftId,
        p_store_id: storeId,
        p_start_time: startTimeLocal,
        p_end_time: endTimeLocal,
        p_approved_by: approvedBy,
        p_timezone: timezone,
      });
      console.groupEnd();

      // Use type assertion for v4 RPC (not yet in generated types)
      const { data: rpcData, error } = await (supabase.rpc as any)('manager_shift_insert_schedule_v4', {
        p_user_id: userId,
        p_shift_id: shiftId,
        p_store_id: storeId,
        p_start_time: startTimeLocal,
        p_end_time: endTimeLocal,
        p_approved_by: approvedBy,
        p_timezone: timezone,
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

      // Handle JSON response from RPC v4
      if (rpcData && typeof rpcData === 'object') {
        const result = rpcData as {
          success?: boolean;
          message?: string;
          error_code?: string;
          duplicate_data?: any;
          data?: any;
          [key: string]: any;
        };

        if (result.success === false) {
          // Translate error message using error_code (v4) or message (fallback)
          const translatedMessage = this.translateErrorMessage(
            result.message || 'Failed to create assignment',
            result.error_code
          );

          console.warn('⚠️ RPC returned failure:', {
            original: result.message,
            translated: translatedMessage,
            errorCode: result.error_code,
            duplicateData: result.duplicate_data,
          });

          return {
            success: false,
            error: translatedMessage,
            errorCode: result.error_code,
            data: result,
          };
        }

        console.log('✅ Assignment created successfully');
        return {
          success: true,
          data: result.data || result,
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
   * Fetch shift cards data from manager_shift_get_cards_v4 RPC
   * This provides is_approved status for each assignment
   * @param companyId - Company identifier
   * @param storeId - Store identifier (optional, null for all stores)
   * @param startDate - Start date (ISO string or Date object)
   * @param endDate - End date (ISO string or Date object)
   */
  async getShiftCards(
    companyId: string,
    storeId: string | null,
    startDate: string | Date,
    endDate: string | Date
  ): Promise<{ success: boolean; data?: ShiftCardsRawData; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      // Convert to Date objects if strings
      const startDateObj = typeof startDate === 'string' ? new Date(startDate) : startDate;
      const endDateObj = typeof endDate === 'string' ? new Date(endDate) : endDate;

      // Get local timezone
      const timezone = DateTimeUtils.getLocalTimezone();

      // Convert to local date format (yyyy-MM-dd)
      const localStartDate = DateTimeUtils.toDateOnly(startDateObj);
      const localEndDate = DateTimeUtils.toDateOnly(endDateObj);

      console.group('🔍 RPC Call: manager_shift_get_cards_v4');
      console.log('Parameters:', {
        p_company_id: companyId,
        p_start_date: localStartDate,
        p_end_date: localEndDate,
        p_store_id: storeId,
        p_timezone: timezone,
      });
      console.groupEnd();

      // Use type assertion for v4 RPC (not yet in generated types)
      const { data, error } = await (supabase.rpc as any)('manager_shift_get_cards_v4', {
        p_company_id: companyId,
        p_start_date: localStartDate,
        p_end_date: localEndDate,
        p_store_id: storeId,
        p_timezone: timezone,
      });

      console.group('📥 RPC Response: manager_shift_get_cards_v4');
      console.log('Error:', error);
      console.log('Data:', data);
      console.groupEnd();

      if (error) {
        console.error('Shift cards RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to fetch shift cards',
        };
      }

      if (!data) {
        return {
          success: false,
          error: 'No data returned from shift cards query',
        };
      }

      return {
        success: true,
        data: data as ShiftCardsRawData,
      };
    } catch (error) {
      console.error('Shift cards datasource error:', error);
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

  /**
   * Toggle approval status for shift request(s)
   * Uses toggle_shift_approval_v3 RPC
   * @param shiftRequestIds - Array of shift request IDs to toggle
   * @param userId - Manager user ID performing the action
   */
  async toggleApproval(
    shiftRequestIds: string[],
    userId: string
  ): Promise<{ success: boolean; error?: string }> {
    try {
      const supabase = supabaseService.getClient();

      console.group('🔍 RPC Call: toggle_shift_approval_v3');
      console.log('Parameters:', {
        p_shift_request_ids: shiftRequestIds,
        p_user_id: userId,
      });
      console.groupEnd();

      const { error } = await (supabase.rpc as any)('toggle_shift_approval_v3', {
        p_shift_request_ids: shiftRequestIds,
        p_user_id: userId,
      });

      console.group('📥 RPC Response: toggle_shift_approval_v3');
      console.log('Error:', error);
      console.groupEnd();

      if (error) {
        console.error('❌ Toggle approval RPC error:', error);
        return {
          success: false,
          error: error.message || 'Failed to toggle approval status',
        };
      }

      console.log('✅ Approval status toggled successfully');
      return { success: true };
    } catch (error) {
      console.error('❌ Toggle approval datasource error:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Unknown error occurred',
      };
    }
  }
}
