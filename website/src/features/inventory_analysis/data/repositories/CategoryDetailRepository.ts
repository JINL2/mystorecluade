/**
 * CategoryDetail Repository
 * Repository layer for category detail data
 */

import {
  categoryDetailDataSource,
  GetCategoryDetailParams,
} from '../datasources/CategoryDetailDataSource';
import type { CategoryDetail } from '../../domain/entities/categoryDetail';

export class CategoryDetailRepository {
  async getCategoryDetail(params: GetCategoryDetailParams): Promise<CategoryDetail> {
    return categoryDetailDataSource.getCategoryDetail(params);
  }
}

// Singleton instance
export const categoryDetailRepository = new CategoryDetailRepository();
