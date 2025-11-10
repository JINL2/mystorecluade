/**
 * TrackingDataSource
 * Data source for tracking operations
 */

import { supabaseService } from '@/core/services/supabase_service';

export class TrackingDataSource {
  async getTrackingItems(companyId: string, storeId: string) {
    const supabase = supabaseService.getClient();

    const { data, error } = await supabase.rpc('get_store_inventory_tracking', {
      p_company_id: companyId,
      p_store_id: storeId,
    });

    if (error) {
      console.error('Error fetching tracking items:', error);
      throw new Error(error.message);
    }

    return data || [];
  }
}
