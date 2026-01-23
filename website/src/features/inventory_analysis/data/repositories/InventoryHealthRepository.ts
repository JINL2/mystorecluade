/**
 * InventoryHealth Repository
 * Repository layer for inventory health dashboard data
 */

import {
  inventoryHealthDataSource,
  GetInventoryHealthParams,
} from '../datasources/InventoryHealthDataSource';
import type { InventoryHealthDashboard } from '../../domain/entities/inventoryHealthDashboard';

export class InventoryHealthRepository {
  async getInventoryHealth(params: GetInventoryHealthParams): Promise<InventoryHealthDashboard> {
    return inventoryHealthDataSource.getInventoryHealth(params);
  }
}

// Singleton instance
export const inventoryHealthRepository = new InventoryHealthRepository();
