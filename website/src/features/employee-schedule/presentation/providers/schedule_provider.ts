/**
 * Schedule Provider
 * Zustand store for employee schedule state management (2025 Best Practice)
 */

import { create } from 'zustand';
import type { ScheduleState } from './states/schedule_state';
import { ScheduleRepositoryImpl } from '../../data/repositories/ScheduleRepositoryImpl';
import { ScheduleValidator } from '../../domain/validators/ScheduleValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';

// Create repository instance once
const repository = new ScheduleRepositoryImpl();

export const useScheduleStore = create<ScheduleState>((set, get) => ({
  // Initial state
  shifts: [],
  assignments: [],
  employees: [],
  loading: false,
  loadingEmployees: false,
  error: null,
  currentWeek: new Date(),
  selectedStoreId: null,
  isAddEmployeeModalOpen: false,
  selectedDate: '',
  addingEmployee: false,
  notification: null,

  // Helper: Get week range
  getWeekRange: (date = new Date()) => {
    const start = new Date(date);
    start.setDate(start.getDate() - start.getDay()); // Start on Sunday
    start.setHours(0, 0, 0, 0);

    const end = new Date(start);
    end.setDate(end.getDate() + 6); // End on Saturday
    end.setHours(23, 59, 59, 999);

    return {
      startDate: DateTimeUtils.toDateOnly(start),
      endDate: DateTimeUtils.toDateOnly(end),
    };
  },

  // Helper: Get week days array
  getWeekDays: () => {
    const { startDate } = get().getWeekRange(get().currentWeek);
    const days: string[] = [];
    const start = new Date(startDate);

    for (let i = 0; i < 7; i++) {
      const day = new Date(start);
      day.setDate(day.getDate() + i);
      days.push(day.toISOString().split('T')[0]);
    }

    return days;
  },

  // Action: Load schedule data
  loadScheduleData: async (companyId: string, storeId: string) => {
    set({ loading: true, error: null });

    try {
      const { startDate, endDate } = get().getWeekRange(get().currentWeek);

      const result = await repository.getScheduleData(companyId, storeId, startDate, endDate);

      if (!result.success) {
        set({
          error: result.error || 'Failed to load schedule data',
          shifts: [],
          assignments: [],
          loading: false,
        });
        return;
      }

      set({
        shifts: result.shifts || [],
        assignments: result.assignments || [],
        loading: false,
        error: null,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        shifts: [],
        assignments: [],
        loading: false,
      });
    }
  },

  // Action: Load employees
  loadEmployees: async (companyId: string, storeId: string) => {
    set({ loadingEmployees: true });

    try {
      const result = await repository.getEmployees(companyId, storeId);

      if (!result.success || !result.employees) {
        console.error('Failed to load employees:', result.error);
        set({ employees: [], loadingEmployees: false });
        return;
      }

      set({ employees: result.employees, loadingEmployees: false });
    } catch (err) {
      console.error('Error loading employees:', err);
      set({ employees: [], loadingEmployees: false });
    }
  },

  // Action: Refresh (for manual refresh)
  refresh: () => {
    // This will be called with companyId and storeId from the component
    // The component should call loadScheduleData again
  },

  // Action: Week navigation
  goToPreviousWeek: () => {
    const currentWeek = get().currentWeek;
    const newWeek = new Date(currentWeek);
    newWeek.setDate(newWeek.getDate() - 7);
    set({ currentWeek: newWeek });
  },

  goToNextWeek: () => {
    const currentWeek = get().currentWeek;
    const newWeek = new Date(currentWeek);
    newWeek.setDate(newWeek.getDate() + 7);
    set({ currentWeek: newWeek });
  },

  goToCurrentWeek: () => {
    set({ currentWeek: new Date() });
  },

  // Action: Get assignments for a specific date
  getAssignmentsForDate: (date: string) => {
    return get().assignments.filter((a) => a.date === date);
  },

  // Action: Create assignment
  createAssignment: async (
    shiftId: string,
    employeeId: string,
    date: string,
    approvedBy: string
  ) => {
    try {
      // 1. Validate using Domain Validator
      const validationErrors = ScheduleValidator.validateAssignment({
        shiftId,
        employeeId,
        date,
      });

      if (validationErrors.length > 0) {
        const fieldErrors: Record<string, string> = {};
        validationErrors.forEach((err) => {
          fieldErrors[err.field] = err.message;
        });
        return {
          success: false,
          error: validationErrors[0].message,
          fieldErrors,
        };
      }

      // 2. Call Repository
      const result = await repository.createAssignment(
        employeeId,
        shiftId,
        get().selectedStoreId || '',
        date,
        approvedBy
      );

      if (!result.success) {
        return {
          success: false,
          error: result.error || 'Failed to create assignment',
        };
      }

      return { success: true };
    } catch (err) {
      return {
        success: false,
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
      };
    }
  },

  // Action: Page state
  setSelectedStore: (storeId: string | null) => {
    set({ selectedStoreId: storeId });
  },

  // Action: Modal state
  openAddEmployeeModal: (date: string) => {
    set({ isAddEmployeeModalOpen: true, selectedDate: date });
  },

  closeAddEmployeeModal: () => {
    set({ isAddEmployeeModalOpen: false, selectedDate: '' });
  },

  setAddingEmployee: (loading: boolean) => {
    set({ addingEmployee: loading });
  },

  // Action: Notification
  showNotification: (notification) => {
    set({ notification });
  },

  clearNotification: () => {
    set({ notification: null });
  },

  // Action: Reset
  reset: () => {
    set({
      shifts: [],
      assignments: [],
      employees: [],
      loading: false,
      loadingEmployees: false,
      error: null,
      currentWeek: new Date(),
      selectedStoreId: null,
      isAddEmployeeModalOpen: false,
      selectedDate: '',
      addingEmployee: false,
      notification: null,
    });
  },
}));
