/**
 * ShipmentDetailPage Types
 * Type definitions for ShipmentDetailPage component
 * Re-exports common types from consolidated types file
 */

// Re-export common types from domain types file
export type {
  Currency,
  ShipmentDetail,
  ShipmentDetailItem as ShipmentItem,
  LinkedOrder,
  ShipmentStatus,
} from '../../../domain/types';

// Props for ShipmentDetailPage component (if needed)
export interface ShipmentDetailPageProps {
  // Currently no props needed, but exported for consistency
}
