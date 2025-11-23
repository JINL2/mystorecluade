/**
 * useInventoryHandlers Hook
 * Event handlers and utility functions for inventory page
 *
 * Following ARCHITECTURE.md:
 * - Extract complex logic into hooks (≤ 30KB for TS files)
 * - Separate business logic from components
 */

import { useCallback } from 'react';
import type { InventoryItem } from '../../domain/entities/InventoryItem';

interface UseInventoryHandlersProps {
  inventory: InventoryItem[];
  filteredAndSortedInventory: InventoryItem[];
  currencySymbol: string;
  toggleProductSelection: (productId: string) => void;
  clearSelection: () => void;
  openModal: (product: any) => void;
  openAddProductModal: () => void;
  showNotification: (variant: 'success' | 'error' | 'info', message: string) => void;
  statusStyles: {
    statusOutOfStock: string;
    statusLowStock: string;
    statusInStock: string;
    quantityOut: string;
    quantityLow: string;
    quantityNegative: string;
  };
}

interface UseInventoryHandlersReturn {
  formatCurrency: (amount: number) => string;
  handleSelectAll: (e: React.ChangeEvent<HTMLInputElement>) => void;
  handleCheckboxChange: (productId: string) => void;
  handleEditProduct: (productId: string) => void;
  handleDeleteProducts: () => void;
  handleAddProduct: () => void;
  getStatusInfo: (item: any) => { class: string; text: string };
  getQuantityClass: (quantity: number) => string;
}

export const useInventoryHandlers = ({
  inventory,
  filteredAndSortedInventory,
  currencySymbol,
  toggleProductSelection,
  clearSelection,
  openModal,
  openAddProductModal,
  showNotification,
  statusStyles,
}: UseInventoryHandlersProps): UseInventoryHandlersReturn => {
  // Helper function to format currency
  const formatCurrency = useCallback(
    (amount: number): string => {
      const formatted = amount.toLocaleString('en-US', {
        minimumFractionDigits: 0,
        maximumFractionDigits: 0,
      });
      return `${currencySymbol}${formatted}`;
    },
    [currencySymbol]
  );

  // Handle select all checkbox (only visible filtered products)
  const handleSelectAll = useCallback(
    (e: React.ChangeEvent<HTMLInputElement>) => {
      if (e.target.checked) {
        // Select only filtered products, not all products
        clearSelection();
        filteredAndSortedInventory.forEach((item) => {
          toggleProductSelection(item.productId);
        });
      } else {
        clearSelection();
      }
    },
    [filteredAndSortedInventory, toggleProductSelection, clearSelection]
  );

  // Handle individual checkbox
  const handleCheckboxChange = useCallback(
    (productId: string) => {
      toggleProductSelection(productId);
    },
    [toggleProductSelection]
  );

  // Handle edit product
  const handleEditProduct = useCallback(
    (productId: string) => {
      const product = inventory.find((item) => item.productId === productId);
      if (product) {
        openModal(product);
      }
    },
    [inventory, openModal]
  );

  // Handle delete products
  const handleDeleteProducts = useCallback(() => {
    // TODO: Show delete confirmation modal
    showNotification('info', 'Delete functionality will be implemented soon');
  }, [showNotification]);

  // Handle add product
  const handleAddProduct = useCallback(() => {
    openAddProductModal();
  }, [openAddProductModal]);

  // Get status info
  const getStatusInfo = useCallback(
    (item: any) => {
      const quantity = item.currentStock;

      if (quantity === 0) {
        return { class: statusStyles.statusOutOfStock, text: 'OUT OF STOCK' };
      } else if (quantity <= 5) {
        return { class: statusStyles.statusLowStock, text: 'LOW STOCK' };
      } else {
        return { class: statusStyles.statusInStock, text: 'IN STOCK' };
      }
    },
    [statusStyles]
  );

  // Get quantity class
  const getQuantityClass = useCallback(
    (quantity: number) => {
      if (quantity < 0) {
        return statusStyles.quantityNegative;
      } else if (quantity === 0) {
        return statusStyles.quantityOut;
      } else if (quantity <= 5) {
        return statusStyles.quantityLow;
      }
      return '';
    },
    [statusStyles]
  );

  return {
    formatCurrency,
    handleSelectAll,
    handleCheckboxChange,
    handleEditProduct,
    handleDeleteProducts,
    handleAddProduct,
    getStatusInfo,
    getQuantityClass,
  };
};
