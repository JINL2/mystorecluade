/**
 * useProductSearch Hook
 * Handles product search functionality with debouncing
 */

import { useState, useRef, useEffect, useCallback } from 'react';
import { supabaseService } from '@/core/services/supabase_service';
import type { InventoryProduct, Currency } from '../pages/OrderCreatePage/OrderCreatePage.types';

interface UseProductSearchProps {
  companyId: string | undefined;
  storeId: string | undefined;
  onCurrencyUpdate?: (currency: Currency) => void;
}

export const useProductSearch = ({
  companyId,
  storeId,
  onCurrencyUpdate,
}: UseProductSearchProps) => {
  const searchInputRef = useRef<HTMLInputElement>(null);
  const dropdownRef = useRef<HTMLDivElement>(null);

  const [searchQuery, setSearchQuery] = useState<string>('');
  const [searchResults, setSearchResults] = useState<InventoryProduct[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [showDropdown, setShowDropdown] = useState(false);

  // Search products using RPC
  const searchProducts = useCallback(
    async (query: string) => {
      console.log('🔍 searchProducts called:', { query, companyId, storeId });

      if (!query.trim()) {
        setSearchResults([]);
        setShowDropdown(false);
        return;
      }

      if (!companyId || !storeId) {
        console.warn('🔍 Missing companyId or storeId:', { companyId, storeId });
        setSearchResults([]);
        setShowDropdown(false);
        return;
      }

      setIsSearching(true);
      try {
        const supabase = supabaseService.getClient();
        const userTimezone = Intl.DateTimeFormat().resolvedOptions().timeZone;

        console.log('🔍 Calling RPC with params:', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_page: 1,
          p_limit: 10,
          p_search: query.trim(),
          p_timezone: userTimezone,
        });

        const { data, error } = await supabase.rpc('get_inventory_page_v3', {
          p_company_id: companyId,
          p_store_id: storeId,
          p_page: 1,
          p_limit: 10,
          p_search: query.trim(),
          p_timezone: userTimezone,
        });

        console.log('🔍 RPC response:', { data, error });

        if (error) {
          console.error('🔍 Search error:', error);
          setSearchResults([]);
          return;
        }

        if (data?.success && data?.data?.products) {
          console.log('🔍 Products found:', data.data.products.length);
          setSearchResults(data.data.products);
          if (onCurrencyUpdate && data.data.currency) {
            onCurrencyUpdate(data.data.currency);
          }
          setShowDropdown(true);
        } else {
          console.log('🔍 No products or invalid response:', data);
          setSearchResults([]);
          setShowDropdown(true); // Show "no results" message
        }
      } catch (err) {
        console.error('🔍 Search error:', err);
        setSearchResults([]);
      } finally {
        setIsSearching(false);
      }
    },
    [companyId, storeId, onCurrencyUpdate]
  );

  // Debounced search
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

  // Clear search after product is added
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
