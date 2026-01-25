/**
 * useEmployees Hook
 * Custom hook wrapper for employee setting store (2025 Best Practice)
 */

import { useEmployeeSettingStore } from '../providers/employee_setting_provider';

/**
 * Custom hook that provides access to employee setting state and actions
 * Uses Zustand store for state management
 */
export const useEmployees = () => {
  // Select state (optimized selectors to prevent unnecessary re-renders)
  const employees = useEmployeeSettingStore((state) => state.employees);
  const stats = useEmployeeSettingStore((state) => state.stats);
  const loading = useEmployeeSettingStore((state) => state.loading);
  const error = useEmployeeSettingStore((state) => state.error);

  const isEditModalOpen = useEmployeeSettingStore((state) => state.isEditModalOpen);
  const selectedEmployee = useEmployeeSettingStore((state) => state.selectedEmployee);
  const deleteConfirm = useEmployeeSettingStore((state) => state.deleteConfirm);
  const searchQuery = useEmployeeSettingStore((state) => state.searchQuery);
  const storeFilter = useEmployeeSettingStore((state) => state.storeFilter);

  const filteredEmployees = useEmployeeSettingStore((state) => state.filteredEmployees);

  // Select actions
  const setEmployees = useEmployeeSettingStore((state) => state.setEmployees);
  const setStats = useEmployeeSettingStore((state) => state.setStats);
  const setLoading = useEmployeeSettingStore((state) => state.setLoading);
  const setError = useEmployeeSettingStore((state) => state.setError);

  const openEditModal = useEmployeeSettingStore((state) => state.openEditModal);
  const closeEditModal = useEmployeeSettingStore((state) => state.closeEditModal);
  const openDeleteConfirm = useEmployeeSettingStore((state) => state.openDeleteConfirm);
  const closeDeleteConfirm = useEmployeeSettingStore((state) => state.closeDeleteConfirm);
  const setSearchQuery = useEmployeeSettingStore((state) => state.setSearchQuery);
  const setStoreFilter = useEmployeeSettingStore((state) => state.setStoreFilter);

  const loadEmployees = useEmployeeSettingStore((state) => state.loadEmployees);
  const refreshEmployees = useEmployeeSettingStore((state) => state.refreshEmployees);
  const deleteEmployee = useEmployeeSettingStore((state) => state.deleteEmployee);

  return {
    // State
    employees,
    stats,
    loading,
    error,
    isEditModalOpen,
    selectedEmployee,
    deleteConfirm,
    searchQuery,
    storeFilter,
    filteredEmployees,

    // Actions
    setEmployees,
    setStats,
    setLoading,
    setError,
    openEditModal,
    closeEditModal,
    openDeleteConfirm,
    closeDeleteConfirm,
    setSearchQuery,
    setStoreFilter,
    loadEmployees,
    refreshEmployees,
    deleteEmployee,
  };
};
