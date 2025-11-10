/**
 * Schedule Repository Interface
 * Domain layer - Contract for schedule data operations
 */

import { ScheduleShift } from '../entities/ScheduleShift';
import { ScheduleAssignment } from '../entities/ScheduleAssignment';

export interface ScheduleDataResult {
  success: boolean;
  shifts?: ScheduleShift[];
  assignments?: ScheduleAssignment[];
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
   * Create new schedule assignment
   * @param data - Assignment data
   * @returns Success status
   */
  createAssignment(data: Partial<ScheduleAssignment>): Promise<{ success: boolean; error?: string }>;

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
