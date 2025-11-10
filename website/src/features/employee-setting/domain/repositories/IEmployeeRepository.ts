/**
 * Employee Repository Interface
 * Domain layer - Contract for employee data operations
 */

import { Employee } from '../entities/Employee';
import { EmployeeStats } from '../entities/EmployeeStats';

export interface EmployeeListResult {
  success: boolean;
  employees?: Employee[];
  stats?: EmployeeStats;
  error?: string;
}

export interface EmployeeFilterOptions {
  companyId: string;
  storeId?: string | null;
  searchQuery?: string;
}

export interface IEmployeeRepository {
  /**
   * Get employee list with optional filters
   * @param options - Filter options
   * @returns EmployeeListResult with employees and stats
   */
  getEmployees(options: EmployeeFilterOptions): Promise<EmployeeListResult>;

  /**
   * Get single employee by ID
   * @param userId - User identifier
   * @returns Employee or null
   */
  getEmployeeById(userId: string): Promise<Employee | null>;

  /**
   * Create new employee
   * @param data - Employee data
   * @returns Success status
   */
  createEmployee(data: Partial<Employee>): Promise<{ success: boolean; error?: string }>;

  /**
   * Update existing employee
   * @param userId - User identifier
   * @param data - Updated employee data
   * @returns Success status
   */
  updateEmployee(
    userId: string,
    data: Partial<Employee>
  ): Promise<{ success: boolean; error?: string }>;

  /**
   * Delete employee
   * @param userId - User identifier
   * @returns Success status
   */
  deleteEmployee(userId: string): Promise<{ success: boolean; error?: string }>;
}
