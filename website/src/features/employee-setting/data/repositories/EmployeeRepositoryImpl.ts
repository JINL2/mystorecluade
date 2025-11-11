/**
 * Employee Repository Implementation
 * Data layer - Implements IEmployeeRepository interface
 */

import type {
  IEmployeeRepository,
  EmployeeListResult,
  EmployeeFilterOptions,
} from '../../domain/repositories/IEmployeeRepository';
import { Employee } from '../../domain/entities/Employee';
import { EmployeeDataSource } from '../datasources/EmployeeDataSource';
import { EmployeeModel } from '../models/EmployeeModel';

export class EmployeeRepositoryImpl implements IEmployeeRepository {
  private dataSource: EmployeeDataSource;

  constructor() {
    this.dataSource = new EmployeeDataSource();
  }

  async getEmployees(options: EmployeeFilterOptions): Promise<EmployeeListResult> {
    try {
      const result = await this.dataSource.getEmployees(options.companyId, options.storeId);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to fetch employees',
        };
      }

      // Convert raw data to domain entities
      let employees = result.data.map((rawData) => EmployeeModel.fromSupabase(rawData));

      // Apply client-side search filter if provided
      if (options.searchQuery && options.searchQuery.trim() !== '') {
        const query = options.searchQuery.toLowerCase();
        employees = employees.filter(
          (emp) =>
            emp.fullName.toLowerCase().includes(query) ||
            emp.email.toLowerCase().includes(query) ||
            emp.roleName.toLowerCase().includes(query)
        );
      }

      // Calculate stats
      const stats = EmployeeModel.calculateStats(employees);

      return {
        success: true,
        employees,
        stats,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async getEmployeeById(_userId: string): Promise<Employee | null> {
    // TODO: Implement get single employee
    return null;
  }

  async createEmployee(data: Partial<Employee>): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.createEmployee(data);
  }

  async updateEmployee(
    userId: string,
    data: Partial<Employee>
  ): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.updateEmployee(userId, data);
  }

  async deleteEmployee(userId: string): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.deleteEmployee(userId);
  }

  async updateEmployeeSalary(
    salaryId: string,
    salaryAmount: number,
    salaryType: 'monthly' | 'hourly',
    currencyId: string
  ): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.updateEmployeeSalary(
      salaryId,
      salaryAmount,
      salaryType,
      currencyId
    );
  }
}
