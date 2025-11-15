/**
 * InventoryTableSection Component Types
 * Type definitions for inventory table section (table + pagination + empty state)
 */

import type { InventoryItem } from '../../../domain/entities/InventoryItem';

export interface InventoryTableSectionProps {
  /**
   * Filtered and paginated inventory items to display
   */
  items: InventoryItem[];

  /**
   * Total number of filtered items (for pagination info)
   */
  totalFilteredItems: number;

  /**
   * Current search query (for empty state message)
   */
  searchQuery: string;

  /**
   * Set of selected product IDs
   */
  selectedProducts: Set<string>;

  /**
   * Currency code for display
   */
  currencyCode: string;

  /**
   * Currency symbol for display
   */
  currencySymbol: string;

  /**
   * Current page number
   */
  currentPage: number;

  /**
   * Items per page
   */
  itemsPerPage: number;

  /**
   * Total number of pages
   */
  totalPages: number;

  /**
   * Currently expanded product ID
   */
  expandedProductId: string | null;

  /**
   * Whether all visible items are selected
   */
  isAllSelected: boolean;

  /**
   * Callback when select all checkbox changes
   */
  onSelectAll: (e: React.ChangeEvent<HTMLInputElement>) => void;

  /**
   * Callback when individual checkbox changes
   */
  onCheckboxChange: (productId: string) => void;

  /**
   * Callback when row is clicked to expand/collapse
   */
  onRowClick: (productId: string) => void;

  /**
   * Callback when edit product button is clicked
   */
  onEditProduct: (productId: string) => void;

  /**
   * Callback when page changes
   */
  onPageChange: (page: number) => void;

  /**
   * Helper function to format currency
   */
  formatCurrency: (amount: number) => string;

  /**
   * Helper function to get status info
   */
  getStatusInfo: (item: InventoryItem) => { text: string; className: string };

  /**
   * Helper function to get quantity class
   */
  getQuantityClass: (currentStock: number) => string;
}
