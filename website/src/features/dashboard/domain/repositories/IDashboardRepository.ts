/**
 * Dashboard Repository Interface
 * Domain layer - Contract for dashboard data operations
 */

import { DashboardData } from '../entities/DashboardData';

export interface DashboardDataResult {
  success: boolean;
  data?: DashboardData;
  error?: string;
}

export interface IDashboardRepository {
  /**
   * Get dashboard data for a specific company and date
   * @param companyId - Company identifier
   * @param date - Date for dashboard data (ISO string)
   * @returns DashboardDataResult with data or error
   */
  getDashboardData(companyId: string, date: string): Promise<DashboardDataResult>;
}
