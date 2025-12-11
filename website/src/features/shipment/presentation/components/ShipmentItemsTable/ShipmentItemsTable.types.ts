/**
 * ShipmentItemsTable Types
 */

import type { ShipmentItem, InventoryProduct, Currency } from '../../../domain/types';

export interface ShipmentItemsTableProps {
  // Items
  items: ShipmentItem[];
  currency: Currency;
  totalAmount: number;
  onRemoveItem: (orderItemId: string) => void;
  onQuantityChange: (orderItemId: string, quantity: number) => void;
  onCostChange: (index: number, cost: number) => void;
  formatPrice: (price: number) => string;

  // Product Search
  searchInputRef: React.RefObject<HTMLInputElement>;
  dropdownRef: React.RefObject<HTMLDivElement>;
  searchQuery: string;
  onSearchQueryChange: (query: string) => void;
  searchResults: InventoryProduct[];
  isSearching: boolean;
  showDropdown: boolean;
  onShowDropdownChange: (show: boolean) => void;
  onAddProductFromSearch: (product: InventoryProduct) => void;

  // Import/Export
  fileInputRef: React.RefObject<HTMLInputElement>;
  isImporting: boolean;
  onImportClick: () => void;
  onFileChange: (e: React.ChangeEvent<HTMLInputElement>) => void;
  onExportSample: () => void;
}
