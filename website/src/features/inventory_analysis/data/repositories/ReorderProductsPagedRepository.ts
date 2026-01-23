/**
 * ReorderProductsPaged Repository
 * Repository layer for reorder products paged data
 */

import {
  reorderProductsPagedDataSource,
  GetReorderProductsPagedParams,
} from '../datasources/ReorderProductsPagedDataSource';
import type { ReorderProductsPaged } from '../../domain/entities/reorderProductsPaged';

export class ReorderProductsPagedRepository {
  async getReorderProductsPaged(params: GetReorderProductsPagedParams): Promise<ReorderProductsPaged> {
    return reorderProductsPagedDataSource.getReorderProductsPaged(params);
  }
}

// Singleton instance
export const reorderProductsPagedRepository = new ReorderProductsPagedRepository();
