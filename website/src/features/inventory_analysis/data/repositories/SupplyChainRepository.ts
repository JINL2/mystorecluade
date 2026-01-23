/**
 * SupplyChain Repository
 * Repository layer for supply chain status data
 */

import {
  supplyChainDataSource,
  GetSupplyChainStatusParams,
} from '../datasources/SupplyChainDataSource';
import type { SupplyChainStatus } from '../../domain/entities/supplyChainStatus';

export class SupplyChainRepository {
  async getSupplyChainStatus(params: GetSupplyChainStatusParams): Promise<SupplyChainStatus> {
    return supplyChainDataSource.getSupplyChainStatus(params);
  }
}

// Singleton instance
export const supplyChainRepository = new SupplyChainRepository();
