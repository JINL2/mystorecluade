/**
 * TrackingRepositoryImpl
 * Implementation of ITrackingRepository interface
 */

import { ITrackingRepository, TrackingResult } from '../../domain/repositories/ITrackingRepository';
import { TrackingItem } from '../../domain/entities/TrackingItem';
import { TrackingDataSource } from '../datasources/TrackingDataSource';

export class TrackingRepositoryImpl implements ITrackingRepository {
  private dataSource: TrackingDataSource;

  constructor() {
    this.dataSource = new TrackingDataSource();
  }

  async getTrackingItems(companyId: string, storeId: string): Promise<TrackingResult> {
    try {
      const data = await this.dataSource.getTrackingItems(companyId, storeId);

      const items = data.map(
        (item: any) =>
          new TrackingItem(
            item.product_id,
            item.sku,
            item.product_name,
            item.category_name,
            item.brand_name,
            item.current_stock,
            item.min_stock,
            item.max_stock,
            item.unit_price,
            item.currency_symbol || '₩'
          )
      );

      return {
        success: true,
        data: items,
      };
    } catch (error) {
      console.error('Repository error fetching tracking items:', error);
      return {
        success: false,
        error: error instanceof Error ? error.message : 'Failed to fetch tracking items',
      };
    }
  }
}
