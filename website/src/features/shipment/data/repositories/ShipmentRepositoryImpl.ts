/**
 * ShipmentRepositoryImpl
 * Implementation of IShipmentRepository
 * Connects presentation layer to data source through clean architecture
 */

import type {
  IShipmentRepository,
  RepositoryResult,
  ShipmentListFilters,
  ShipmentDetailParams,
  CreateShipmentRequest,
  CreateShipmentResponse,
} from '../../domain/repositories/IShipmentRepository';
import type {
  ShipmentListItem,
  ShipmentDetail,
  Counterparty,
  OrderInfo,
  InventoryProduct,
  Currency,
} from '../../domain/types';
import { ShipmentDataSource, getShipmentDataSource } from '../datasources/ShipmentDataSource';
import { ShipmentModel } from '../models/ShipmentModel';

// ===== Repository Implementation =====

export class ShipmentRepositoryImpl implements IShipmentRepository {
  private dataSource: ShipmentDataSource;

  constructor(dataSource?: ShipmentDataSource) {
    this.dataSource = dataSource || getShipmentDataSource();
  }

  // ===== Shipment CRUD Operations =====

  /**
   * Get list of shipments with filters
   */
  async getShipmentList(filters: ShipmentListFilters): Promise<RepositoryResult<ShipmentListItem[]>> {
    try {
      const response = await this.dataSource.getShipmentList({
        companyId: filters.companyId,
        timezone: filters.timezone,
        fromDate: filters.fromDate,
        toDate: filters.toDate,
        statusFilter: filters.statusFilter,
        supplierFilter: filters.supplierFilter,
        orderFilter: filters.orderFilter,
      });

      if (!response.success) {
        return {
          success: false,
          error: response.error || 'Failed to fetch shipments',
        };
      }

      // Apply search filter on client side (if RPC doesn't support it)
      let shipments = ShipmentModel.fromRpcList(response.data || []);

      if (filters.searchQuery) {
        const query = filters.searchQuery.toLowerCase().trim();
        shipments = shipments.filter(
          (s) =>
            s.shipment_number.toLowerCase().includes(query) ||
            s.supplier_name.toLowerCase().includes(query) ||
            (s.tracking_number && s.tracking_number.toLowerCase().includes(query))
        );
      }

      return {
        success: true,
        data: shipments,
      };
    } catch (err) {
      console.error('📦 ShipmentRepositoryImpl.getShipmentList error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch shipments',
      };
    }
  }

  /**
   * Get shipment detail by ID
   */
  async getShipmentDetail(params: ShipmentDetailParams): Promise<RepositoryResult<ShipmentDetail>> {
    try {
      const response = await this.dataSource.getShipmentDetail({
        shipmentId: params.shipmentId,
        companyId: params.companyId,
        timezone: params.timezone,
      });

      if (!response.success || !response.data) {
        return {
          success: false,
          error: response.error || 'Failed to fetch shipment detail',
        };
      }

      return {
        success: true,
        data: ShipmentModel.fromRpcDetail(response.data),
      };
    } catch (err) {
      console.error('📦 ShipmentRepositoryImpl.getShipmentDetail error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch shipment detail',
      };
    }
  }

  /**
   * Create a new shipment
   */
  async createShipment(request: CreateShipmentRequest): Promise<CreateShipmentResponse> {
    try {
      const response = await this.dataSource.createShipment({
        companyId: request.companyId,
        userId: request.userId,
        items: request.items,
        time: request.time,
        timezone: request.timezone,
        orderIds: request.orderIds,
        counterpartyId: request.counterpartyId,
        supplierInfo: request.supplierInfo,
        trackingNumber: request.trackingNumber,
        notes: request.notes,
        shipmentNumber: request.shipmentNumber,
      });

      return {
        success: response.success,
        shipment_number: response.shipment_number,
        message: response.message || response.error,
      };
    } catch (err) {
      console.error('📦 ShipmentRepositoryImpl.createShipment error:', err);
      return {
        success: false,
        message: err instanceof Error ? err.message : 'Failed to create shipment',
      };
    }
  }

  // ===== Supporting Data Operations =====

  /**
   * Get list of counterparties (suppliers)
   */
  async getCounterparties(companyId: string): Promise<RepositoryResult<Counterparty[]>> {
    try {
      const response = await this.dataSource.getCounterparties(companyId);

      if (!response.success) {
        return {
          success: false,
          error: response.error || 'Failed to fetch counterparties',
        };
      }

      return {
        success: true,
        data: response.data || [],
      };
    } catch (err) {
      console.error('🏢 ShipmentRepositoryImpl.getCounterparties error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch counterparties',
      };
    }
  }

  /**
   * Get list of orders available for shipment
   */
  async getOrders(companyId: string, timezone: string): Promise<RepositoryResult<OrderInfo[]>> {
    try {
      const response = await this.dataSource.getOrders({
        companyId,
        timezone,
      });

      if (!response.success) {
        return {
          success: false,
          error: response.error || 'Failed to fetch orders',
        };
      }

      return {
        success: true,
        data: response.data || [],
      };
    } catch (err) {
      console.error('📋 ShipmentRepositoryImpl.getOrders error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to fetch orders',
      };
    }
  }

  /**
   * Get base currency for company
   */
  async getBaseCurrency(companyId: string): Promise<RepositoryResult<Currency>> {
    try {
      const response = await this.dataSource.getBaseCurrency(companyId);

      return {
        success: true,
        data: ShipmentModel.fromRpcCurrency(response.base_currency || null),
      };
    } catch (err) {
      console.error('💰 ShipmentRepositoryImpl.getBaseCurrency error:', err);
      return {
        success: true,
        data: { symbol: '₩', code: 'KRW' }, // Default fallback
      };
    }
  }

  /**
   * Search products by query (v6: variant support)
   */
  async searchProducts(
    companyId: string,
    storeId: string,
    query: string,
    timezone: string
  ): Promise<RepositoryResult<{ items: InventoryProduct[]; currency?: Currency }>> {
    try {
      const response = await this.dataSource.searchProducts({
        companyId,
        storeId,
        query,
        timezone,
      });

      if (!response.success) {
        return {
          success: false,
          error: response.error || 'Failed to search products',
        };
      }

      // v6 response structure: data.items instead of data.products
      return {
        success: true,
        data: {
          items: response.data?.items || [],
          currency: response.data?.currency,
        },
      };
    } catch (err) {
      console.error('🔍 ShipmentRepositoryImpl.searchProducts error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to search products',
      };
    }
  }

  /**
   * Search product by exact SKU
   */
  async searchProductBySku(
    companyId: string,
    storeId: string,
    sku: string,
    timezone: string
  ): Promise<RepositoryResult<InventoryProduct | null>> {
    try {
      const product = await this.dataSource.searchProductBySku({
        companyId,
        storeId,
        sku,
        timezone,
      });

      return {
        success: true,
        data: product,
      };
    } catch (err) {
      console.error('📦 ShipmentRepositoryImpl.searchProductBySku error:', err);
      return {
        success: false,
        error: err instanceof Error ? err.message : 'Failed to search product by SKU',
      };
    }
  }
}

// ===== Singleton Instance =====

let repositoryInstance: ShipmentRepositoryImpl | null = null;

export const getShipmentRepository = (): IShipmentRepository => {
  if (!repositoryInstance) {
    repositoryInstance = new ShipmentRepositoryImpl();
  }
  return repositoryInstance;
};

// ===== Factory Function =====

export const createShipmentRepository = (dataSource?: ShipmentDataSource): IShipmentRepository => {
  return new ShipmentRepositoryImpl(dataSource);
};
