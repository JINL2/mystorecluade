/**
 * InventoryHealth DataSource
 * Handles Supabase RPC calls for inventory health dashboard
 */

import { supabaseService } from '@/core/services/supabase.service';
import {
  InventoryHealthDashboard,
  mapInventoryHealthFromRpc,
} from '../../domain/entities/inventoryHealthDashboard';

export interface GetInventoryHealthParams {
  companyId: string;
}

export class InventoryHealthDataSource {
  async getInventoryHealth(params: GetInventoryHealthParams): Promise<InventoryHealthDashboard> {
    const rpcParams: Record<string, unknown> = {
      p_company_id: params.companyId,
    };

    const data = await supabaseService.rpc<Record<string, unknown>>(
      'get_inventory_health_dashboard',
      rpcParams
    );

    return mapInventoryHealthFromRpc(data);
  }
}

// Singleton instance
export const inventoryHealthDataSource = new InventoryHealthDataSource();
