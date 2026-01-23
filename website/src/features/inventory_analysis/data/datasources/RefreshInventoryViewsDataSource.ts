/**
 * RefreshInventoryViews DataSource
 * Handles Supabase RPC calls for refreshing inventory materialized views
 */

import { supabaseService } from '@/core/services/supabase.service';

export class RefreshInventoryViewsDataSource {
  async refreshViews(): Promise<void> {
    await supabaseService.rpc<void>(
      'refresh_inventory_optimization_views',
      {}
    );
  }
}

// Singleton instance
export const refreshInventoryViewsDataSource = new RefreshInventoryViewsDataSource();
