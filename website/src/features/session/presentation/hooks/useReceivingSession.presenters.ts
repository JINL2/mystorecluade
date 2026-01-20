/**
 * useReceivingSession Presenters
 * Functions to convert store state to presentation format for backward compatibility
 */

import type {
  SessionInfo,
  ShipmentData,
} from '../pages/ReceivingSessionPage/ReceivingSessionPage.types';
import type { ReceivingSessionState } from '../providers/states/receiving_session_state';
import type { CompareSessionsResult } from '../../domain/entities';

/**
 * Convert receivedEntries to presentation format
 */
export const toReceivedEntriesPresentation = (
  receivedEntries: ReceivingSessionState['receivedEntries']
) => receivedEntries.map(e => ({
  entry_id: e.entryId,
  product_id: e.productId,
  product_name: e.productName,
  sku: e.sku,
  quantity: e.quantity,
  created_at: e.createdAt,
}));

/**
 * Convert sessionInfo to presentation format
 */
export const toSessionInfoPresentation = (
  sessionInfo: ReceivingSessionState['sessionInfo']
): SessionInfo | null => {
  if (!sessionInfo) return null;

  return {
    session_id: sessionInfo.sessionId,
    session_type: sessionInfo.sessionType as 'receiving' | 'counting',
    store_id: sessionInfo.storeId,
    store_name: sessionInfo.storeName,
    shipment_id: sessionInfo.shipmentId,
    shipment_number: sessionInfo.shipmentNumber,
    is_active: sessionInfo.isActive,
    is_final: sessionInfo.isFinal,
    created_by: sessionInfo.createdBy,
    created_by_name: sessionInfo.createdByName,
    created_at: sessionInfo.createdAt,
    member_count: sessionInfo.memberCount,
  };
};

/**
 * Convert shipmentData to presentation format
 */
export const toShipmentDataPresentation = (
  shipmentData: ReceivingSessionState['shipmentData']
): ShipmentData | null => {
  if (!shipmentData) return null;

  return {
    shipment_id: shipmentData.shipmentId,
    shipment_number: shipmentData.shipmentNumber,
    tracking_number: null,
    supplier_id: null,
    supplier_name: shipmentData.supplierName,
    status: shipmentData.status as 'pending' | 'process' | 'complete' | 'cancelled',
    shipped_date: shipmentData.shippedDate,
    item_count: shipmentData.items.length,
    notes: null,
    items: shipmentData.items.map(item => ({
      item_id: item.itemId,
      product_id: item.productId,
      product_name: item.productName,
      sku: item.sku,
      quantity_shipped: item.quantityShipped,
      quantity_received: item.quantityReceived,
      quantity_accepted: item.quantityAccepted,
      quantity_rejected: item.quantityRejected,
      quantity_remaining: item.quantityRemaining,
      unit_cost: item.unitCost,
    })),
    receiving_summary: shipmentData.receivingSummary ? {
      total_shipped: shipmentData.receivingSummary.totalShipped,
      total_received: shipmentData.receivingSummary.totalReceived,
      total_accepted: shipmentData.receivingSummary.totalAccepted,
      total_rejected: shipmentData.receivingSummary.totalRejected,
      total_remaining: shipmentData.receivingSummary.totalRemaining,
      progress_percentage: shipmentData.receivingSummary.progressPercentage,
    } : undefined,
  };
};

/**
 * Comparison result presentation type
 */
export interface ComparisonResultPresentation {
  sessionA: {
    sessionId: string;
    sessionName: string;
    storeName: string;
    totalProducts: number;
    totalQuantity: number;
  };
  sessionB: {
    sessionId: string;
    sessionName: string;
    storeName: string;
    totalProducts: number;
    totalQuantity: number;
  };
  matched: {
    productId: string;
    sku: string;
    productName: string;
    quantityA: number;
    quantityB: number;
    quantityDiff: number;
    isMatch: boolean;
  }[];
  onlyInA: {
    productId: string;
    sku: string;
    productName: string;
    quantity: number;
  }[];
  onlyInB: {
    productId: string;
    sku: string;
    productName: string;
    quantity: number;
  }[];
  summary: {
    totalMatched: number;
    quantitySameCount: number;
    quantityDiffCount: number;
    onlyInACount: number;
    onlyInBCount: number;
  };
}

/**
 * Convert comparison result for presentation
 */
export const toComparisonResultPresentation = (
  comparisonResult: CompareSessionsResult | null
): ComparisonResultPresentation | null => {
  if (!comparisonResult) return null;

  return {
    sessionA: {
      sessionId: comparisonResult.sessionA.sessionId,
      sessionName: comparisonResult.sessionA.sessionName,
      storeName: comparisonResult.sessionA.storeName,
      totalProducts: comparisonResult.sessionA.totalProducts,
      totalQuantity: comparisonResult.sessionA.totalQuantity,
    },
    sessionB: {
      sessionId: comparisonResult.sessionB.sessionId,
      sessionName: comparisonResult.sessionB.sessionName,
      storeName: comparisonResult.sessionB.storeName,
      totalProducts: comparisonResult.sessionB.totalProducts,
      totalQuantity: comparisonResult.sessionB.totalQuantity,
    },
    matched: comparisonResult.comparison.matched.map(item => ({
      productId: item.productId,
      sku: item.sku,
      productName: item.productName,
      quantityA: item.quantityA,
      quantityB: item.quantityB,
      quantityDiff: item.quantityDiff,
      isMatch: item.isMatch,
    })),
    onlyInA: comparisonResult.comparison.onlyInA.map(item => ({
      productId: item.productId,
      sku: item.sku,
      productName: item.productName,
      quantity: item.quantity,
    })),
    onlyInB: comparisonResult.comparison.onlyInB.map(item => ({
      productId: item.productId,
      sku: item.sku,
      productName: item.productName,
      quantity: item.quantity,
    })),
    summary: {
      totalMatched: comparisonResult.summary.totalMatched,
      quantitySameCount: comparisonResult.summary.quantitySameCount,
      quantityDiffCount: comparisonResult.summary.quantityDiffCount,
      onlyInACount: comparisonResult.summary.onlyInACount,
      onlyInBCount: comparisonResult.summary.onlyInBCount,
    },
  };
};
