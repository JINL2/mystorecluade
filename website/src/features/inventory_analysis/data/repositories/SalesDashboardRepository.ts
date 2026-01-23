/**
 * SalesDashboardRepository
 * Repository for sales dashboard data operations
 */

import { salesDashboardDataSource, type GetSalesDashboardParams } from '../datasources/SalesDashboardDataSource';
import type { SalesDashboard } from '../../domain/entities/salesDashboard';

export class SalesDashboardRepository {
  /**
   * Get sales dashboard data
   */
  async getSalesDashboard(params: GetSalesDashboardParams): Promise<SalesDashboard> {
    return salesDashboardDataSource.getSalesDashboard(params);
  }
}

export const salesDashboardRepository = new SalesDashboardRepository();
