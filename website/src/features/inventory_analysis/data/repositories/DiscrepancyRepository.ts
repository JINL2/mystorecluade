/**
 * Discrepancy Repository
 * Repository layer for discrepancy overview data
 */

import {
  discrepancyDataSource,
  GetDiscrepancyOverviewParams,
} from '../datasources/DiscrepancyDataSource';
import type { DiscrepancyOverview } from '../../domain/entities/discrepancyOverview';

export class DiscrepancyRepository {
  async getDiscrepancyOverview(params: GetDiscrepancyOverviewParams): Promise<DiscrepancyOverview> {
    return discrepancyDataSource.getDiscrepancyOverview(params);
  }
}

// Singleton instance
export const discrepancyRepository = new DiscrepancyRepository();
