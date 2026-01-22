/**
 * DrillDownAnalytics Repository
 * Repository layer for drill down analytics data
 */

import {
  drillDownAnalyticsDataSource,
  GetDrillDownAnalyticsParams,
} from '../datasources/DrillDownAnalyticsDataSource';
import type { DrillDownAnalytics } from '../../domain/entities/drillDownAnalytics';

export class DrillDownAnalyticsRepository {
  async getDrillDownAnalytics(params: GetDrillDownAnalyticsParams): Promise<DrillDownAnalytics> {
    return drillDownAnalyticsDataSource.getDrillDownAnalytics(params);
  }
}

// Singleton instance
export const drillDownAnalyticsRepository = new DrillDownAnalyticsRepository();
