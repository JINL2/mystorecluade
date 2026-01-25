/**
 * useInventoryPagination Hook
 * Client-side pagination logic for inventory
 *
 * Following ARCHITECTURE.md:
 * - Extract complex logic into hooks (≤ 30KB for TS files)
 * - Separate business logic from components
 */

import { useMemo } from 'react';
import type { InventoryItem } from '../../domain/entities/InventoryItem';

interface UseInventoryPaginationProps {
  filteredInventory: InventoryItem[];
  currentPage: number;
  itemsPerPage: number;
}

interface UseInventoryPaginationReturn {
  paginatedInventory: InventoryItem[];
  totalFilteredItems: number;
  totalPages: number;
}

export const useInventoryPagination = ({
  filteredInventory,
  currentPage,
  itemsPerPage,
}: UseInventoryPaginationProps): UseInventoryPaginationReturn => {
  // Calculate total number of filtered items
  const totalFilteredItems = filteredInventory.length;

  // Calculate total number of pages
  const totalPages = Math.ceil(totalFilteredItems / itemsPerPage);

  // Get paginated inventory for current page
  const paginatedInventory = useMemo(() => {
    const startIndex = (currentPage - 1) * itemsPerPage;
    const endIndex = startIndex + itemsPerPage;
    return filteredInventory.slice(startIndex, endIndex);
  }, [filteredInventory, currentPage, itemsPerPage]);

  return {
    paginatedInventory,
    totalFilteredItems,
    totalPages,
  };
};
