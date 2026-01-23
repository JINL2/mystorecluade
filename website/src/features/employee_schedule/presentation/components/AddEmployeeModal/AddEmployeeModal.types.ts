/**
 * AddEmployeeModal Component Types
 */

import { ScheduleShift } from '../../../domain/entities/ScheduleShift';
import { ScheduleEmployee } from '../../../domain/entities/ScheduleEmployee';
import { ScheduleAssignment } from '../../../domain/entities/ScheduleAssignment';

export interface AddEmployeeModalProps {
  /**
   * Whether the modal is open
   */
  isOpen: boolean;

  /**
   * Callback to close the modal
   */
  onClose: () => void;

  /**
   * Selected date for the assignment
   */
  selectedDate: string;

  /**
   * Default shift ID to pre-select
   */
  defaultShiftId?: string | null;

  /**
   * Available shifts to choose from
   */
  shifts: ScheduleShift[];

  /**
   * Available employees to choose from
   */
  employees: ScheduleEmployee[];

  /**
   * Existing assignments to check for duplicates
   */
  assignments: ScheduleAssignment[];

  /**
   * Callback when adding employee to shift
   */
  onAddEmployee: (shiftId: string, employeeId: string, date: string) => Promise<void>;

  /**
   * Whether the assignment is being saved
   */
  loading?: boolean;
}

export interface AddEmployeeFormData {
  shiftId: string;
  employeeId: string;
}
