/**
 * IProductReceiveRepository
 * Repository interface for product receive operations
 */

import type {
  SearchProductResult,
  SessionItemsResult,
  SaveItem,
  SubmitItem,
  SubmitResult,
} from '../entities';

export interface IProductReceiveRepository {
  /**
   * Search products by query (SKU, barcode, or name)
   */
  searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page?: number,
    limit?: number
  ): Promise<SearchProductResult>;

  /**
   * Add items to a receiving session
   */
  addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItem[]
  ): Promise<void>;

  /**
   * Get all items in a receiving session
   */
  getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsResult>;

  /**
   * Submit a receiving session
   */
  submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItem[],
    isFinal: boolean
  ): Promise<SubmitResult>;
}
