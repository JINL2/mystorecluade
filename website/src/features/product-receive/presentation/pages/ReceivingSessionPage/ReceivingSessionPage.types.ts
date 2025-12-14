/**
 * ReceivingSessionPage Types
 * Type definitions for the receiving session page
 */

// Session info from inventory_get_session_detail RPC
export interface SessionInfo {
  session_id: string;
  session_type: 'receiving' | 'counting';
  store_id: string;
  store_name: string;
  shipment_id: string | null;
  shipment_number: string | null;
  is_active: boolean;
  is_final: boolean;
  created_by: string;
  created_by_name: string;
  created_at: string;
  member_count?: number;
}

// Shipment data passed from ProductReceivePage
export interface ShipmentData {
  shipment_id: string;
  shipment_number: string;
  tracking_number: string | null;
  shipped_date: string;
  supplier_id: string | null;
  supplier_name: string;
  status: 'pending' | 'process' | 'complete' | 'cancelled';
  item_count: number;
  total_amount?: number;
  notes: string | null;
  items?: ShipmentItem[];
  receiving_summary?: ReceivingSummary;
}

// Shipment item with receiving progress
export interface ShipmentItem {
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
  total_amount?: number;
}

// Receiving summary
export interface ReceivingSummary {
  total_shipped: number;
  total_received: number;
  total_accepted: number;
  total_rejected: number;
  total_remaining: number;
  progress_percentage: number;
}

// Navigation state passed from ProductReceivePage
export interface ReceivingSessionLocationState {
  sessionData: SessionInfo | null;
  shipmentId: string | null;
  shipmentData: ShipmentData | null;
  isNewSession: boolean;
}

// Session member
export interface SessionMember {
  member_id: string;
  user_id: string;
  user_name: string;
  is_active: boolean;
  joined_at: string;
}

// Shipment item for receiving
export interface ReceivingItem {
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

// Receiving entry (individual count entry)
export interface ReceivingEntry {
  entry_id: string;
  item_id: string;
  quantity: number;
  status: 'accepted' | 'rejected';
  notes: string | null;
  created_by: string;
  created_by_name: string;
  created_at: string;
}
