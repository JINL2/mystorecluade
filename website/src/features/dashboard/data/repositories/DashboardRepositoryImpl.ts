/**
 * Dashboard Repository Implementation
 * Data layer - Implements IDashboardRepository interface
 */

import type {
  IDashboardRepository,
  DashboardDataResult,
} from '../../domain/repositories/IDashboardRepository';
import { DashboardDataSource } from '../datasources/DashboardDataSource';
import { DashboardModel } from '../models/DashboardModel';

export class DashboardRepositoryImpl implements IDashboardRepository {
  private dataSource: DashboardDataSource;

  constructor() {
    this.dataSource = new DashboardDataSource();
  }

  async getDashboardData(companyId: string, date: string): Promise<DashboardDataResult> {
    try {
      const result = await this.dataSource.getDashboardData(companyId, date);

      if (!result.success || !result.data) {
        return {
          success: false,
          error: result.error || 'Failed to fetch dashboard data',
        };
      }

      const dashboardData = DashboardModel.fromSupabase(result.data);

      return {
        success: true,
        data: dashboardData,
      };
    } catch (error) {
      return {
        success: false,
        error: error instanceof Error ? error.message : 'An unexpected error occurred',
      };
    }
  }
}
