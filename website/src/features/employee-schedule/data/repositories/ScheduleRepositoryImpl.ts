/**
 * Schedule Repository Implementation
 * Data layer - Implements IScheduleRepository interface
 */

import type {
  IScheduleRepository,
  ScheduleDataResult,
  EmployeesResult,
} from '../../domain/repositories/IScheduleRepository';
import { ScheduleEmployee } from '../../domain/entities/ScheduleEmployee';
import { ScheduleAssignment } from '../../domain/entities/ScheduleAssignment';
import { ScheduleDataSource } from '../datasources/ScheduleDataSource';
import { ScheduleModel } from '../models/ScheduleModel';

export class ScheduleRepositoryImpl implements IScheduleRepository {
  private dataSource: ScheduleDataSource;

  constructor() {
    this.dataSource = new ScheduleDataSource();
  }

  async getScheduleData(
    companyId: string,
    storeId: string,
    startDate: string,
    endDate: string
  ): Promise<ScheduleDataResult> {
    try {
      const result = await this.dataSource.getScheduleData(companyId, storeId, startDate, endDate);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to fetch schedule data',
        };
      }

      const { shifts, assignments } = ScheduleModel.fromSupabase(result.data);

      return {
        success: true,
        shifts,
        assignments,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async getEmployees(companyId: string, storeId: string): Promise<EmployeesResult> {
    try {
      const result = await this.dataSource.getEmployees(companyId, storeId);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to fetch employees',
        };
      }

      // Convert raw data to ScheduleEmployee entities
      const employees = result.data.map(
        (emp) =>
          new ScheduleEmployee(
            emp.user_id,
            emp.full_name,
            emp.email,
            emp.role_ids || [],
            emp.role_names || [],
            emp.stores || [],
            emp.company_id,
            emp.company_name,
            emp.salary_id,
            emp.salary_amount,
            emp.salary_type,
            emp.bonus_amount,
            emp.currency_id,
            emp.currency_code,
            emp.account_id
          )
      );

      return {
        success: true,
        employees,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async createAssignment(
    userId: string,
    shiftId: string,
    storeId: string,
    date: string,
    approvedBy: string
  ): Promise<{ success: boolean; error?: string }> {
    try {
      const result = await this.dataSource.createAssignment(
        userId,
        shiftId,
        storeId,
        date,
        approvedBy
      );

      return result;
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }

  async updateAssignment(
    assignmentId: string,
    data: Partial<ScheduleAssignment>
  ): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.updateAssignment(assignmentId, data);
  }

  async deleteAssignment(assignmentId: string): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.deleteAssignment(assignmentId);
  }
}
