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
  const addingEmployee = useScheduleStore((state) => state.addingEmployee);
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
  const createAssignment = useScheduleStore((state) => state.createAssignment);
  const setSelectedStore = useScheduleStore((state) => state.setSelectedStore);
  const openAddEmployeeModal = useScheduleStore((state) => state.openAddEmployeeModal);
  const closeAddEmployeeModal = useScheduleStore((state) => state.closeAddEmployeeModal);
  const setAddingEmployee = useScheduleStore((state) => state.setAddingEmployee);
  const showNotification = useScheduleStore((state) => state.showNotification);
  const clearNotification = useScheduleStore((state) => state.clearNotification);

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
    addingEmployee,
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
    showNotification,
    clearNotification,
  };
};
