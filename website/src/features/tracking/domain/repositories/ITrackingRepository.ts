/**
 * ITrackingRepository Interface
 * Repository interface for tracking operations
 */

import { TrackingItem } from '../entities/TrackingItem';

export interface TrackingResult {
  success: boolean;
  data?: TrackingItem[];
  error?: string;
}

export interface ITrackingRepository {
  /**
   * Get tracking items for a store
   */
  getTrackingItems(companyId: string, storeId: string): Promise<TrackingResult>;
}
