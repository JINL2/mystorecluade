/**
 * useInventoryFilters Hook
 * Client-side filtering and sorting logic for inventory
 *
 * Following ARCHITECTURE.md:
 * - Extract complex logic into hooks (≤ 30KB for TS files)
 * - Separate business logic from components
 */

import { useMemo } from 'react';
import type { InventoryItem } from '../../domain/entities/InventoryItem';

export type FilterType = 'newest' | 'oldest' | 'price_high' | 'price_low' | 'cost_high' | 'cost_low' | 'brand' | 'category';

interface UseInventoryFiltersProps {
  inventory: InventoryItem[];
  searchQuery: string;
  filterType: FilterType;
  selectedBrandFilter: Set<string>;
  selectedCategoryFilter: Set<string>;
}

interface UseInventoryFiltersReturn {
  uniqueBrands: string[];
  uniqueCategories: string[];
  filteredAndSortedInventory: InventoryItem[];
}

export const useInventoryFilters = ({
  inventory,
  searchQuery,
  filterType,
  selectedBrandFilter,
  selectedCategoryFilter,
}: UseInventoryFiltersProps): UseInventoryFiltersReturn => {
  // Get unique brands from inventory for filter dropdown
  const uniqueBrands = useMemo(() => {
    if (!inventory || inventory.length === 0) return [];
    const brands = Array.from(new Set(inventory.map((item) => item.brandName).filter(Boolean)));
    return brands.sort();
  }, [inventory]);

  // Get unique categories from inventory for filter dropdown
  const uniqueCategories = useMemo(() => {
    if (!inventory || inventory.length === 0) return [];
    const categories = Array.from(new Set(inventory.map((item) => item.categoryName).filter(Boolean)));
    return categories.sort();
  }, [inventory]);

  // Client-side filtering and sorting
  const filteredAndSortedInventory = useMemo(() => {
    let result = [...inventory];

    // 1. Apply search filter
    if (searchQuery.trim()) {
      const query = searchQuery.toLowerCase().trim();
      result = result.filter((item) => {
        return (
          item.productName.toLowerCase().includes(query) ||
          item.sku.toLowerCase().includes(query)
        );
      });
    }

    // 2. Apply brand filter (multi-select)
    if (selectedBrandFilter.size > 0) {
      result = result.filter((item) => selectedBrandFilter.has(item.brandName || ''));
    }

    // 3. Apply category filter (multi-select)
    if (selectedCategoryFilter.size > 0) {
      result = result.filter((item) => selectedCategoryFilter.has(item.categoryName));
    }

    // 4. Apply sorting
    switch (filterType) {
      case 'newest':
        // Already sorted by created_at DESC in provider (newest first)
        break;

      case 'oldest':
        // Reverse order - oldest first
        result = result.reverse();
        break;

      case 'price_high':
        // Sort by selling price (unitPrice) - highest first
        result = result.sort((a, b) => b.unitPrice - a.unitPrice);
        break;

      case 'price_low':
        // Sort by selling price (unitPrice) - lowest first
        result = result.sort((a, b) => a.unitPrice - b.unitPrice);
        break;

      case 'cost_high':
        // Sort by cost price - highest first
        result = result.sort((a, b) => b.costPrice - a.costPrice);
        break;

      case 'cost_low':
        // Sort by cost price - lowest first
        result = result.sort((a, b) => a.costPrice - b.costPrice);
        break;

      case 'brand':
      case 'category':
        // When brand or category filter is active, keep existing order (newest first)
        break;
    }

    return result;
  }, [inventory, searchQuery, filterType, selectedBrandFilter, selectedCategoryFilter]);

  return {
    uniqueBrands,
    uniqueCategories,
    filteredAndSortedInventory,
  };
};
