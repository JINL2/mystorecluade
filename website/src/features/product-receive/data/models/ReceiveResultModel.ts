/**
 * ReceiveResultModel
 * DTO and Mapper for ReceiveResult entity
 */

import { ReceiveResult, ReceiveResultEntity } from '../../domain/entities/ReceiveResult';

/**
 * DTO from Supabase RPC response
 */
export interface ReceiveResponseDTO {
  success: boolean;
  receipt_number?: string;
  message?: string;
  received_count?: number;
  warnings?: string[];
}

/**
 * DTO for submit receive request
 */
export interface ReceiveItemDTO {
  product_id: string;
  quantity_received: number;
}

/**
 * Mapper class for ReceiveResult
 */
export class ReceiveResultModel {
  /**
   * Convert DTO to Domain Entity
   */
  static fromDTO(dto: ReceiveResponseDTO): ReceiveResult {
    return new ReceiveResultEntity({
      success: dto.success,
      receiptNumber: dto.receipt_number,
      message: dto.message,
      receivedCount: dto.received_count,
      warnings: dto.warnings,
      error: dto.success ? undefined : dto.message,
    });
  }

  /**
   * Convert Domain Entity to DTO (for API requests)
   */
  static toDTO(entity: ReceiveResult): ReceiveResponseDTO {
    return {
      success: entity.success,
      receipt_number: entity.receiptNumber,
      message: entity.message,
      received_count: entity.receivedCount,
      warnings: entity.warnings,
    };
  }
}
