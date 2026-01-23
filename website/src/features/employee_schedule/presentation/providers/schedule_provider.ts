/**
 * Schedule Provider
 * Zustand store for employee schedule state management (2025 Best Practice)
 */

import { create } from 'zustand';
import type { ScheduleState } from './states/schedule_state';
import { ScheduleRepositoryImpl } from '../../data/repositories/ScheduleRepositoryImpl';
import { ScheduleValidator } from '../../domain/validators/ScheduleValidator';
import { DateTimeUtils } from '@/core/utils/datetime-utils';
import { ScheduleAssignment } from '../../domain/entities/ScheduleAssignment';
import { ScheduleShift } from '../../domain/entities/ScheduleShift';

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
  selectedShiftId: null,
  addingEmployee: false,
  isApprovalModalOpen: false,
  selectedAssignment: null,
  updatingApproval: false,
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

      // Fetch both schedule data and shift cards in parallel
      const [scheduleResult, cardsResult] = await Promise.all([
        repository.getScheduleData(companyId, storeId, startDate, endDate),
        repository.getShiftCards(companyId, storeId, startDate, endDate),
      ]);

      if (!scheduleResult.success) {
        set({
          error: scheduleResult.error || 'Failed to load schedule data',
          shifts: [],
          assignments: [],
          loading: false,
        });
        return;
      }

      // Build assignments from cards data (which has actual employee assignments with is_approved)
      // The schedule RPC returns empty employees arrays, so we use cards data instead
      let assignments: ScheduleAssignment[] = [];

      if (cardsResult.success && cardsResult.cards && cardsResult.cards.length > 0) {
        // Create a map of shifts for quick lookup
        const shiftMap = new Map<string, ScheduleShift>();
        for (const shift of scheduleResult.shifts || []) {
          shiftMap.set(shift.shiftName, shift);
        }

        // Create assignments from cards data
        // Use a Set to track unique assignments (date-shiftName-userId)
        const seenAssignments = new Set<string>();

        for (const card of cardsResult.cards) {
          // Find matching shift by name
          let shift = shiftMap.get(card.shiftName);

          // If shift not found, create one from card data
          if (!shift) {
            shift = ScheduleShift.create({
              shift_id: `card-shift-${card.shiftName}`,
              shift_name: card.shiftName,
              start_time: card.shiftStartTime,
              end_time: card.shiftEndTime,
              color: undefined,
            });
          }

          // Create unique key to avoid duplicates
          const uniqueKey = `${card.shiftDate}-${shift.shiftId}-${card.userId}`;
          if (seenAssignments.has(uniqueKey)) {
            continue; // Skip duplicate
          }
          seenAssignments.add(uniqueKey);

          const assignment = ScheduleAssignment.create({
            assignment_id: card.shiftRequestId,
            user_id: card.userId,
            full_name: card.userName,
            date: card.shiftDate,
            shift,
            status: 'scheduled',
            is_approved: card.isApproved,
          });

          assignments.push(assignment);
        }

        console.log('✅ Created assignments from cards:', assignments.length);
      } else {
        console.warn('⚠️ No cards data available, falling back to schedule assignments');
        assignments = scheduleResult.assignments || [];
      }

      set({
        shifts: scheduleResult.shifts || [],
        assignments,
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

  // Action: Create assignment (v4 RPC)
  createAssignment: async (
    shiftId: string,
    employeeId: string,
    date: string,
    shiftStartTime: string,
    shiftEndTime: string,
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

      // 2. Call Repository (v4 with start/end time)
      const result = await repository.createAssignment(
        employeeId,
        shiftId,
        get().selectedStoreId || '',
        date,
        shiftStartTime,
        shiftEndTime,
        approvedBy
      );

      if (!result.success) {
        return {
          success: false,
          error: result.error || 'Failed to create assignment',
          errorCode: result.errorCode,
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
  openAddEmployeeModal: (date: string, shiftId?: string) => {
    set({ isAddEmployeeModalOpen: true, selectedDate: date, selectedShiftId: shiftId || null });
  },

  closeAddEmployeeModal: () => {
    set({ isAddEmployeeModalOpen: false, selectedDate: '', selectedShiftId: null });
  },

  setAddingEmployee: (loading: boolean) => {
    set({ addingEmployee: loading });
  },

  // Action: Approval modal state
  openApprovalModal: (assignment) => {
    set({ isApprovalModalOpen: true, selectedAssignment: assignment });
  },

  closeApprovalModal: () => {
    set({ isApprovalModalOpen: false, selectedAssignment: null });
  },

  setUpdatingApproval: (loading: boolean) => {
    set({ updatingApproval: loading });
  },

  // Action: Toggle approval status
  toggleApproval: async (shiftRequestIds: string[], userId: string) => {
    try {
      const result = await repository.toggleApproval(shiftRequestIds, userId);
      return result;
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
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
      selectedShiftId: null,
      addingEmployee: false,
      isApprovalModalOpen: false,
      selectedAssignment: null,
      updatingApproval: false,
      notification: null,
    });
  },
}));
