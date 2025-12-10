/**
 * ProductReceiveRepositoryImpl
 * Implementation of IProductReceiveRepository
 * Maps DataSource DTOs to Domain Entities
 */

import type { IProductReceiveRepository } from '../../domain/repositories/IProductReceiveRepository';
import type {
  SearchProductResult,
  SearchProduct,
  SessionItemsResult,
  SessionItem,
  SessionItemsSummary,
  SaveItem,
  SubmitItem,
  SubmitResult,
} from '../../domain/entities';
import {
  productReceiveDataSource,
  type IProductReceiveDataSource,
  type SearchProductDTO,
  type SessionItemDTO,
  type SessionItemsSummaryDTO,
} from '../datasources/ProductReceiveDataSource';

// Mapper functions: DTO -> Domain Entity
const mapSearchProductDTO = (dto: SearchProductDTO): SearchProduct => ({
  productId: dto.product_id,
  productName: dto.product_name,
  sku: dto.sku,
  barcode: dto.barcode,
  imageUrls: dto.image_urls,
  stock: {
    quantityOnHand: dto.stock.quantity_on_hand,
    quantityAvailable: dto.stock.quantity_available,
    quantityReserved: dto.stock.quantity_reserved,
  },
  price: {
    cost: dto.price.cost,
    selling: dto.price.selling,
    source: dto.price.source,
  },
});

const mapSessionItemDTO = (dto: SessionItemDTO): SessionItem => ({
  productId: dto.product_id,
  productName: dto.product_name,
  totalQuantity: dto.total_quantity,
  totalRejected: dto.total_rejected,
  scannedBy: dto.scanned_by.map((user) => ({
    userId: user.user_id,
    userName: user.user_name,
    quantity: user.quantity,
    quantityRejected: user.quantity_rejected,
  })),
});

const mapSessionItemsSummaryDTO = (dto: SessionItemsSummaryDTO): SessionItemsSummary => ({
  totalProducts: dto.total_products,
  totalQuantity: dto.total_quantity,
  totalRejected: dto.total_rejected,
});

// Mapper functions: Domain Entity -> DTO
const mapSaveItemToDTO = (item: SaveItem) => ({
  product_id: item.productId,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

const mapSubmitItemToDTO = (item: SubmitItem) => ({
  product_id: item.productId,
  quantity: item.quantity,
  quantity_rejected: item.quantityRejected,
});

export class ProductReceiveRepositoryImpl implements IProductReceiveRepository {
  constructor(private dataSource: IProductReceiveDataSource = productReceiveDataSource) {}

  async searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    page: number = 1,
    limit: number = 10
  ): Promise<SearchProductResult> {
    const result = await this.dataSource.searchProducts(
      companyId,
      storeId,
      query,
      page,
      limit
    );

    return {
      products: result.products.map(mapSearchProductDTO),
      currency: {
        symbol: result.currency.symbol,
        code: result.currency.code,
      },
    };
  }

  async addSessionItems(
    sessionId: string,
    userId: string,
    items: SaveItem[]
  ): Promise<void> {
    await this.dataSource.addSessionItems(
      sessionId,
      userId,
      items.map(mapSaveItemToDTO)
    );
  }

  async getSessionItems(
    sessionId: string,
    userId: string
  ): Promise<SessionItemsResult> {
    const result = await this.dataSource.getSessionItems(sessionId, userId);

    return {
      items: result.items.map(mapSessionItemDTO),
      summary: mapSessionItemsSummaryDTO(result.summary),
    };
  }

  async submitSession(
    sessionId: string,
    userId: string,
    items: SubmitItem[],
    isFinal: boolean
  ): Promise<SubmitResult> {
    const result = await this.dataSource.submitSession(
      sessionId,
      userId,
      items.map(mapSubmitItemToDTO),
      isFinal
    );

    return {
      receivingNumber: result.receiving_number,
      itemsCount: result.items_count,
      totalQuantity: result.total_quantity,
    };
  }
}

// Singleton instance
export const productReceiveRepository = new ProductReceiveRepositoryImpl();
