/**
 * useShipmentCreateSearch Hook
 * Handles product search functionality for shipment creation
 */

import { useState, useEffect, useCallback, useRef, useMemo } from 'react';
import { getShipmentRepository } from '../../data/repositories/ShipmentRepositoryImpl';
import type {
  Currency,
  InventoryProduct,
} from '../pages/ShipmentCreatePage/ShipmentCreatePage.types';

interface UseShipmentCreateSearchProps {
  companyId: string | undefined;
  storeId: string | undefined;
  onCurrencyChange: (currency: Currency) => void;
}

export const useShipmentCreateSearch = ({
  companyId,
  storeId,
  onCurrencyChange,
}: UseShipmentCreateSearchProps) => {
  const repository = useMemo(() => getShipmentRepository(), []);
  const searchInputRef = useRef<HTMLInputElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);
  const [searchQuery, setSearchQuery] = useState<string>('');
  const [searchResults, setSearchResults] = useState<InventoryProduct[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);

  // Search products using Repository
  const searchProducts = useCallback(
    async (query: string) => {
      if (!query.trim()) {
        setSearchResults([]);
        setShowDropdown(false);
        return;
      }

      if (!companyId || !storeId) {
        setSearchResults([]);
        setShowDropdown(false);
        return;
      }

      setIsSearching(true);
      try {
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
        const result = await repository.searchProducts(
          companyId,
          storeId,
          query.trim(),
          userTimezone
        );

        if (!result.success) {
          console.error('🔍 Product search error:', result.error);
          setSearchResults([]);
          return;
        }

        if (result.data?.products) {
          setSearchResults(result.data.products);
          if (result.data.currency) {
            onCurrencyChange(result.data.currency);
          }
          setShowDropdown(true);
        } else {
          setSearchResults([]);
          setShowDropdown(true);
        }
      } catch (err) {
        console.error('🔍 Product search error:', err);
        setSearchResults([]);
      } finally {
        setIsSearching(false);
      }
    },
    [companyId, storeId, onCurrencyChange, repository]
  );

  // Debounced search effect
  useEffect(() => {
    const timer = setTimeout(() => {
      if (searchQuery.trim()) {
        searchProducts(searchQuery);
      } else {
        setSearchResults([]);
        setShowDropdown(false);
      }
    }, 300);

    return () => clearTimeout(timer);
  }, [searchQuery, searchProducts]);

  // Close dropdown on click outside
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        dropdownRef.current &&
        !dropdownRef.current.contains(event.target as Node) &&
        searchInputRef.current &&
        !searchInputRef.current.contains(event.target as Node)
      ) {
        setShowDropdown(false);
      }
    };

    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, []);

  // Clear search
  const clearSearch = useCallback(() => {
    setSearchQuery('');
    setSearchResults([]);
    setShowDropdown(false);
  }, []);

  return {
    searchInputRef,
    dropdownRef,
    searchQuery,
    setSearchQuery,
    searchResults,
    isSearching,
    showDropdown,
    setShowDropdown,
    clearSearch,
  };
};
