/**
 * Employee Setting Zustand Provider
 * Central state management for employee-setting feature (2025 Best Practice)
 */

import { create } from 'zustand';
import { EmployeeSettingState } from './states/employee_setting_state';
import { EmployeeRepositoryImpl } from '../../data/repositories/EmployeeRepositoryImpl';
import { EmployeeStats } from '../../domain/entities/EmployeeStats';

// Repository instance
const repository = new EmployeeRepositoryImpl();

/**
 * Employee Setting Store
 * Zustand store for employee-setting feature state management
 */
export const useEmployeeSettingStore = create<EmployeeSettingState>((set, get) => ({
  // ==================== Initial State ====================

  // Data state
  employees: [],
  stats: EmployeeStats.empty(),
  loading: false,
  error: null,

  // UI state
  isEditModalOpen: false,
  selectedEmployee: null,
  deleteConfirm: null,
  searchQuery: '',
  storeFilter: null,

  // ==================== Computed Values ====================

  get filteredEmployees() {
    const { employees, searchQuery, storeFilter } = get();
    let filtered = [...employees];

    // Filter by store
    if (storeFilter) {
      filtered = filtered.filter((emp) => emp.storeId === storeFilter);
    }

    // Filter by search query
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase();
      filtered = filtered.filter(
        (emp) =>
          emp.fullName.toLowerCase().includes(query) ||
          emp.email.toLowerCase().includes(query) ||
          emp.displayRole.toLowerCase().includes(query)
      );
    }

    return filtered;
  },

  // ==================== Data Actions ====================

  setEmployees: (employees) => set({ employees }),

  setStats: (stats) => set({ stats }),

  setLoading: (loading) => set({ loading }),

  setError: (error) => set({ error }),

  // ==================== UI Actions ====================

  openEditModal: (userId) => {
    const employee = get().employees.find((emp) => emp.userId === userId);
    if (employee) {
      set({
        selectedEmployee: {
          userId: employee.userId,
          fullName: employee.fullName,
          email: employee.email,
          roleName: employee.displayRole,
          storeName: employee.displayStore,
          salaryType: employee.salaryType,
          salaryAmount: employee.salaryAmount,
          currencyId: employee.currencyId,
          currencyCode: employee.currencyCode,
          salaryId: employee.salaryId,
          companyId: employee.companyId,
          accountId: employee.accountId,
          initials: employee.initials,
        },
        isEditModalOpen: true,
      });
    }
  },

  closeEditModal: () => {
    set({
      isEditModalOpen: false,
      selectedEmployee: null,
    });
  },

  openDeleteConfirm: (userId) => {
    const employee = get().employees.find((emp) => emp.userId === userId);
    if (employee) {
      set({
        deleteConfirm: {
          userId: employee.userId,
          name: employee.fullName,
        },
      });
    }
  },

  closeDeleteConfirm: () => {
    set({ deleteConfirm: null });
  },

  setSearchQuery: (query) => {
    set({ searchQuery: query });
  },

  setStoreFilter: (storeId) => {
    set({ storeFilter: storeId });
  },

  // ==================== Async Actions ====================

  loadEmployees: async (companyId) => {
    set({ loading: true, error: null });

    try {
      const { storeFilter, searchQuery } = get();

      const result = await repository.getEmployees({
        companyId,
        storeId: storeFilter,
        searchQuery,
      });

      if (!result.success) {
        set({
          error: result.error || 'Failed to load employees',
          employees: [],
          stats: EmployeeStats.empty(),
        });
        return;
      }

      set({
        employees: result.employees || [],
        stats: result.stats || EmployeeStats.empty(),
        error: null,
      });
    } catch (err) {
      set({
        error: err instanceof Error ? err.message : 'An unexpected error occurred',
        employees: [],
        stats: EmployeeStats.empty(),
      });
    } finally {
      set({ loading: false });
    }
  },

  refreshEmployees: async () => {
    // Refresh uses the last loaded company ID
    // This assumes the component will call loadEmployees with companyId initially
    const state = get();
    if (state.employees.length > 0) {
      // Get companyId from first employee (they all have same companyId)
      const companyId = state.employees[0]?.companyId;
      if (companyId) {
        await get().loadEmployees(companyId);
      }
    }
  },

  deleteEmployee: async (_companyId) => {
    const { deleteConfirm } = get();
    if (!deleteConfirm) {
      return { success: false, error: 'No employee selected for deletion' };
    }

    set({ loading: true, error: null });

    try {
      // TODO: Implement actual delete RPC call
      // const result = await repository.deleteEmployee(_companyId, deleteConfirm.userId);

      console.log('Delete employee:', deleteConfirm.userId);

      // Close delete confirmation
      get().closeDeleteConfirm();

      // Refresh employee list
      await get().refreshEmployees();

      return { success: true };
    } catch (err) {
      const errorMessage = err instanceof Error ? err.message : 'Failed to delete employee';
      set({ error: errorMessage });
      return { success: false, error: errorMessage };
    } finally {
      set({ loading: false });
    }
  },
}));
