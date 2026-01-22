/**
 * RefreshInventoryViews Repository
 * Repository layer for refreshing inventory materialized views
 */

import { refreshInventoryViewsDataSource } from '../datasources/RefreshInventoryViewsDataSource';

export class RefreshInventoryViewsRepository {
  async refreshViews(): Promise<void> {
    return refreshInventoryViewsDataSource.refreshViews();
  }
}

// Singleton instance
export const refreshInventoryViewsRepository = new RefreshInventoryViewsRepository();
