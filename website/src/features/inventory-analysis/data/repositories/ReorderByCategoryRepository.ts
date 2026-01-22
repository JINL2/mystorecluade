/**
 * ReorderByCategory Repository
 * Repository layer for reorder by category data
 */

import {
  reorderByCategoryDataSource,
  GetReorderByCategoryParams,
} from '../datasources/ReorderByCategoryDataSource';
import type { CategoryReorderItem } from '../../domain/entities/reorderByCategory';

export class ReorderByCategoryRepository {
  async getReorderByCategory(params: GetReorderByCategoryParams): Promise<CategoryReorderItem[]> {
    return reorderByCategoryDataSource.getReorderByCategory(params);
  }
}

// Singleton instance
export const reorderByCategoryRepository = new ReorderByCategoryRepository();
