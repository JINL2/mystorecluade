/**
 * StoreSelector Types
 * Type definitions for the reusable StoreSelector component
 */

export interface Store {
  store_id: string;
  store_name: string;
}

export interface StoreSelectorProps {
  /**
   * Array of stores to display in the dropdown
   * Can be stores from any company
   */
  stores: Store[];

  /**
   * Currently selected store ID
   * null represents "All Stores" option
   */
  selectedStoreId: string | null;

  /**
   * Callback function when a store is selected
   * @param storeId - Selected store ID or null for "All Stores"
   */
  onStoreSelect: (storeId: string | null) => void;

  /**
   * Optional company ID for multi-company support
   * Used for filtering or contextual display
   */
  companyId?: string;

  /**
   * Optional custom width for the selector
   * Default: 280px
   * Example: '300px', '20rem', '100%'
   */
  width?: string;

  /**
   * Optional maximum height for the dropdown
   * Default: 380px
   * Example: '400px', '25rem'
   */
  maxHeight?: string;

  /**
   * Optional custom class name for additional styling
   */
  className?: string;

  /**
   * Optional flag to show "All Stores" option
   * Default: true
   */
  showAllStoresOption?: boolean;

  /**
   * Optional custom label for "All Stores" option
   * Default: "All Stores"
   * Example: "모든 매장" (for Korean)
   */
  allStoresLabel?: string;

  /**
   * Optional flag to disable the selector
   * Default: false
   */
  disabled?: boolean;
}
