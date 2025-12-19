/**
 * useSchedule Hook
 * Presentation layer - Custom hook wrapper for schedule provider (2025 Best Practice)
 */

import { useEffect } from 'react';
import { useScheduleStore } from '../providers/schedule_provider';

/**
 * Custom hook that wraps the Zustand schedule store
 * Provides selective access to state and actions
 */
export const useSchedule = (companyId: string, initialStoreId?: string) => {
  // Select only needed state (optimized for re-renders)
  const shifts = useScheduleStore((state) => state.shifts);
  const assignments = useScheduleStore((state) => state.assignments);
  const employees = useScheduleStore((state) => state.employees);
  const loading = useScheduleStore((state) => state.loading);
  const loadingEmployees = useScheduleStore((state) => state.loadingEmployees);
  const error = useScheduleStore((state) => state.error);
  const currentWeek = useScheduleStore((state) => state.currentWeek);
  const selectedStoreId = useScheduleStore((state) => state.selectedStoreId);
  const isAddEmployeeModalOpen = useScheduleStore((state) => state.isAddEmployeeModalOpen);
  const selectedDate = useScheduleStore((state) => state.selectedDate);
  const selectedShiftId = useScheduleStore((state) => state.selectedShiftId);
  const addingEmployee = useScheduleStore((state) => state.addingEmployee);
  const isApprovalModalOpen = useScheduleStore((state) => state.isApprovalModalOpen);
  const selectedAssignment = useScheduleStore((state) => state.selectedAssignment);
  const updatingApproval = useScheduleStore((state) => state.updatingApproval);
  const notification = useScheduleStore((state) => state.notification);

  // Select actions
  const loadScheduleData = useScheduleStore((state) => state.loadScheduleData);
  const loadEmployees = useScheduleStore((state) => state.loadEmployees);
  const goToPreviousWeek = useScheduleStore((state) => state.goToPreviousWeek);
  const goToNextWeek = useScheduleStore((state) => state.goToNextWeek);
  const goToCurrentWeek = useScheduleStore((state) => state.goToCurrentWeek);
  const getWeekRange = useScheduleStore((state) => state.getWeekRange);
  const getWeekDays = useScheduleStore((state) => state.getWeekDays);
  const getAssignmentsForDate = useScheduleStore((state) => state.getAssignmentsForDate);
  const _createAssignment = useScheduleStore((state) => state.createAssignment);
  const setSelectedStore = useScheduleStore((state) => state.setSelectedStore);
  const openAddEmployeeModal = useScheduleStore((state) => state.openAddEmployeeModal);
  const closeAddEmployeeModal = useScheduleStore((state) => state.closeAddEmployeeModal);
  const setAddingEmployee = useScheduleStore((state) => state.setAddingEmployee);
  const openApprovalModal = useScheduleStore((state) => state.openApprovalModal);
  const closeApprovalModal = useScheduleStore((state) => state.closeApprovalModal);
  const setUpdatingApproval = useScheduleStore((state) => state.setUpdatingApproval);
  const toggleApproval = useScheduleStore((state) => state.toggleApproval);
  const showNotification = useScheduleStore((state) => state.showNotification);
  const clearNotification = useScheduleStore((state) => state.clearNotification);

  // Wrapper to add shift start/end time lookup (v4 RPC)
  const createAssignment = async (
    shiftId: string,
    employeeId: string,
    date: string,
    approvedBy: string
  ) => {
    // Debug: Log available shifts and search parameters
    console.group('🔍 createAssignment - Shift Lookup (v4)');
    console.log('Looking for shiftId:', shiftId);
    console.log('Available shifts:', shifts);
    console.log('Shifts count:', shifts.length);
    console.log('Shift IDs:', shifts.map(s => ({ id: s.shiftId, name: s.shiftName, startTime: s.startTime, endTime: s.endTime })));
    console.groupEnd();

    // Find the shift to get its start and end time
    const shift = shifts.find(s => s.shiftId === shiftId);
    if (!shift) {
      console.error('❌ Shift not found! shiftId:', shiftId);
      return {
        success: false,
        error: 'Shift not found',
      };
    }

    console.log('✅ Shift found:', { id: shift.shiftId, name: shift.shiftName, startTime: shift.startTime, endTime: shift.endTime });

    // Call the store action with shift start and end time (v4)
    return _createAssignment(shiftId, employeeId, date, shift.startTime, shift.endTime, approvedBy);
  };

  // Load data when companyId, selectedStoreId, or currentWeek changes
  useEffect(() => {
    if (companyId && selectedStoreId) {
      loadScheduleData(companyId, selectedStoreId);
      loadEmployees(companyId, selectedStoreId);
    }
  }, [companyId, selectedStoreId, currentWeek, loadScheduleData, loadEmployees]);

  // Refresh function that reloads with current params
  const refresh = () => {
    if (companyId && selectedStoreId) {
      loadScheduleData(companyId, selectedStoreId);
    }
  };

  return {
    // State
    shifts,
    assignments,
    employees,
    loading,
    loadingEmployees,
    error,
    currentWeek,
    selectedStoreId,
    isAddEmployeeModalOpen,
    selectedDate,
    selectedShiftId,
    addingEmployee,
    isApprovalModalOpen,
    selectedAssignment,
    updatingApproval,
    notification,

    // Actions
    refresh,
    goToPreviousWeek,
    goToNextWeek,
    goToCurrentWeek,
    getWeekRange,
    getWeekDays,
    getAssignmentsForDate,
    createAssignment,
    setSelectedStore,
    openAddEmployeeModal,
    closeAddEmployeeModal,
    setAddingEmployee,
    openApprovalModal,
    closeApprovalModal,
    setUpdatingApproval,
    toggleApproval,
    showNotification,
    clearNotification,
  };
};
