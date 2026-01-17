/**
 * Shipment Models
 * DTO types for shipment-related data
 * Note: Mapper functions are defined in ProductReceiveRepositoryImpl.ts
 */

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
