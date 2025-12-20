/**
 * Shipment Models
 * DTO types and mappers for shipment-related data
 */

import type {
  Shipment,
  ShipmentDetail,
  ShipmentItem,
  ReceivingSummary,
} from '../../domain/entities';

// ============ DTO Types ============

export interface ShipmentDTO {
  shipment_id: string;
  shipment_number: string;
  supplier_name: string;
  status: string;
  shipped_date: string;
  total_items: number;
  total_quantity: number;
  total_cost: number;
}

export interface ShipmentItemDTO {
  item_id: string;
  product_id: string;
  product_name: string;
  sku: string;
  quantity_shipped: number;
  quantity_received: number;
  quantity_accepted: number;
  quantity_rejected: number;
  quantity_remaining: number;
  unit_cost: number;
}

export interface ReceivingSummaryDTO {
  total_shipped: number;
  total_received: number;
  total_accepted: number;
  total_rejected: number;
  total_remaining: number;
  progress_percentage: number;
}

export interface ShipmentDetailDTO {
  shipment_id: string;
  shipment_number: string;
  supplier_id?: string;
  supplier_name: string;
  status: string;
  shipped_date: string;
  tracking_number?: string;
  notes?: string;
  items: ShipmentItemDTO[];
  receiving_summary?: ReceivingSummaryDTO;
}

// ============ Mapper Functions: DTO -> Domain Entity ============

export const mapShipmentDTO = (dto: ShipmentDTO): Shipment => ({
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  supplierName: dto.supplier_name,
  status: dto.status,
  shippedDate: dto.shipped_date,
  totalItems: dto.total_items,
  totalQuantity: dto.total_quantity,
  totalCost: dto.total_cost,
});

export const mapShipmentItemDTO = (dto: ShipmentItemDTO): ShipmentItem => ({
  itemId: dto.item_id,
  productId: dto.product_id,
  productName: dto.product_name,
  sku: dto.sku,
  quantityShipped: dto.quantity_shipped,
  quantityReceived: dto.quantity_received,
  quantityAccepted: dto.quantity_accepted,
  quantityRejected: dto.quantity_rejected,
  quantityRemaining: dto.quantity_remaining,
  unitCost: dto.unit_cost,
});

export const mapReceivingSummaryDTO = (dto: ReceivingSummaryDTO): ReceivingSummary => ({
  totalShipped: dto.total_shipped,
  totalReceived: dto.total_received,
  totalAccepted: dto.total_accepted,
  totalRejected: dto.total_rejected,
  totalRemaining: dto.total_remaining,
  progressPercentage: dto.progress_percentage,
});

export const mapShipmentDetailDTO = (dto: ShipmentDetailDTO): ShipmentDetail => ({
  shipmentId: dto.shipment_id,
  shipmentNumber: dto.shipment_number,
  supplierId: dto.supplier_id,
  supplierName: dto.supplier_name,
  status: dto.status,
  shippedDate: dto.shipped_date,
  trackingNumber: dto.tracking_number,
  notes: dto.notes,
  items: dto.items.map(mapShipmentItemDTO),
  receivingSummary: dto.receiving_summary ? mapReceivingSummaryDTO(dto.receiving_summary) : undefined,
});
