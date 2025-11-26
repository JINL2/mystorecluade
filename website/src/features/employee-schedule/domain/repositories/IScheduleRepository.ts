/**
 * Schedule Repository Interface
 * Domain layer - Contract for schedule data operations
 */

import { ScheduleShift } from '../entities/ScheduleShift';
import { ScheduleAssignment } from '../entities/ScheduleAssignment';
import { ScheduleEmployee } from '../entities/ScheduleEmployee';

export interface ScheduleDataResult {
  success: boolean;
  shifts?: ScheduleShift[];
  assignments?: ScheduleAssignment[];
  error?: string;
}

export interface EmployeesResult {
  success: boolean;
  employees?: ScheduleEmployee[];
  error?: string;
}

export interface IScheduleRepository {
  /**
   * Get schedule data for a date range
   * @param companyId - Company identifier
   * @param storeId - Store identifier
   * @param startDate - Start date (ISO string)
   * @param endDate - End date (ISO string)
   * @returns ScheduleDataResult with shifts and assignments
   */
  getScheduleData(
    companyId: string,
    storeId: string,
    startDate: string,
    endDate: string
  ): Promise<ScheduleDataResult>;

  /**
   * Get employees for a store
   * @param companyId - Company identifier
   * @param storeId - Store identifier
   * @returns EmployeesResult with employee list
   */
  getEmployees(companyId: string, storeId: string): Promise<EmployeesResult>;

  /**
   * Create new schedule assignment
   * @param userId - Employee user ID
   * @param shiftId - Shift identifier
   * @param storeId - Store identifier
   * @param date - Assignment date
   * @param shiftStartTime - Shift start time (HH:mm:ss format)
   * @param approvedBy - User ID of approver
   * @returns Success status
   */
  createAssignment(
    userId: string,
    shiftId: string,
    storeId: string,
    date: string,
    shiftStartTime: string,
    approvedBy: string
  ): Promise<{ success: boolean; error?: string }>;

  /**
   * Update schedule assignment
   * @param assignmentId - Assignment identifier
   * @param data - Updated assignment data
   * @returns Success status
   */
  updateAssignment(
    assignmentId: string,
    data: Partial<ScheduleAssignment>
  ): Promise<{ success: boolean; error?: string }>;

  /**
   * Delete schedule assignment
   * @param assignmentId - Assignment identifier
   * @returns Success status
   */
  deleteAssignment(assignmentId: string): Promise<{ success: boolean; error?: string }>;
}
