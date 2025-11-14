/**
 * Employee Setting State Interface
 * Defines the state shape for employee-setting feature
 */

import { Employee } from '../../../domain/entities/Employee';
import { EmployeeStats } from '../../../domain/entities/EmployeeStats';
import { SelectedEmployeeData, DeleteConfirmData, SubmitResult } from './types';

/**
 * Employee Setting state interface
 * Includes data state, UI state, and actions
 */
export interface EmployeeSettingState {
  // ==================== Data State ====================
  employees: Employee[];
  stats: EmployeeStats;
  loading: boolean;
  error: string | null;

  // ==================== UI State ====================
  isEditModalOpen: boolean;
  selectedEmployee: SelectedEmployeeData | null;
  deleteConfirm: DeleteConfirmData | null;
  searchQuery: string;
  storeFilter: string | null;

  // ==================== Computed Values ====================
  filteredEmployees: Employee[];

  // ==================== Data Actions ====================
  setEmployees: (employees: Employee[]) => void;
  setStats: (stats: EmployeeStats) => void;
  setLoading: (loading: boolean) => void;
  setError: (error: string | null) => void;

  // ==================== UI Actions ====================
  openEditModal: (userId: string) => void;
  closeEditModal: () => void;
  openDeleteConfirm: (userId: string) => void;
  closeDeleteConfirm: () => void;
  setSearchQuery: (query: string) => void;
  setStoreFilter: (storeId: string | null) => void;

  // ==================== Async Actions ====================
  loadEmployees: (companyId: string) => Promise<void>;
  refreshEmployees: () => Promise<void>;
  deleteEmployee: (companyId: string) => Promise<SubmitResult>;
}
