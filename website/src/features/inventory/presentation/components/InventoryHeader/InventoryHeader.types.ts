/**
 * InventoryHeader Component Types
 * Type definitions for the inventory header component
 */

import type { FilterType } from '../../providers/states/inventory_state';

export interface InventoryHeaderProps {
  /**
   * Current search query
   */
  searchQuery: string;

  /**
   * Callback when search query changes
   */
  onSearchChange: (query: string) => void;

  /**
   * Number of selected products
   */
  selectedCount: number;

  /**
   * Whether export operation is in progress
   */
  isExporting: boolean;

  /**
   * Whether import operation is in progress
   */
  isImporting: boolean;

  /**
   * Total number of inventory items
   */
  totalItems: number;

  /**
   * Filter type for mobile dropdown
   */
  filterType: FilterType;

  /**
   * Selected brand filter (multi-select)
   */
  selectedBrandFilter: Set<string>;

  /**
   * Selected category filter (multi-select)
   */
  selectedCategoryFilter: Set<string>;

  /**
   * Available brands for filtering
   */
  brands: string[];

  /**
   * Available categories for filtering
   */
  categories: string[];

  /**
   * Callback when delete button is clicked
   */
  onDelete: () => void;

  /**
   * Callback when move selected button is clicked
   */
  onMoveSelected: () => void;

  /**
   * Callback when export button is clicked
   */
  onExport: () => void;

  /**
   * Callback when import button is clicked
   */
  onImport: () => void;

  /**
   * Callback when add product button is clicked
   */
  onAddProduct: () => void;

  /**
   * Callback when filter type changes
   */
  onFilterChange: (filterType: FilterType) => void;

  /**
   * Callback when brand filter toggles (multi-select)
   */
  onBrandFilterToggle: (brand: string) => void;

  /**
   * Callback when category filter toggles (multi-select)
   */
  onCategoryFilterToggle: (category: string) => void;

  /**
   * Callback to clear all brand filters
   */
  onClearBrandFilter: () => void;

  /**
   * Callback to clear all category filters
   */
  onClearCategoryFilter: () => void;

  /**
   * Ref for hidden file input
   */
  fileInputRef: React.RefObject<HTMLInputElement>;

  /**
   * Callback when file is selected for import
   */
  onFileChange: (event: React.ChangeEvent<HTMLInputElement>) => void;
}
