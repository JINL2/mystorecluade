/**
 * BcgMatrix Repository
 * Repository layer for BCG Matrix V2 data
 */

import {
  bcgMatrixDataSource,
  GetBcgMatrixParams,
} from '../datasources/BcgMatrixDataSource';
import type { BcgMatrix } from '../../domain/entities/bcgMatrix';

export class BcgMatrixRepository {
  async getBcgMatrix(params: GetBcgMatrixParams): Promise<BcgMatrix> {
    return bcgMatrixDataSource.getBcgMatrix(params);
  }
}

// Singleton instance
export const bcgMatrixRepository = new BcgMatrixRepository();
