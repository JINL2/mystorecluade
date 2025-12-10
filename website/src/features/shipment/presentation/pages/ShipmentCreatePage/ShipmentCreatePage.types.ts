/**
 * ShipmentCreatePage Types
 * Type definitions for ShipmentCreatePage component
 * Re-exports common types from consolidated types file
 */

// Re-export common types from domain types file
export type {
  Currency,
  Counterparty,
  OrderInfo,
  OrderItem,
  ShipmentItem,
  InventoryProduct,
  SaveResult,
  ImportError,
  OneTimeSupplier,
  SelectionMode,
  SupplierOption,
} from '../../../domain/types';

// Props for ShipmentCreatePage component (if needed)
export interface ShipmentCreatePageProps {
  // Currently no props needed, but exported for consistency
}
