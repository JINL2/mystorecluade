/**
 * OrderProductModel
 * DTO and Mapper for OrderProduct entity
 */

import { OrderProduct, OrderProductEntity } from '../../domain/entities/OrderProduct';

/**
 * DTO from Supabase RPC
 */
export interface OrderProductDTO {
  product_id: string;
  sku: string;
  product_name: string;
  barcode?: string;
  quantity_ordered: number;
  quantity_received_total: number;
  unit_price?: number;
  total_amount?: number;
}

/**
 * Mapper class for OrderProduct
 */
export class OrderProductModel {
  /**
   * Convert DTO to Domain Entity
   */
  static fromDTO(dto: OrderProductDTO): OrderProduct {
    return new OrderProductEntity({
      productId: dto.product_id,
      sku: dto.sku,
      productName: dto.product_name,
      quantityOrdered: dto.quantity_ordered || 0,
      quantityReceived: dto.quantity_received_total || 0,
      quantityRemaining: (dto.quantity_ordered || 0) - (dto.quantity_received_total || 0),
      unit: '', // Not provided in the backup structure
    });
  }

  /**
   * Convert Domain Entity to DTO (for API requests)
   */
  static toDTO(entity: OrderProduct): Partial<OrderProductDTO> {
    return {
      product_id: entity.productId,
      sku: entity.sku,
      product_name: entity.productName,
      quantity_ordered: entity.quantityOrdered,
      quantity_received_total: entity.quantityReceived,
    };
  }

  /**
   * Convert array of DTOs to Domain Entities
   */
  static fromDTOArray(dtos: OrderProductDTO[]): OrderProduct[] {
    return dtos.map((dto) => OrderProductModel.fromDTO(dto));
  }
}
