/**
 * SalesAnalytics Repository
 * Repository layer for sales analytics data
 */

import {
  salesAnalyticsDataSource,
  GetSalesAnalyticsParams,
} from '../datasources/SalesAnalyticsDataSource';
import type { SalesAnalytics } from '../../domain/entities/salesAnalytics';

export class SalesAnalyticsRepository {
  async getSalesAnalytics(params: GetSalesAnalyticsParams): Promise<SalesAnalytics> {
    return salesAnalyticsDataSource.getSalesAnalytics(params);
  }
}

// Singleton instance
export const salesAnalyticsRepository = new SalesAnalyticsRepository();
