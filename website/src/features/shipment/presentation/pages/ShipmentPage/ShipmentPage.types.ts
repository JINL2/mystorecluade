/**
 * ShipmentPage Types
 * Type definitions for ShipmentPage component
 * Re-exports common types from consolidated types file
 */

// Re-export common types from domain types file
export type {
  Currency,
  Counterparty,
  OrderInfo,
  DatePreset,
  ShipmentListItem as Shipment,
  ShipmentFilters,
  SupplierOption,
} from '../../../domain/types';

export { SHIPMENT_STATUS_OPTIONS } from '../../../domain/types';

// Page-specific types

// Custom date picker state
export interface DatePickerState {
  showDatePicker: boolean;
  tempFromDate: string;
  tempToDate: string;
}

// Props for ShipmentPage component (if needed)
export interface ShipmentPageProps {
  // Currently no props needed, but exported for consistency
}
