/**
 * Schedule State Interface
 * State interface for employee schedule management
 */

import type { ScheduleShift } from '../../../domain/entities/ScheduleShift';
import type { ScheduleAssignment } from '../../../domain/entities/ScheduleAssignment';
import type { ScheduleEmployee } from '../../../domain/entities/ScheduleEmployee';
import type { WeekRange, ScheduleNotification } from './types';

export interface ScheduleState {
  // Data state
  shifts: ScheduleShift[];
  assignments: ScheduleAssignment[];
  employees: ScheduleEmployee[];

  // Loading states
  loading: boolean;
  loadingEmployees: boolean;

  // Error state
  error: string | null;

  // Week navigation state
  currentWeek: Date;

  // Page state
  selectedStoreId: string | null;

  // Modal state (for detail page)
  isAddEmployeeModalOpen: boolean;
  selectedDate: string;
  addingEmployee: boolean;

  // Notification state
  notification: ScheduleNotification | null;

  // Actions - Data loading
  loadScheduleData: (companyId: string, storeId: string) => Promise<void>;
  loadEmployees: (companyId: string, storeId: string) => Promise<void>;
  refresh: () => void;

  // Actions - Week navigation
  goToPreviousWeek: () => void;
  goToNextWeek: () => void;
  goToCurrentWeek: () => void;
  getWeekRange: (date?: Date) => WeekRange;
  getWeekDays: () => string[];

  // Actions - Assignments
  getAssignmentsForDate: (date: string) => ScheduleAssignment[];
  createAssignment: (
    shiftId: string,
    employeeId: string,
    date: string,
    shiftStartTime: string,
    approvedBy: string
  ) => Promise<{ success: boolean; error?: string; fieldErrors?: Record<string, string> }>;

  // Actions - Page state
  setSelectedStore: (storeId: string | null) => void;

  // Actions - Modal state
  openAddEmployeeModal: (date: string) => void;
  closeAddEmployeeModal: () => void;
  setAddingEmployee: (loading: boolean) => void;

  // Actions - Notification
  showNotification: (notification: ScheduleNotification) => void;
  clearNotification: () => void;

  // Actions - Reset
  reset: () => void;
}
