/**
 * Schedule Repository Implementation
 * Data layer - Implements IScheduleRepository interface
 */

import type {
  IScheduleRepository,
  ScheduleDataResult,
} from '../../domain/repositories/IScheduleRepository';
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

  async createAssignment(
    data: Partial<ScheduleAssignment>
  ): Promise<{ success: boolean; error?: string }> {
    return await this.dataSource.createAssignment(data);
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
